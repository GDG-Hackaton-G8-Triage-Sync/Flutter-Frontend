const fs = require("fs");

class FileStore {
    constructor(dbPath) {
        this.dbPath = dbPath;
    }

    read() {
        return JSON.parse(fs.readFileSync(this.dbPath, "utf-8"));
    }

    write(data) {
        fs.writeFileSync(this.dbPath, JSON.stringify(data, null, 2));
    }

    update(mutator) {
        const data = this.read();
        const result = mutator(data);
        this.write(data);
        return result;
    }
}

module.exports = { FileStore };
