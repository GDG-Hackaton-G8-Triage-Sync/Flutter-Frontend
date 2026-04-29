const express = require("express");
const morgan = require("morgan");

const { corsMiddleware } = require("./middleware/cors");
const { createAuthMiddleware } = require("./middleware/auth");
const { createAuthRoutes } = require("./routes/authRoutes");
const { createProfileRoutes } = require("./routes/profileRoutes");
const { createTriageRoutes } = require("./routes/triageRoutes");
const { createStaffRoutes } = require("./routes/staffRoutes");
const { createAdminRoutes } = require("./routes/adminRoutes");

function createApp({ store, tokenService, passwordService, realtime }) {
    const app = express();

    app.use(express.json());
    app.use(morgan("dev"));
    app.use(corsMiddleware);

    const { authenticate } = createAuthMiddleware({ tokenService, store });
    const authRoutes = createAuthRoutes({
        store,
        tokenService,
        passwordService,
    });

    app.use("/api/auth", authRoutes);
    app.use("/api/v1/auth", authRoutes);

    app.use(authenticate);

    app.use("/api/v1/profile", createProfileRoutes({ store }));
    app.use("/api/v1", createTriageRoutes({ store, realtime }));
    app.use("/api/v1", createStaffRoutes({ store, realtime }));
    app.use("/api/v1", createAdminRoutes({ store }));

    app.get("/health", (_, res) => {
        res.json({ status: "ok" });
    });

    app.use((req, res) => {
        res.status(404).json({
            code: "NOT_FOUND",
            message: `Route not found: ${req.method} ${req.path}`,
        });
    });

    app.use((err, _req, res, _next) => {
        console.error("[MockServer] Unhandled error:", err);
        res.status(500).json({
            code: "INTERNAL_SERVER_ERROR",
            message: "Unexpected server error",
        });
    });

    return app;
}

module.exports = { createApp };
