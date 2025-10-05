class WorkoutModel {
  final int? id;
  final int userId;
  final String title;
  final String type; // e.g., cardio, strength
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime date;
  final String? notes;

  const WorkoutModel({
    this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.date,
    this.notes,
  });

  WorkoutModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? type,
    int? durationMinutes,
    int? caloriesBurned,
    DateTime? date,
    String? notes,
  }) {
    return WorkoutModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      type: map['type'] as String,
      durationMinutes: map['duration_minutes'] as int,
      caloriesBurned: map['calories_burned'] as int,
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'type': type,
      'duration_minutes': durationMinutes,
      'calories_burned': caloriesBurned,
      'date': date.toIso8601String(),
      'notes': notes,
    }..removeWhere((key, value) => value == null);
  }
}
