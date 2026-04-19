const express = require("express");
const http = require("http");
const { WebSocketServer } = require("ws");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcryptjs");
const fs = require("fs");
const path = require("path");
const morgan = require("morgan");

// --- Configuration ---
const API_PORT = 3001;
const WS_PORT = 3002;
const JWT_SECRET = "triage-sync-high-grade-secret-99";
const DB_PATH = path.join(__dirname, "db.json");

// --- Utility: DB Management ---
function getDB() {
    return JSON.parse(fs.readFileSync(DB_PATH, "utf-8"));
}

function saveDB(db) {
    fs.writeFileSync(DB_PATH, JSON.stringify(db, null, 2));
}

// --- App Initialization ---
const app = express();
app.use(express.json());
app.use(morgan("dev"));

// CORS shim
app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS");
    res.header("Access-Control-Allow-Headers", "Content-Type, Authorization");
    if (req.method === "OPTIONS") return res.sendStatus(200);
    next();
});

// --- Auth Middleware ---
function authenticateToken(req, res, next) {
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1];

    if (!token) {
        return res.status(401).json({
            code: "UNAUTHORIZED",
            message: "Authentication credentials were not provided."
        });
    }

    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            return res.status(401).json({
                code: "TOKEN_EXPIRED",
                message: "Your session has expired. Please log in again."
            });
        }
        req.user = user;
        next();
    });
}

function requireRole(roles) {
    return (req, res, next) => {
        if (!roles.includes(req.user.role)) {
            return res.status(403).json({
                code: "PERMISSION_DENIED",
                message: "You do not have permission to perform this action."
            });
        }
        next();
    };
}

// --- Routes: AUTH ---
app.post("/api/v1/auth/register/", (req, res) => {
    const { 
        name, email, password, role = "patient",
        gender = "", age = null, blood_type = "",
        health_history = "", allergies = "", current_medications = ""
    } = req.body;

    if (!name || !email || !password) {
        return res.status(400).json({ code: "VALIDATION_ERROR", message: "Name, email and password are required." });
    }

    const db = getDB();
    if (db.authUsers.find(u => u.email === email)) {
        return res.status(409).json({ code: "CONFLICT", message: "A user with this email already exists." });
    }

    const hashedPassword = bcrypt.hashSync(password, 8);
    const newUser = { 
        id: Date.now(), 
        name, email, password: hashedPassword, role,
        gender, age, blood_type, health_history, allergies, current_medications
    };
    
    db.authUsers.push(newUser);
    // Sync with adminUsers directory for UI consistency
    db.adminUsers.push({ id: newUser.id, name, email, role });
    saveDB(db);

    res.status(201).json({ message: "Account created successfully." });
});

app.post("/api/v1/auth/login/", (req, res) => {
    const { email, password } = req.body;
    const db = getDB();
    const user = db.authUsers.find(u => u.email === email);

    // Initial sync for first-time users (demo convenience)
    if (user && !user.password.startsWith("$2a$")) {
        user.password = bcrypt.hashSync(user.password, 8);
        saveDB(db);
    }

    if (!user || !bcrypt.compareSync(password, user.password)) {
        return res.status(401).json({ code: "INVALID_CREDENTIALS", message: "Email or password is incorrect." });
    }

    const access_token = jwt.sign({ id: user.id, email: user.email, role: user.role }, JWT_SECRET, { expiresIn: "1h" });
    const refresh_token = jwt.sign({ id: user.id }, JWT_SECRET, { expiresIn: "7d" });

    res.json({
        access_token,
        refresh_token,
        role: user.role,
        user_id: user.id,
        name: user.name,
        email: user.email
    });
});

app.post("/api/v1/auth/refresh/", (req, res) => {
    const { refresh_token } = req.body;
    if (!refresh_token) return res.status(400).json({ code: "BAD_REQUEST", message: "Refresh token is missing." });

    jwt.verify(refresh_token, JWT_SECRET, (err, decoded) => {
        if (err) return res.status(401).json({ code: "TOKEN_INVALID", message: "Refresh token is invalid." });
        
        const db = getDB();
        const user = db.authUsers.find(u => u.id === decoded.id);
        if (!user) return res.status(401).json({ code: "USER_NOT_FOUND", message: "User not found." });

        const access_token = jwt.sign({ id: user.id, email: user.email, role: user.role }, JWT_SECRET, { expiresIn: "1h" });
        const new_refresh_token = jwt.sign({ id: user.id }, JWT_SECRET, { expiresIn: "7d" });

        res.json({ access_token, refresh_token: new_refresh_token });
    });
});

// --- Routes: Clinical Data ---
app.get("/api/v1/triage-submissions/", authenticateToken, (req, res) => {
    const db = getDB();
    let submissions = db.triageSubmissions;
    
    if (req.user.role === "patient") {
        submissions = submissions.filter(s => s.email === req.user.email);
    } else if (req.query.email) {
        submissions = submissions.filter(s => s.email === req.query.email);
    }

    res.json(submissions.sort((a, b) => new Date(b.created_at) - new Date(a.created_at)));
});

app.post("/api/v1/triage/", authenticateToken, requireRole(["patient"]), (req, res) => {
    const { description, photo_name = "" } = req.body;
    if (!description) return res.status(400).json({ code: "VALIDATION_ERROR", message: "Description is required." });

    const db = getDB();
    const user = db.authUsers.find(u => u.id === req.user.id);

    // Mock AI categorization
    const urgency = Math.min(100, Math.max(10, description.length / 4));
    const priority = urgency > 80 ? 1 : urgency > 60 ? 2 : urgency > 40 ? 3 : 4;

    const newTriage = {
        id: Date.now(),
        email: req.user.email,
        patient_name: user ? user.name : "Unknown",
        description,
        priority,
        urgency_score: Math.round(urgency),
        condition: priority <= 2 ? "Urgent Review Required" : "Standard Assessment",
        status: "waiting",
        created_at: new Date().toISOString(),
        photo_name,
        // Carry clinical context
        gender: user?.gender || "",
        age: user?.age || null,
        blood_type: user?.blood_type || "",
        health_history: user?.health_history || "",
        allergies: user?.allergies || "",
        current_medications: user?.current_medications || ""
    };

    db.triageSubmissions.push(newTriage);
    saveDB(db);

    broadcast("TRIAGE_CREATED", newTriage);
    res.status(201).json(newTriage);
});

// Staff Queue
app.get("/api/v1/staff/patients/", authenticateToken, requireRole(["staff", "admin"]), (req, res) => {
    const db = getDB();
    let patients = db.triageSubmissions;
    if (req.query.status) patients = patients.filter(p => p.status === req.query.status);
    res.json(patients.sort((a, b) => b.urgency_score - a.urgency_score));
});

app.patch("/api/v1/staff/patient/:id/status/", authenticateToken, requireRole(["staff", "admin"]), (req, res) => {
    const db = getDB();
    const id = parseInt(req.params.id);
    const { status } = req.body;
    
    const index = db.triageSubmissions.findIndex(s => s.id === id);
    if (index === -1) return res.status(404).json({ code: "NOT_FOUND", message: "Triage entry not found." });

    db.triageSubmissions[index].status = status;
    saveDB(db);

    broadcast("TRIAGE_UPDATED", db.triageSubmissions[index]);
    res.json(db.triageSubmissions[index]);
});

// Admin Dashboard
app.get("/api/v1/admin/overview/", authenticateToken, requireRole(["admin"]), (req, res) => {
    const db = getDB();
    const s = db.triageSubmissions;
    res.json({
        total_patients: s.length,
        waiting: s.filter(p => p.status === "waiting").length,
        in_progress: s.filter(p => p.status === "in_progress").length,
        completed: s.filter(p => p.status === "completed").length,
        critical_cases: s.filter(p => p.priority === 1).length
    });
});

app.get("/api/v1/admin/users/", authenticateToken, requireRole(["admin"]), (req, res) => {
    const db = getDB();
    res.json(db.adminUsers);
});

app.patch("/api/v1/profile/", authenticateToken, (req, res) => {
    const { 
        name, email, gender, age, blood_type, 
        health_history, allergies, current_medications 
    } = req.body;

    const db = getDB();
    const userIndex = db.authUsers.findIndex(u => u.id === req.user.id);
    if (userIndex === -1) return res.status(404).json({ code: "NOT_FOUND", message: "User not found." });

    const user = db.authUsers[userIndex];
    
    if (name) user.name = name;
    if (email) user.email = email;
    if (gender !== undefined) user.gender = gender;
    if (age !== undefined) user.age = age;
    if (blood_type !== undefined) user.blood_type = blood_type;
    if (health_history !== undefined) user.health_history = health_history;
    if (allergies !== undefined) user.allergies = allergies;
    if (current_medications !== undefined) user.current_medications = current_medications;

    db.authUsers[userIndex] = user;
    
    const adminIdx = db.adminUsers.findIndex(u => u.id === req.user.id);
    if (adminIdx !== -1) {
        db.adminUsers[adminIdx].name = user.name;
        db.adminUsers[adminIdx].email = user.email;
    }

    saveDB(db);

    const { password, ...sanitized } = user;
    res.json(sanitized);
});

// --- Start API Server ---
const PORT = process.env.PORT || API_PORT;
app.listen(PORT, () => {
    console.log(`\n🚀 High-Grade API Mock Running`);
    console.log(`   API Root: http://localhost:${PORT}/api/v1/`);
});

// --- WebSocket Server (Port 3002) ---
const wss = new WebSocketServer({ port: WS_PORT, path: "/ws/v1/updates/" });
const clients = new Map();

wss.on("connection", (ws) => {
    console.log("[WS] New connection established on port 3002.");
    let authenticated = false;

    ws.on("message", (message) => {
        try {
            const data = JSON.parse(message);
            
            // Handshake Logic
            if (data.type === "AUTH") {
                jwt.verify(data.token, JWT_SECRET, (err, decoded) => {
                    if (err) {
                        ws.send(JSON.stringify({ type: "ERROR", message: "Auth failed" }));
                        ws.terminate();
                    } else {
                        authenticated = true;
                        clients.set(ws, decoded);
                        ws.send(JSON.stringify({ type: "AUTH_SUCCESS" }));
                        console.log(`[WS] Authenticated: ${decoded.email}`);
                    }
                });
            }

            // Heartbeat Logic
            if (data.type === "PING") {
                ws.send(JSON.stringify({ type: "PONG" }));
            }
        } catch (e) {
            console.error("[WS] Parse error");
        }
    });

    ws.on("close", () => {
        clients.delete(ws);
        console.log("[WS] Client disconnected.");
    });
});

function broadcast(type, payload) {
    const msg = JSON.stringify({ type, data: payload });
    clients.forEach((user, ws) => {
        if (ws.readyState === 1) {
            ws.send(msg);
        }
    });
}

console.log(`🚀 High-Grade WebSocket Mock Running`);
console.log(`   WS Root:  ws://localhost:${WS_PORT}/ws/v1/updates/\n`);
