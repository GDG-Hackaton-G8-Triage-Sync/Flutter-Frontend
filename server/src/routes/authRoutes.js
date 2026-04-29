const express = require("express");

function createAuthRoutes({ store, tokenService, passwordService }) {
    const router = express.Router();

    router.post("/register/", (req, res) => {
        const {
            name,
            email,
            password,
            role = "patient",
            gender = "",
            age = null,
            blood_type = "",
            health_history = "",
            allergies = "",
            current_medications = "",
            bad_habits = "",
        } = req.body || {};

        if (!name || !email || !password) {
            return res.status(400).json({
                code: "VALIDATION_ERROR",
                message: "Name, email and password are required",
            });
        }

        const normalizedEmail = email.toLowerCase().trim();

        const outcome = store.update((db) => {
            const exists = db.authUsers.find(
                (u) => u.email === normalizedEmail,
            );
            if (exists) {
                return { conflict: true };
            }

            const user = {
                id: Date.now(),
                name,
                email: normalizedEmail,
                password: passwordService.hash(password),
                role,
                gender,
                age,
                blood_type,
                health_history,
                allergies,
                current_medications,
                bad_habits,
            };

            db.authUsers.push(user);
            db.adminUsers.push({
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role,
            });

            return { user };
        });

        if (outcome.conflict) {
            return res.status(409).json({
                code: "CONFLICT",
                message: "A user with this email already exists",
            });
        }

        return res
            .status(201)
            .json({ message: "Account created successfully" });
    });

    router.post("/login/", (req, res) => {
        const { email, password } = req.body || {};
        const normalizedEmail = (email || "").toLowerCase().trim();

        const result = store.update((db) => {
            const user = db.authUsers.find((u) => u.email === normalizedEmail);
            if (!user) return { user: null };

            if (!passwordService.isHash(user.password)) {
                user.password = passwordService.hash(user.password);
            }

            const valid = passwordService.compare(
                password || "",
                user.password,
            );
            return { user, valid };
        });

        if (!result.user || !result.valid) {
            return res.status(401).json({
                code: "INVALID_CREDENTIALS",
                message: "Email or password is incorrect",
            });
        }

        const accessToken = tokenService.signAccess(result.user);
        const refreshToken = tokenService.signRefresh(result.user);

        return res.json({
            access_token: accessToken,
            refresh_token: refreshToken,
            role: result.user.role,
            user_id: result.user.id,
            name: result.user.name,
            email: result.user.email,
        });
    });

    router.post("/refresh/", (req, res) => {
        const { refresh_token: refreshToken } = req.body || {};
        if (!refreshToken) {
            return res.status(400).json({
                code: "BAD_REQUEST",
                message: "Refresh token is missing",
            });
        }

        let decoded;
        try {
            decoded = tokenService.verify(refreshToken);
        } catch (_) {
            return res.status(401).json({
                code: "TOKEN_INVALID",
                message: "Refresh token is invalid",
            });
        }

        const db = store.read();
        const user = db.authUsers.find((u) => u.id === decoded.id);
        if (!user) {
            return res.status(401).json({
                code: "USER_NOT_FOUND",
                message: "User not found",
            });
        }

        return res.json({
            access_token: tokenService.signAccess(user),
            refresh_token: tokenService.signRefresh(user),
        });
    });

    return router;
}

module.exports = { createAuthRoutes };
