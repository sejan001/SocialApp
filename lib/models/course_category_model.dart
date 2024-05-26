class Course {
  final int id;
  final String title;

  Course({required this.id, required this.title});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['Id'],
      title: json['Title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': title,
    };
  }
}
