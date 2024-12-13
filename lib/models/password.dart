class Password {
  int? id;
  int userId;
  String title;
  String username;
  String password;

  Password({
    this.id,
    required this.userId,
    required this.title,
    required this.username,
    required this.password,
  });

  factory Password.fromMap(Map<String, dynamic> json) => Password(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        username: json['username'],
        password: json['password'],
      );

  Map<String, dynamic> toMap() {
    if (id != null) {
      return {
        'id': id,
        'userId': userId,
        'title': title,
        'username': username,
        'password': password,
      };
    }
    return {
      'userId': userId,
      'title': title,
      'username': username,
      'password': password,
    };
  }
}
