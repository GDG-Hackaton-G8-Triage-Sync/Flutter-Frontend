const express = require("express");
const {
    deriveUrgency,
    derivePriority,
    deriveCondition,
} = require("../services/triageService");

function createTriageRoutes({ store, realtime }) {
    const router = express.Router();

    router.get("/triage-submissions/", (req, res) => {
        const db = store.read();
        let list = [...db.triageSubmissions];

        if (req.user.role === "patient") {
            list = list.filter((item) => item.email === req.user.email);
        } else if (req.query.email) {
            list = list.filter((item) => item.email === req.query.email);
        }

        list.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
        return res.json(list);
    });

    router.post("/triage/", (req, res) => {
        if (req.user.role !== "patient") {
            return res.status(403).json({
                code: "PERMISSION_DENIED",
                message: "Only patients can submit triage details",
            });
        }

        const { description, photo_name = "" } = req.body || {};
        if (!description) {
            return res.status(400).json({
                code: "VALIDATION_ERROR",
                message: "Description is required",
            });
        }

        const result = store.update((db) => {
            const user = db.authUsers.find((u) => u.id === req.user.id);
            const urgencyScore = deriveUrgency(description);
            const priority = derivePriority(urgencyScore);

            const triageItem = {
                id: Date.now(),
                email: req.user.email,
                patient_name: user ? user.name : "Unknown",
                description,
                priority,
                urgency_score: urgencyScore,
                condition: deriveCondition(priority),
                status: "waiting",
                created_at: new Date().toISOString(),
                photo_name,
                gender: user?.gender || "",
                age: user?.age || null,
                blood_type: user?.blood_type || "",
                health_history: user?.health_history || "",
                allergies: user?.allergies || "",
                current_medications: user?.current_medications || "",
                bad_habits: user?.bad_habits || "",
            };

            db.triageSubmissions.push(triageItem);
            return triageItem;
        });

        realtime.broadcast("TRIAGE_CREATED", result);
        return res.status(201).json(result);
    });

    return router;
}

module.exports = { createTriageRoutes };
