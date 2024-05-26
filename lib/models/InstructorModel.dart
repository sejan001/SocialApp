class InstructorModel {
  int? id;
  String? name;
  String? image;
  List<String>? field;
  double? workExperience;
  String? summary;

  InstructorModel({
    this.id,
    this.name,
    this.image,
    this.field,
    this.workExperience,
    this.summary,
  });

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      id: json['Id'],
      name: json['Name'],
      image: json['Image'],
      field: json['Field']?.cast<String>(),
      workExperience: json['WorkExperience'],
      summary: json['Summary'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Id'] = id;
    data['Name'] = name;
    data['Image'] = image;
    data['Field'] = field;
    data['WorkExperience'] = workExperience;
    data['Summary'] = summary;
    return data;
  }
}
