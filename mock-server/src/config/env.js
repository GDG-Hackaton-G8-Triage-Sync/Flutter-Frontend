const path = require("path");

const ROOT_DIR = path.resolve(__dirname, "..", "..");

const env = {
    apiPort: Number(process.env.PORT || 4567),
    wsPort: Number(process.env.WS_PORT || 4568),
    wsPath: process.env.WS_PATH || "/ws/v1/updates/",
    jwtSecret: process.env.JWT_SECRET || "triage-sync-high-grade-secret-99",
    dbPath:
        process.env.DB_PATH || path.join(ROOT_DIR, "db.json"),
};

module.exports = { env };
