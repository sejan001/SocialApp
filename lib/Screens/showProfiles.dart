import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/friendListModel.dart';

import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';

class Showprofiles extends StatefulWidget {
  final bool onlyView;
  final String username;
  final String password;
  final isDark;
  final currentUsername;
  final currentPassword;
  final targetUser;
  Showprofiles({
    Key? key,
    required this.username,
    required this.password,
    this.isDark,
    this.targetUser,
    this.currentUsername,
    this.currentPassword,
    required this.onlyView,
  }) : super(key: key);

  @override
  State<Showprofiles> createState() => _ShowprofilesState();
}

class _ShowprofilesState extends State<Showprofiles> {
  List<userModel> existingUsers = [];
  List<FriendModel> friends = [];

  Future<void> loadUsers() async {
    try {
      String? json = SharedPrefService.getString(key: "sign-up");
      if (json != null && json.isNotEmpty) {
        try {
          List<dynamic> jsonUsers = jsonDecode(json);
          existingUsers =
              jsonUsers.map((user) => userModel.fromJson(user)).toList();
        } on FormatException {
          print("Invalid JSON string: $json");
        }
      }
    } catch (e) {
      print("error is $e");
    }
  }

  @override
  void initState() {
    loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool showAdd = widget.onlyView;
    String username = widget.username;
    String password = widget.password;
    DateTime now = DateTime.now();
    String dateFormate = DateFormat("yyyy-MM-dd").format(now);
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
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
    final friendUser = existingUsers.firstWhere(
        (user) => user.username == username && user.password == password,
        orElse: () => userModel(
            username: " username",
            password: "password",
            profileImagePath: "profileImagePath",
            address: "",
            education: "",
            gender: ""));

    print("currentUser is ${friendUser.username}");
    String ppPath = friendUser.profileImagePath.toString();

    sendRequest(userModel currentUser, userModel targetUser) {
      final newFriendReq = FriendModel(
          username: currentUser.username.toString(),
          friendUsername: friendUser.username.toString(),
          requestedByUsername: currentUser.username.toString(),
          createdAt: now,
          hasNewRequest: true,
          hasNewRequestAccepted: false,
          hasRemoved: false);
      setState(() {
        friendUser.friendList!.add(newFriendReq);
        SharedPrefService.setString(
            key: "sign-up", value: jsonEncode(existingUsers));
      });

      print("saathi is ${friendUser.username}");
      print("ma is ${currentUser.username}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("Sent Request")));
    }

    return Scaffold(
        appBar: AppBar(),
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: const Color.fromARGB(255, 197, 196, 196),
                      image: DecorationImage(
                          image: FileImage(
                              File(friendUser.coverImagePath.toString())),
                          fit: BoxFit.cover)),
                  height: height * .3,
                  width: width * 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2),
                          color: Colors.amber,
                          shape: BoxShape.circle),
                      child: CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(
                              File(friendUser.profileImagePath.toString()))),
                    ),
                  ),
                ),
              ]),
              Text(
                "Name : ${friendUser.name}",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Gender: ${friendUser.gender} ",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Address: ${friendUser.address}",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Education: ${friendUser.education} ",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: height * .01,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 210, 219, 219),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  leading: showAdd
                      ? Icon((Icons.person), color: Colors.green)
                      : IconButton(
                          onPressed: () {
                            sendRequest(currentUser, friendUser);
                          },
                          icon: Icon(Icons.add)),
                  trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          currentUser.friends = currentUser.friends ?? [];
                          currentUser.friends!.remove(friendUser.username);
                          SharedPrefService.setString(
                            key: "sign-up",
                            value: jsonEncode(existingUsers),
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Removed Friend"),
                          ),
                        );
                      },
                      icon: Icon(Icons.cancel)),
                ),
              )
            ],
          ),
        ));
  }
}
