import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_app/models/friendListModel.dart';
import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';

class NotificationTab extends StatefulWidget {
  final currentUsername;
  final currentPassword;

  const NotificationTab({
    super.key,
    this.currentUsername,
    this.currentPassword,
  });

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  List<userModel> existingUsers = [];
  List<FriendModel> friendNotification = [];
  Future<void> loadUsers() async {
    String? json = SharedPrefService.getString(key: "sign-up");
    if (json != null && json.isNotEmpty) {
      List<dynamic> jsonUsers = jsonDecode(json);
      existingUsers =
          jsonUsers.map((user) => userModel.fromJson(user)).toList();
    } else {
      print("error loading json");
    }
  }

  @override
  void initState() {
    loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = existingUsers.firstWhere(
        (user) =>
            user.username == widget.currentUsername &&
            user.password == widget.currentPassword,
        orElse: () => userModel(
            username: " username",
            password: "password",
            profileImagePath: "profileImagePath",
            address: "",
            education: "",
            gender: ""));

    friendNotification = currentUser.friendList!
        .where((user) => user.hasNewRequest == true)
        .toList();
    print(friendNotification);
    ;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: friendNotification.length,
                itemBuilder: (context, index) {
                  final currentNotifi = friendNotification[index];

                  return ListTile(
                    leading: Icon(Icons.mail),
                    subtitle: Text(currentNotifi.requestedByUsername),
                  );
                }),
          )
        ],
      ),
    );
  }
}
