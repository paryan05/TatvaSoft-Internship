from datetime import datetime
from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user
from .. import db
from ..models import Workout

bp = Blueprint("workouts", __name__)


@bp.route("/")
@login_required
def list_workouts():
    workouts = (
        Workout.query.filter_by(user_id=current_user.id)
        .order_by(Workout.date.desc(), Workout.created_at.desc())
        .all()
    )
    return render_template("workouts/list.html", workouts=workouts)


@bp.route("/add", methods=["GET", "POST"])
@login_required
def add_workout():
    if request.method == "POST":
        title = request.form.get("title", "").strip()
        type_ = request.form.get("type", "").strip()
        duration_min = int(request.form.get("duration_min", 0))
        calories_burned = int(request.form.get("calories_burned", 0))
        notes = request.form.get("notes", "").strip() or None
        date_str = request.form.get("date")
        date = datetime.strptime(date_str, "%Y-%m-%d").date() if date_str else None
        workout = Workout(
            user_id=current_user.id,
            title=title,
            type=type_,
            duration_min=duration_min,
            calories_burned=calories_burned,
            notes=notes,
            date=date,
        )
        db.session.add(workout)
        db.session.commit()
        flash("Workout added", "success")
        return redirect(url_for("workouts.list_workouts"))
    return render_template("workouts/form.html", workout=None)


@bp.route("/<int:workout_id>")
@login_required
def view_workout(workout_id: int):
    workout = Workout.query.filter_by(id=workout_id, user_id=current_user.id).first_or_404()
    return render_template("workouts/detail.html", workout=workout)


@bp.route("/<int:workout_id>/edit", methods=["GET", "POST"])
@login_required
def edit_workout(workout_id: int):
    workout = Workout.query.filter_by(id=workout_id, user_id=current_user.id).first_or_404()
    if request.method == "POST":
        workout.title = request.form.get("title", workout.title).strip()
        workout.type = request.form.get("type", workout.type).strip()
        workout.duration_min = int(request.form.get("duration_min", workout.duration_min))
        workout.calories_burned = int(request.form.get("calories_burned", workout.calories_burned))
        workout.notes = request.form.get("notes", workout.notes or "").strip() or None
        date_str = request.form.get("date", str(workout.date))
        workout.date = datetime.strptime(date_str, "%Y-%m-%d").date() if date_str else workout.date
        db.session.commit()
        flash("Workout updated", "success")
        return redirect(url_for("workouts.view_workout", workout_id=workout.id))
    return render_template("workouts/form.html", workout=workout)


@bp.route("/<int:workout_id>/delete", methods=["POST"])
@login_required
def delete_workout(workout_id: int):
    workout = Workout.query.filter_by(id=workout_id, user_id=current_user.id).first_or_404()
    db.session.delete(workout)
    db.session.commit()
    flash("Workout deleted", "info")
    return redirect(url_for("workouts.list_workouts"))
