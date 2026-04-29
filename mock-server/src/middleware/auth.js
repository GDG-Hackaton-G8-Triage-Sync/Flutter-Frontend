function createAuthMiddleware({ tokenService, store }) {
    const publicPrefixes = ["/api/auth/", "/api/v1/auth/"];

    function authenticate(req, res, next) {
        if (publicPrefixes.some((prefix) => req.path.startsWith(prefix))) {
            return next();
        }

        const authHeader = req.headers.authorization || "";
        if (!authHeader.startsWith("Bearer ")) {
            return res.status(401).json({
                code: "AUTH_HEADER_MISSING",
                message: "Missing Bearer token in Authorization header",
            });
        }

        const token = authHeader.slice("Bearer ".length).trim();

        let decoded;
        try {
            decoded = tokenService.verify(token);
        } catch (_) {
            return res.status(401).json({
                code: "AUTH_TOKEN_INVALID",
                message: "Bearer token is invalid or expired",
            });
        }

        const db = store.read();
        const user = db.authUsers.find((item) => item.id === decoded.id);
        if (!user) {
            return res.status(401).json({
                code: "AUTH_USER_NOT_FOUND",
                message: "Authenticated user no longer exists",
            });
        }

        req.user = { id: user.id, email: user.email, role: user.role };
        return next();
    }

    function requireRole(roles) {
        return (req, res, next) => {
            if (!req.user || !roles.includes(req.user.role)) {
                return res.status(403).json({
                    code: "PERMISSION_DENIED",
                    message:
                        "You do not have permission to perform this action",
                });
            }
            return next();
        };
    }

    return { authenticate, requireRole };
}

module.exports = { createAuthMiddleware };
