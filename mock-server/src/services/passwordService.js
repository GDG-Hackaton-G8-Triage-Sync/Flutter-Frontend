const bcrypt = require("bcryptjs");

class PasswordService {
    hash(plainText) {
        return bcrypt.hashSync(plainText, 8);
    }

    compare(plainText, hash) {
        return bcrypt.compareSync(plainText, hash);
    }

    isHash(value) {
        return typeof value === "string" && value.startsWith("$2");
    }
}

module.exports = { PasswordService };
