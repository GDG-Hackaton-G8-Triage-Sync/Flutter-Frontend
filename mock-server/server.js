const { env } = require("./src/config/env");
const { FileStore } = require("./src/db/store");
const { TokenService } = require("./src/services/tokenService");
const { PasswordService } = require("./src/services/passwordService");
const { RealtimeGateway } = require("./src/services/realtimeGateway");
const { createApp } = require("./src/app");

const store = new FileStore(env.dbPath);
const tokenService = new TokenService(env.jwtSecret);
const passwordService = new PasswordService();

const realtime = new RealtimeGateway({
    port: env.wsPort,
    path: env.wsPath,
    tokenService,
});

const app = createApp({
    store,
    tokenService,
    passwordService,
    realtime,
});

app.listen(env.apiPort, () => {
    console.log("\nMock API server is running");
    console.log(`  API: http://localhost:${env.apiPort}/api/v1/`);
});

realtime.start();
console.log("Realtime gateway is running");
console.log(`  WS:  ws://localhost:${env.wsPort}${env.wsPath}\n`);
