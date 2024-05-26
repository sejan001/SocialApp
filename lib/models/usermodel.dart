import 'package:social_app/models/friendListModel.dart';

class userModel {
  String? username;
  String? password;
  String? coverImagePath;
  String? profileImagePath;
  String? name;
  String? gender;
  String? address;
  String? education;
  List<FriendModel>? friendList;

  userModel({
    required this.username,
    required this.password,
    this.coverImagePath,
    this.profileImagePath,
    this.name,
    this.gender,
    this.address,
    this.education,
    this.friendList,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['coverImagePath'] = this.coverImagePath;
    data['profileImagePath'] = this.profileImagePath;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['education'] = this.education;
    if (this.friendList != null) {
      data['friendList'] =
          this.friendList!.map((friend) => friend.toJson()).toList();
    }
    return data;
  }

  factory userModel.fromJson(Map<String, dynamic> json) {
    var friendListFromJson = json['friendList'] as List<dynamic>? ?? [];
    List<FriendModel> friendList = friendListFromJson
        .map((friendJson) => FriendModel.fromJson(friendJson))
        .toList();

    return userModel(
      username: json['username'],
      password: json['password'],
      coverImagePath: json['coverImagePath'],
      profileImagePath: json['profileImagePath'],
      name: json['name'],
      gender: json['gender'],
      address: json['address'],
      education: json['education'],
      friendList: friendList,
    );
  }
}
