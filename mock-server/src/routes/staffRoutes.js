const express = require("express");

function createStaffRoutes({ store, realtime }) {
    const router = express.Router();

    router.get("/staff/patients/", (req, res) => {
        if (!["staff", "admin"].includes(req.user.role)) {
            return res.status(403).json({
                code: "PERMISSION_DENIED",
                message: "Staff or admin role required",
            });
        }

        const db = store.read();
        let patients = [...db.triageSubmissions];

        if (req.query.status) {
            patients = patients.filter(
                (item) => item.status === req.query.status,
            );
        }

        if (req.query.priority) {
            patients = patients.filter(
                (item) => String(item.priority) === String(req.query.priority),
            );
        }

        patients.sort((a, b) => b.urgency_score - a.urgency_score);
        return res.json(patients);
    });

    router.patch("/staff/patient/:id/status/", (req, res) => {
        if (!["staff", "admin"].includes(req.user.role)) {
            return res.status(403).json({
                code: "PERMISSION_DENIED",
                message: "Staff or admin role required",
            });
        }

        const id = Number(req.params.id);
        const { status } = req.body || {};
        const allowed = ["waiting", "in_progress", "completed"];

        if (!allowed.includes(status)) {
            return res.status(400).json({
                code: "VALIDATION_ERROR",
                message: "Invalid status value",
            });
        }

        const result = store.update((db) => {
            const index = db.triageSubmissions.findIndex(
                (item) => item.id === id,
            );
            if (index === -1) {
                return { notFound: true };
            }

            const item = db.triageSubmissions[index];
            item.status = status;

            const now = new Date().toISOString();
            if (status === "in_progress" && !item.started_at) {
                item.started_at = now;
            } else if (status === "completed") {
                item.completed_at = now;
            }

            return { item };
        });

        if (result.notFound) {
            return res
                .status(404)
                .json({ code: "NOT_FOUND", message: "Triage entry not found" });
        }

        realtime.broadcast("TRIAGE_UPDATED", result.item);
        return res.json(result.item);
    });

    router.patch("/staff/patient/:id/priority/", (req, res) => {
        if (!["staff", "admin"].includes(req.user.role)) {
            return res.status(403).json({
                code: "PERMISSION_DENIED",
                message: "Staff or admin role required",
            });
        }

        const id = Number(req.params.id);
        const priority = Number(req.body?.priority);

        if (!Number.isFinite(priority) || priority < 1 || priority > 5) {
            return res.status(400).json({
                code: "VALIDATION_ERROR",
                message: "Priority must be between 1 and 5",
            });
        }

        const result = store.update((db) => {
            const index = db.triageSubmissions.findIndex(
                (item) => item.id === id,
            );
            if (index === -1) {
                return { notFound: true };
            }

            db.triageSubmissions[index].priority = priority;
            return { item: db.triageSubmissions[index] };
        });

        if (result.notFound) {
            return res
                .status(404)
                .json({ code: "NOT_FOUND", message: "Triage entry not found" });
        }

        realtime.broadcast("TRIAGE_UPDATED", result.item);
        return res.json(result.item);
    });

    router.patch("/staff/patient/:id/verify/", (req, res) => {
        if (!["staff", "admin"].includes(req.user.role)) {
            return res.status(403).json({
                code: "PERMISSION_DENIED",
                message: "Staff or admin role required",
            });
        }

        const id = Number(req.params.id);
        const verifiedBy = (req.body?.verified_by || "").toString().trim();

        if (!verifiedBy) {
            return res.status(400).json({
                code: "VALIDATION_ERROR",
                message: "verified_by is required",
            });
        }

        const result = store.update((db) => {
            const index = db.triageSubmissions.findIndex(
                (item) => item.id === id,
            );
            if (index === -1) {
                return { notFound: true };
            }

            const triageItem = db.triageSubmissions[index];
            if (triageItem.verified_at) {
                return { conflict: true };
            }

            triageItem.verified_by = verifiedBy;
            triageItem.verified_at = new Date().toISOString();
            return { item: triageItem };
        });

        if (result.notFound) {
            return res
                .status(404)
                .json({ code: "NOT_FOUND", message: "Triage entry not found" });
        }

        if (result.conflict) {
            return res.status(409).json({
                code: "CONFLICT",
                message: "This triage decision is already verified",
            });
        }

        realtime.broadcast("TRIAGE_UPDATED", result.item);
        return res.json(result.item);
    });

    router.post("/staff/patient/:id/vitals/", (req, res) => {
        if (!["staff", "admin"].includes(req.user.role)) {
            return res.status(403).json({
                code: "PERMISSION_DENIED",
                message: "Staff or admin role required",
            });
        }

        const id = Number(req.params.id);
        const { bp, heart_rate, temperature } = req.body || {};

        const result = store.update((db) => {
            const index = db.triageSubmissions.findIndex((item) => item.id === id);
            if (index === -1) {
                return { notFound: true };
            }

            const triageItem = db.triageSubmissions[index];
            triageItem.vitals = {
                bp,
                heart_rate,
                temperature,
                recorded_at: new Date().toISOString(),
                recorded_by: req.user.name || "Staff",
            };
            return { item: triageItem };
        });

        if (result.notFound) {
            return res.status(404).json({ code: "NOT_FOUND", message: "Triage entry not found" });
        }

        realtime.broadcast("TRIAGE_UPDATED", result.item);
        return res.status(201).json(result.item);
    });

    return router;
}

module.exports = { createStaffRoutes };
