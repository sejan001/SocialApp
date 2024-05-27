class Friend {
  String username;

  Friend({required this.username});

  Map<String, dynamic> toJson() {
    return {
      'username': this.username,
    };
  }

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      username: json['username'],
    );
  }
}
