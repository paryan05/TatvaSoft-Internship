from datetime import date, datetime
from flask import Blueprint, render_template, redirect, url_for
from flask_login import login_required, current_user
from ..models import Workout, Meal

bp = Blueprint("main", __name__)


@bp.route("/")
def dashboard():
    # Splash for unauthenticated users
    if not current_user.is_authenticated:
        return render_template("splash.html")
    today = date.today()
    workouts_today = Workout.query.filter_by(user_id=current_user.id, date=today).all()
    meals_today = Meal.query.filter_by(user_id=current_user.id, date=today).all()
    calories_burned = sum(w.calories_burned for w in workouts_today)
    calories_consumed = sum(m.calories for m in meals_today)
    net_calories = current_user.daily_calorie_goal - calories_consumed + calories_burned
    return render_template(
        "dashboard.html",
        workouts_today=workouts_today,
        meals_today=meals_today,
        calories_burned=calories_burned,
        calories_consumed=calories_consumed,
        net_calories=net_calories,
        calorie_goal=current_user.daily_calorie_goal,
    )


@bp.route("/progress")
@login_required
def progress():
    return render_template("progress.html")


@bp.route("/profile", methods=["GET", "POST"])
@login_required
def profile():
    from flask import request, flash, redirect, url_for
    user = current_user
    if request.method == "POST":
        name = request.form.get("name", user.name).strip() or user.name
        goal = int(request.form.get("daily_calorie_goal", user.daily_calorie_goal))
        user.name = name
        user.daily_calorie_goal = goal
        from .. import db
        db.session.commit()
        flash("Profile updated", "success")
        return redirect(url_for("main.profile"))
    return render_template("profile.html", user=user)


@bp.route("/tips")
@login_required
def tips():
    return render_template("tips.html")


@bp.route("/settings")
@login_required
def settings():
    return render_template("settings.html")


@bp.route("/about")
@login_required
def about():
    return render_template("about.html")
