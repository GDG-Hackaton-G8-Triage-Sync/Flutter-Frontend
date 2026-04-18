const jsonServer = require("json-server");
const path = require("path");
const { WebSocketServer } = require("ws");

const server = jsonServer.create();
const router = jsonServer.router(path.join(__dirname, "db.json"));
const middlewares = jsonServer.defaults();

server.use(middlewares);
server.use(jsonServer.bodyParser);

// --- WebSocket Server ---
const WS_PORT = 3002;
const wss = new WebSocketServer({ port: WS_PORT });

function broadcastEvent(type, payload) {
  const msg = JSON.stringify({ type: type, data: payload });
  wss.clients.forEach((client) => {
    if (client.readyState === 1 /* OPEN */) {
      client.send(msg);
    }
  });
}

function broadcastQueueUpdate(payload, type = "queue_update") {
    broadcastEvent(type, payload);
}

wss.on("connection", (ws) => {
  console.log(`[WS] Client connected (${wss.clients.size} total)`);
  ws.on("close", () =>
    console.log(`[WS] Client disconnected (${wss.clients.size} remaining)`)
  );
});

console.log(`WebSocket server running on ws://localhost:${WS_PORT}`);
// --------------------------------

function tokenFor(user) {
    return `mock-jwt-token-${user.id}-${user.role}`;
}

function parseToken(token) {
    const prefix = "mock-jwt-token-";
    if (!token || !token.startsWith(prefix)) {
        return null;
    }

    const parts = token.substring(prefix.length).split("-");
    if (parts.length < 2) {
        return null;
    }

    const userId = Number(parts[0]);
    const role = parts.slice(1).join("-");

    if (!Number.isFinite(userId) || !role) {
        return null;
    }

    return { userId, role };
}

function findUserByToken(db, token) {
    const parsed = parseToken(token);
    if (!parsed) {
        return null;
    }

    const user = db.get("authUsers").find({ id: parsed.userId }).value();
    if (!user || user.role !== parsed.role) {
        return null;
    }

    return user;
}

function requireAnyRole(req, res, roles) {
    if (!req.user) {
        res.status(401).json({ error: "Unauthorized access" });
        return false;
    }

    if (!roles.includes(req.user.role)) {
        res.status(403).json({ error: "Permission denied" });
        return false;
    }

    return true;
}

function authMiddleware(req, res, next) {
    if (req.path.startsWith("/api/auth/")) {
        return next();
    }

    const auth = req.headers.authorization || "";
    if (!auth.startsWith("Bearer ")) {
        return res.status(401).json({ error: "Unauthorized access" });
    }

    const token = auth.slice("Bearer ".length).trim();
    const user = findUserByToken(router.db, token);
    if (!user) {
        return res.status(401).json({ error: "Unauthorized access" });
    }

    req.user = user;

    return next();
}

server.use(authMiddleware);

server.post("/api/auth/login/", (req, res) => {
    const { email, password } = req.body || {};
    const db = router.db;
    const user = db.get("authUsers").find({ email, password }).value();

    if (!user) {
        return res.status(400).json({ error: "Invalid credentials" });
    }

    return res.json({
        access_token: tokenFor(user),
        refresh_token: `refresh-${tokenFor(user)}`,
        role: user.role,
        user_id: user.id,
        name: user.name,
        email: user.email,
    });
});

server.post("/api/auth/refresh/", (req, res) => {
    const { refresh_token } = req.body || {};
    if (!refresh_token || typeof refresh_token !== "string") {
        return res.status(400).json({ error: "Invalid refresh token" });
    }

    const prefix = "refresh-";
    if (!refresh_token.startsWith(prefix)) {
        return res.status(401).json({ error: "Unauthorized access" });
    }

    const token = refresh_token.slice(prefix.length);
    const user = findUserByToken(router.db, token);
    if (!user) {
        return res.status(401).json({ error: "Unauthorized access" });
    }

    return res.json({ access_token: tokenFor(user) });
});

server.post("/api/auth/register/", (req, res) => {
    const { name, email, password, role = "patient" } = req.body || {};
    if (!name || !email || !password) {
        return res.status(400).json({ error: "Invalid input" });
    }

    const db = router.db;
    const exists = db.get("authUsers").find({ email }).value();
    if (exists) {
        return res.status(400).json({ error: "User already exists" });
    }

    const nextId = (db.get("authUsers").map("id").max().value() || 0) + 1;

    db.get("authUsers")
        .push({ id: nextId, name, email, password, role })
        .write();

    db.get("adminUsers").push({ id: nextId, name, email, role }).write();

    return res.status(201).json({ message: "Registered" });
});

server.post("/api/triage/", (req, res) => {
    if (!requireAnyRole(req, res, ["patient"])) {
        return;
    }

    const { description, photo_name = "" } = req.body || {};
    if (!description || description.length > 500) {
        return res.status(400).json({
            error: "Invalid input",
            details: { description: "Cannot exceed 500 characters" },
        });
    }

    const db = router.db;
    const nextId =
        (db.get("triageSubmissions").map("id").max().value() || 100) + 1;

    const urgencyScore = Math.min(
        99,
        Math.max(10, Math.round(description.length / 5)),
    );
    const priority =
        urgencyScore > 85
            ? 1
            : urgencyScore > 70
              ? 2
              : urgencyScore > 45
                ? 3
                : urgencyScore > 25
                  ? 4
                  : 5;
    const condition =
        priority <= 2 ? "Needs Immediate Review" : "General Assessment";

    const item = {
        id: nextId,
        email: req.user.email,
        description,
        priority,
        urgency_score: urgencyScore,
        condition,
        status: "waiting",
        created_at: new Date().toISOString(),
        photo_name,
    };

    db.get("triageSubmissions").push(item).write();

    // Notify subscribers that a new queue entry exists.
    broadcastQueueUpdate(item, "patient_created");

    return res.status(201).json(item);
});

server.get("/api/triage-submissions/", (req, res) => {
    if (!requireAnyRole(req, res, ["patient", "staff", "admin"])) {
        return;
    }

    const db = router.db;
    const email = req.query.email;

    let list = db.get("triageSubmissions").value();
    if (req.user.role == "patient") {
        list = list.filter((item) => item.email === req.user.email);
    } else if (email) {
        list = list.filter((item) => item.email === email);
    }

    return res.json(list);
});

server.get("/api/dashboard/staff/patients/", (req, res) => {
    if (!requireAnyRole(req, res, ["staff", "admin"])) {
        return;
    }

    const db = router.db;
    let list = db.get("triageSubmissions").value();

    if (req.query.priority) {
        list = list.filter(
            (p) => String(p.priority) === String(req.query.priority),
        );
    }

    if (req.query.status) {
        list = list.filter((p) => p.status === req.query.status);
    }

    list.sort((a, b) => b.urgency_score - a.urgency_score);
    return res.json(list);
});

server.patch("/api/dashboard/staff/patient/:id/status/", (req, res) => {
    if (!requireAnyRole(req, res, ["staff", "admin"])) {
        return;
    }

    const id = Number(req.params.id);
    const { status } = req.body || {};
    const allowed = ["waiting", "in_progress", "completed"];

    if (!allowed.includes(status)) {
        return res.status(400).json({ error: "Invalid status" });
    }

    const db = router.db;
    const found = db.get("triageSubmissions").find({ id }).value();
    if (!found) {
        return res.status(404).json({ error: "Patient not found" });
    }

    db.get("triageSubmissions").find({ id }).assign({ status }).write();
    const updated = db.get("triageSubmissions").find({ id }).value();

    // Broadcast real-time update to all WebSocket clients.
    broadcastQueueUpdate(updated, "status_update");

    return res.json(updated);
});

server.patch("/api/staff/queue/:id/priority", (req, res) => {
    if (!requireAnyRole(req, res, ["staff", "admin"])) {
        return;
    }

    const id = Number(req.params.id);
    const priority = Number(req.body?.priority);

    if (!Number.isFinite(priority) || priority < 1 || priority > 5) {
        return res.status(400).json({ error: "Invalid priority" });
    }

    const db = router.db;
    const found = db.get("triageSubmissions").find({ id }).value();
    if (!found) {
        return res.status(404).json({ error: "Patient not found" });
    }

    db.get("triageSubmissions").find({ id }).assign({ priority }).write();
    const updated = db.get("triageSubmissions").find({ id }).value();

    broadcastQueueUpdate(updated, "priority_override");

    return res.json(updated);
});

server.get("/api/dashboard/admin/overview/", (req, res) => {
    if (!requireAnyRole(req, res, ["admin"])) {
        return;
    }

    const db = router.db;
    const patients = db.get("triageSubmissions").value();

    const waiting = patients.filter((p) => p.status === "waiting").length;
    const inProgress = patients.filter(
        (p) => p.status === "in_progress",
    ).length;
    const completed = patients.filter((p) => p.status === "completed").length;
    const critical = patients.filter((p) => p.priority === 1).length;

    return res.json({
        total_patients: patients.length,
        waiting,
        in_progress: inProgress,
        completed,
        critical_cases: critical,
    });
});

server.get("/api/dashboard/admin/analytics/", (req, res) => {
    if (!requireAnyRole(req, res, ["admin"])) {
        return;
    }

    const db = router.db;
    const patients = db.get("triageSubmissions").value();
    const avg = patients.length
        ? Math.round(
              patients.reduce(
                  (acc, item) => acc + (item.urgency_score || 0),
                  0,
              ) / patients.length,
          )
        : 0;

    const conditions = [
        ...new Set(patients.map((p) => p.condition).filter(Boolean)),
    ].slice(0, 5);

    return res.json({
        avg_urgency_score: avg,
        peak_hour: "14:00",
        common_conditions: conditions,
    });
});

server.get("/api/admin/users/", (req, res) => {
    if (!requireAnyRole(req, res, ["admin"])) {
        return;
    }

    const users = router.db.get("adminUsers").value();
    return res.json(users);
});

server.patch("/api/admin/users/:id/role/", (req, res) => {
    if (!requireAnyRole(req, res, ["admin"])) {
        return;
    }

    const id = Number(req.params.id);
    const { role } = req.body || {};
    const allowed = ["patient", "staff", "admin"];

    if (!allowed.includes(role)) {
        return res.status(400).json({ error: "Permission denied" });
    }

    const db = router.db;
    const exists = db.get("adminUsers").find({ id }).value();
    if (!exists) {
        return res.status(404).json({ error: "User not found" });
    }

    db.get("adminUsers").find({ id }).assign({ role }).write();
    db.get("authUsers").find({ id }).assign({ role }).write();

    return res.json(db.get("adminUsers").find({ id }).value());
});

server.delete("/api/admin/patient/:id/", (req, res) => {
    if (!requireAnyRole(req, res, ["admin"])) {
        return;
    }

    const id = Number(req.params.id);
    const db = router.db;
    db.get("triageSubmissions").remove({ id }).write();
    return res.status(204).send();
});

server.use(router);

const PORT = 3001;
server.listen(PORT, () => {
    console.log(`JSON mock server running on http://localhost:${PORT}`);
});
