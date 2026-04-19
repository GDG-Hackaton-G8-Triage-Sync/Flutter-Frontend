const express = require("express");

function createAdminRoutes({ store }) {
    const router = express.Router();

    function requireAdmin(req, res) {
        if (req.user.role !== "admin") {
            res.status(403).json({
                code: "PERMISSION_DENIED",
                message: "Admin role required",
            });
            return false;
        }
        return true;
    }

    router.get("/admin/overview/", (req, res) => {
        if (!requireAdmin(req, res)) return;

        const submissions = store.read().triageSubmissions;
        return res.json({
            total_patients: submissions.length,
            waiting: submissions.filter((s) => s.status === "waiting").length,
            in_progress: submissions.filter((s) => s.status === "in_progress")
                .length,
            completed: submissions.filter((s) => s.status === "completed")
                .length,
            critical_cases: submissions.filter((s) => s.priority === 1).length,
        });
    });

    router.get("/admin/analytics/", (req, res) => {
        if (!requireAdmin(req, res)) return;

        const submissions = store.read().triageSubmissions;
        const avg = submissions.length
            ? Math.round(
                  submissions.reduce(
                      (acc, item) => acc + (item.urgency_score || 0),
                      0,
                  ) / submissions.length,
              )
            : 0;

        const commonConditions = [
            ...new Set(
                submissions.map((item) => item.condition).filter(Boolean),
            ),
        ].slice(0, 5);

        return res.json({
            avg_urgency_score: avg,
            peak_hour: "14:00 - 16:00",
            common_conditions: commonConditions,
        });
    });

    router.get("/admin/users/", (req, res) => {
        if (!requireAdmin(req, res)) return;
        return res.json(store.read().adminUsers);
    });

    router.patch("/admin/users/:id/role/", (req, res) => {
        if (!requireAdmin(req, res)) return;

        const id = Number(req.params.id);
        const role = (req.body?.role || "").toString();
        const allowed = ["patient", "staff", "admin"];

        if (!allowed.includes(role)) {
            return res.status(400).json({
                code: "VALIDATION_ERROR",
                message: "Role must be one of patient, staff, admin",
            });
        }

        const result = store.update((db) => {
            const authUser = db.authUsers.find((u) => u.id === id);
            const adminUser = db.adminUsers.find((u) => u.id === id);
            if (!authUser || !adminUser) {
                return { notFound: true };
            }

            authUser.role = role;
            adminUser.role = role;
            return { user: adminUser };
        });

        if (result.notFound) {
            return res
                .status(404)
                .json({ code: "NOT_FOUND", message: "User not found" });
        }

        return res.json(result.user);
    });

    router.delete("/admin/patient/:id/", (req, res) => {
        if (!requireAdmin(req, res)) return;

        const id = Number(req.params.id);

        store.update((db) => {
            db.triageSubmissions = db.triageSubmissions.filter(
                (item) => item.id !== id,
            );
            return null;
        });

        return res.status(204).send();
    });

    return router;
}

module.exports = { createAdminRoutes };
