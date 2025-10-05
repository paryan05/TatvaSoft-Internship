from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from pathlib import Path
import os

# Global extensions

db = SQLAlchemy()
login_manager = LoginManager()
login_manager.login_view = "auth.login"


def create_app(test_config: dict | None = None) -> Flask:
    app = Flask(__name__, instance_relative_config=True)

    # Default config
    app.config.from_mapping(
        SECRET_KEY=os.environ.get("SECRET_KEY", "dev-secret-key"),
        SQLALCHEMY_DATABASE_URI=os.environ.get(
            "DATABASE_URL",
            f"sqlite:///{Path(app.instance_path) / 'fitness.sqlite3'}",
        ),
        SQLALCHEMY_TRACK_MODIFICATIONS=False,
    )

    # Load instance config if present
    if test_config is not None:
        app.config.update(test_config)
    else:
        # ensure instance folder exists
        Path(app.instance_path).mkdir(parents=True, exist_ok=True)

    # Init extensions
    db.init_app(app)
    login_manager.init_app(app)

    # Register blueprints
    from .auth.routes import bp as auth_bp
    from .workouts.routes import bp as workouts_bp
    from .meals.routes import bp as meals_bp
    from .main.routes import bp as main_bp

    app.register_blueprint(auth_bp)
    app.register_blueprint(workouts_bp, url_prefix="/workouts")
    app.register_blueprint(meals_bp, url_prefix="/meals")
    app.register_blueprint(main_bp)

    # CLI command to init db
    @app.cli.command("init-db")
    def init_db_command():  # pragma: no cover
        from . import models  # noqa: F401  ensure models imported
        db.create_all()
        print("Initialized the database.")

    return app
