import 'package:social_app/models/friendListModel.dart';
import 'package:social_app/models/message_model.dart';
import 'package:uuid/uuid.dart';

class userModel {
  late String id;
  String? username;
  String? password;
  String? coverImagePath;
  String? profileImagePath;
  String? name;
  String? gender;
  String? address;
  String? education;
  List<String>? friends;
  List<FriendModel>? friendList;
  List<Message>? messages;

  userModel({
    this.id = '',
    this.username,
    this.password,
    this.coverImagePath,
    this.profileImagePath,
    this.name,
    this.gender,
    this.address,
    this.education,
    this.friends,
    this.friendList,
    this.messages,
  });

  factory userModel.fromJson(Map<String, dynamic> json) {
    var friendListFromJson = json['friendList'] as List<dynamic>? ?? [];
    List<FriendModel> friendList = friendListFromJson
        .map((friendJson) => FriendModel.fromJson(friendJson))
        .toList();

    var messagesFromJson = json['messages'] as List<dynamic>? ?? [];
    List<Message> messages = messagesFromJson
        .map((messageJson) => Message.fromJson(messageJson))
        .toList();

    return userModel(
      id: json['id'] ?? Uuid().v4(),
      username: json['username'],
      password: json['password'],
      coverImagePath: json['coverImagePath'],
      profileImagePath: json['profileImagePath'],
      name: json['name'],
      gender: json['gender'],
      address: json['address'],
      education: json['education'],
      friends:
          json['friends'] != null ? List<String>.from(json['friends']) : [],
      friendList: friendList,
      messages: messages,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['coverImagePath'] = this.coverImagePath;
    data['profileImagePath'] = this.profileImagePath;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['education'] = this.education;
    data['friends'] = this.friends;
    if (this.friendList != null) {
      data['friendList'] =
          this.friendList!.map((friend) => friend.toJson()).toList();
    }
    if (this.messages != null) {
      data['messages'] =
          this.messages!.map((message) => message.toJson()).toList();
    }
    return data;
  }
}
