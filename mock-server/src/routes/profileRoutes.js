const express = require("express");

function createProfileRoutes({ store }) {
    const router = express.Router();

    router.patch("/", (req, res) => {
        const {
            name,
            email,
            gender,
            age,
            blood_type,
            health_history,
            allergies,
            current_medications,
            bad_habits,
        } = req.body || {};

        const result = store.update((db) => {
            const index = db.authUsers.findIndex((u) => u.id === req.user.id);
            if (index === -1) {
                return { notFound: true };
            }

            const user = db.authUsers[index];
            if (name) user.name = name;
            if (email) user.email = email.toLowerCase().trim();
            if (gender !== undefined) user.gender = gender;
            if (age !== undefined) user.age = age;
            if (blood_type !== undefined) user.blood_type = blood_type;
            if (health_history !== undefined)
                user.health_history = health_history;
            if (allergies !== undefined) user.allergies = allergies;
            if (current_medications !== undefined)
                user.current_medications = current_medications;
            if (bad_habits !== undefined) user.bad_habits = bad_habits;

            const adminIndex = db.adminUsers.findIndex(
                (u) => u.id === req.user.id,
            );
            if (adminIndex !== -1) {
                db.adminUsers[adminIndex].name = user.name;
                db.adminUsers[adminIndex].email = user.email;
            }

            const { password, ...sanitized } = user;
            return { user: sanitized };
        });

        if (result.notFound) {
            return res
                .status(404)
                .json({ code: "NOT_FOUND", message: "User not found" });
        }

        return res.json(result.user);
    });

    return router;
}

module.exports = { createProfileRoutes };
