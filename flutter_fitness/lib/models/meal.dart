class Meal {
  final int? id;
  final int userId;
  final String name;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  Meal({
    this.id,
    required this.userId,
    required this.name,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.notes,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'calories': calories,
    'protein_g': proteinG,
    'carbs_g': carbsG,
    'fat_g': fatG,
    'notes': notes,
    'date': date.toIso8601String().substring(0,10),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory Meal.fromMap(Map<String, dynamic> map) => Meal(
    id: map['id'] as int?,
    userId: map['user_id'] as int,
    name: map['name'] as String,
    calories: map['calories'] as int,
    proteinG: map['protein_g'] as int,
    carbsG: map['carbs_g'] as int,
    fatG: map['fat_g'] as int,
    notes: map['notes'] as String?,
    date: DateTime.parse(map['date'] as String),
    createdAt: DateTime.parse(map['created_at'] as String),
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );
}
