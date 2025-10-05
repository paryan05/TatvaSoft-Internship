class Workout {
  final int? id;
  final int userId;
  final String title;
  final String type;
  final int durationMin;
  final int caloriesBurned;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  Workout({
    this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.durationMin,
    required this.caloriesBurned,
    required this.notes,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'title': title,
    'type': type,
    'duration_min': durationMin,
    'calories_burned': caloriesBurned,
    'notes': notes,
    'date': date.toIso8601String().substring(0,10),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory Workout.fromMap(Map<String, dynamic> map) => Workout(
    id: map['id'] as int?,
    userId: map['user_id'] as int,
    title: map['title'] as String,
    type: map['type'] as String,
    durationMin: map['duration_min'] as int,
    caloriesBurned: map['calories_burned'] as int,
    notes: map['notes'] as String?,
    date: DateTime.parse(map['date'] as String),
    createdAt: DateTime.parse(map['created_at'] as String),
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );
}
