class User {
  final int? id;
  final String email;
  final String password; // For demo only; do not store plain text in prod
  final String name;
  final int dailyCalorieGoal;

  User({this.id, required this.email, required this.password, required this.name, required this.dailyCalorieGoal});

  Map<String, dynamic> toMap() => {
    'id': id,
    'email': email,
    'password': password,
    'name': name,
    'daily_calorie_goal': dailyCalorieGoal,
  };

  factory User.fromMap(Map<String, dynamic> map) => User(
    id: map['id'] as int?,
    email: map['email'] as String,
    password: map['password'] as String,
    name: map['name'] as String,
    dailyCalorieGoal: map['daily_calorie_goal'] as int,
  );
}
