const { WebSocketServer } = require("ws");

class RealtimeGateway {
    constructor({ port, path, tokenService }) {
        this.port = port;
        this.path = path;
        this.tokenService = tokenService;
        this.clients = new Map();
        this.wss = null;
    }

    start() {
        this.wss = new WebSocketServer({ port: this.port, path: this.path });

        this.wss.on("connection", (ws) => {
            let authenticated = false;

            const authTimer = setTimeout(() => {
                if (!authenticated) {
                    ws.send(
                        JSON.stringify({
                            type: "ERROR",
                            message: "AUTH_REQUIRED",
                        }),
                    );
                    ws.terminate();
                }
            }, 5000);

            ws.on("message", (message) => {
                try {
                    const data = JSON.parse(message.toString());

                    if (data.type === "AUTH") {
                        const decoded = this.tokenService.verify(data.token);
                        authenticated = true;
                        clearTimeout(authTimer);
                        this.clients.set(ws, decoded);
                        ws.send(JSON.stringify({ type: "AUTH_SUCCESS" }));
                        return;
                    }

                    if (data.type === "PING") {
                        ws.send(JSON.stringify({ type: "PONG" }));
                    }
                } catch (_) {
                    ws.send(
                        JSON.stringify({
                            type: "ERROR",
                            message: "INVALID_FRAME",
                        }),
                    );
                }
            });

            ws.on("close", () => {
                clearTimeout(authTimer);
                this.clients.delete(ws);
            });
        });

        return this.wss;
    }

    broadcast(type, payload) {
        const frame = JSON.stringify({
            type,
            timestamp: new Date().toISOString(),
            data: payload,
        });

        for (const ws of this.clients.keys()) {
            if (ws.readyState === 1) {
                ws.send(frame);
            }
        }
    }
}

module.exports = { RealtimeGateway };
