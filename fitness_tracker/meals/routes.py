from datetime import datetime
from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user
from .. import db
from ..models import Meal

bp = Blueprint("meals", __name__)


@bp.route("/")
@login_required
def list_meals():
    meals = (
        Meal.query.filter_by(user_id=current_user.id)
        .order_by(Meal.date.desc(), Meal.created_at.desc())
        .all()
    )
    return render_template("meals/list.html", meals=meals)


@bp.route("/add", methods=["GET", "POST"])
@login_required
def add_meal():
    if request.method == "POST":
        name = request.form.get("name", "").strip()
        calories = int(request.form.get("calories", 0))
        protein_g = int(request.form.get("protein_g", 0))
        carbs_g = int(request.form.get("carbs_g", 0))
        fat_g = int(request.form.get("fat_g", 0))
        notes = request.form.get("notes", "").strip() or None
        date_str = request.form.get("date")
        date = datetime.strptime(date_str, "%Y-%m-%d").date() if date_str else None
        meal = Meal(
            user_id=current_user.id,
            name=name,
            calories=calories,
            protein_g=protein_g,
            carbs_g=carbs_g,
            fat_g=fat_g,
            notes=notes,
            date=date,
        )
        db.session.add(meal)
        db.session.commit()
        flash("Meal added", "success")
        return redirect(url_for("meals.list_meals"))
    return render_template("meals/form.html", meal=None)


@bp.route("/<int:meal_id>")
@login_required
def view_meal(meal_id: int):
    meal = Meal.query.filter_by(id=meal_id, user_id=current_user.id).first_or_404()
    return render_template("meals/detail.html", meal=meal)


@bp.route("/<int:meal_id>/edit", methods=["GET", "POST"])
@login_required
def edit_meal(meal_id: int):
    meal = Meal.query.filter_by(id=meal_id, user_id=current_user.id).first_or_404()
    if request.method == "POST":
        meal.name = request.form.get("name", meal.name).strip()
        meal.calories = int(request.form.get("calories", meal.calories))
        meal.protein_g = int(request.form.get("protein_g", meal.protein_g))
        meal.carbs_g = int(request.form.get("carbs_g", meal.carbs_g))
        meal.fat_g = int(request.form.get("fat_g", meal.fat_g))
        meal.notes = request.form.get("notes", meal.notes or "").strip() or None
        date_str = request.form.get("date", str(meal.date))
        meal.date = datetime.strptime(date_str, "%Y-%m-%d").date() if date_str else meal.date
        db.session.commit()
        flash("Meal updated", "success")
        return redirect(url_for("meals.view_meal", meal_id=meal.id))
    return render_template("meals/form.html", meal=meal)


@bp.route("/<int:meal_id>/delete", methods=["POST"])
@login_required
def delete_meal(meal_id: int):
    meal = Meal.query.filter_by(id=meal_id, user_id=current_user.id).first_or_404()
    db.session.delete(meal)
    db.session.commit()
    flash("Meal deleted", "info")
    return redirect(url_for("meals.list_meals"))
