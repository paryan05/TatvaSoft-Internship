class MealModel {
  final int? id;
  final int userId;
  final String name;
  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final DateTime date;
  final String? notes;

  const MealModel({
    this.id,
    required this.userId,
    required this.name,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.date,
    this.notes,
  });

  MealModel copyWith({
    int? id,
    int? userId,
    String? name,
    int? calories,
    int? proteinGrams,
    int? carbsGrams,
    int? fatGrams,
    DateTime? date,
    String? notes,
  }) {
    return MealModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      name: map['name'] as String,
      calories: map['calories'] as int,
      proteinGrams: map['protein_grams'] as int,
      carbsGrams: map['carbs_grams'] as int,
      fatGrams: map['fat_grams'] as int,
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'calories': calories,
      'protein_grams': proteinGrams,
      'carbs_grams': carbsGrams,
      'fat_grams': fatGrams,
      'date': date.toIso8601String(),
      'notes': notes,
    }..removeWhere((key, value) => value == null);
  }
}
