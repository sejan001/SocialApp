import 'package:social_app/models/friendListModel.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/postModel.dart'; 

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
  List<PostModel>? posts;

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
    this.posts, // Initialize posts
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

    var postsFromJson = json['posts'] as List<dynamic>? ?? [];
    List<PostModel> posts = postsFromJson
        .map((postJson) => PostModel.fromJson(postJson))
        .toList(); // Map posts from JSON

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
      posts: posts, // Assign posts
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
    if (this.posts != null) {
      data['posts'] = this.posts!.map((post) => post!.toJson()).toList();
    }
    return data;
  }
}
