const jwt = require("jsonwebtoken");

class TokenService {
    constructor(secret) {
        this.secret = secret;
    }

    signAccess(user) {
        return jwt.sign(
            { id: user.id, email: user.email, role: user.role },
            this.secret,
            { expiresIn: "1h" },
        );
    }

    signRefresh(user) {
        return jwt.sign({ id: user.id }, this.secret, { expiresIn: "7d" });
    }

    verify(token) {
        return jwt.verify(token, this.secret);
    }
}

module.exports = { TokenService };
