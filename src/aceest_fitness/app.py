from __future__ import annotations

from flask import Flask, jsonify

from .version import __version__


def create_app() -> Flask:
    app = Flask(__name__)

    @app.get("/health")
    def health():
        return jsonify({"status": "ok", "version": __version__})

    return app
