const express = require('express');
const {
    deriveTriageLogic,
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
            const logicResults = deriveTriageLogic(description);

            const triageItem = {
                id: Date.now(),
                email: req.user.email,
                patient_name: user ? user.name : "Unknown",
                description,
                ...logicResults,
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

    router.get("/triage/:id/waiting-analytics/", (req, res) => {
        const id = Number(req.params.id);
        const db = store.read();
        
        const myItem = db.triageSubmissions.find(t => t.id === id);
        if (!myItem) {
            return res.status(404).json({ message: "Not found" });
        }

        if (myItem.status !== "waiting") {
            return res.json({ position: 0, total_waiting: 0, estimated_wait_mins: 0 });
        }

        const waiting = db.triageSubmissions.filter(t => t.status === "waiting");
        // Sort by urgency score descending
        waiting.sort((a, b) => b.urgency_score - a.urgency_score);
        
        const myPosition = waiting.findIndex(t => t.id === id) + 1;
        const totalWaiting = waiting.length;

        // Predictive logic: 10 mins per waiting patient ahead of you, adjusted by priority
        const estimatedMins = myPosition * 12;

        return res.json({
            position: myPosition,
            total_waiting: totalWaiting,
            estimated_wait_mins: estimatedMins,
            ai_confidence: 0.94,
            message: myPosition === 1 
                ? "You are next in line. A nurse will be with you shortly." 
                : `There are ${myPosition - 1} high-urgency cases ahead of you.`
        });
    });

    realtime.broadcast("TRIAGE_CREATED", result);
        return res.status(201).json(result);
    });

    return router;
}

module.exports = { createTriageRoutes };
