import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_app/models/friendListModel.dart';
import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';

class NotificationTab extends StatefulWidget {
  final isDark;
  
  final currentUsername;
  final currentPassword;

  const NotificationTab({
    super.key,
    this.currentUsername,
    this.currentPassword, this.isDark,
  });

  @override
  State<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab> {
  List<userModel> existingUsers = [];
  List<FriendModel> friendNotification = [];
  bool isLoading = true;
  Future<void> loadUsers() async {
    String? json = SharedPrefService.getString(key: "sign-up");
    if (json != null && json.isNotEmpty) {
      List<dynamic> jsonUsers = jsonDecode(json);
      existingUsers =
          jsonUsers.map((user) => userModel.fromJson(user)).toList();
      setState(() {
        isLoading = false;
      });
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

    if (currentUser.friendList!.isNotEmpty) {
      friendNotification = currentUser.friendList!
          .where(
              (user) => user.hasNewRequest == true && user.hasRemoved == false)
          .toList();

      if (friendNotification.isNotEmpty) {
        print(friendNotification);
        print(
            "new user is ${friendNotification[0]?.requestedByUsername ?? ''}");
      } else {
        return Center(child: Text("No new notifications"));
      }
    }

    return Scaffold(
            backgroundColor: widget.isDark ? Colors.black : Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.amber,
      // ),
      body: Column(
        children: [
          Expanded(
            child: friendNotification.isEmpty ? Center(child: Text('No new notifications'),) : ListView.builder(
                itemCount: friendNotification.length,
                itemBuilder: (context, index) {
                  final currentNotifi =
                      friendNotification.reversed.toList()[index];
                  final currentNotifiUser = existingUsers.firstWhere(
                      (user) => user.username == currentNotifi.username,
                      orElse: () => userModel(
                          username: " username",
                          password: "password",
                          profileImagePath: "profileImagePath",
                          address: "",
                          education: "",
                          gender: ""));

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: height * .45,
                      width: width * .4,
                      child: Card(
                        color: const Color.fromARGB(255, 231, 223, 223),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * .01,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 40,
                              backgroundImage: FileImage(File(currentNotifiUser
                                  .profileImagePath
                                  .toString())),
                            ),
                            Text(
                              currentNotifi.requestedByUsername.toUpperCase(),
                              style:
                                  TextStyle(fontSize: 25, color: Colors.blue),
                            ),
                            SizedBox(
                              height: height * .1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MaterialButton(
                                  color:
                                      const Color.fromARGB(255, 247, 244, 244),
                                  onPressed: () {
                                    setState(() {
                                      currentUser.friends!.add(
                                          currentNotifiUser.name!.toUpperCase().toString());
                                      currentNotifiUser.friends!
                                          .add(currentUser.name.toString());
                                      SharedPrefService.setString(
                                        key: "sign-up",
                                        value: jsonEncode(existingUsers),
                                      );
                                      currentNotifi.hasNewRequest = false;
                                      print(
                                          " Saathis are ${currentUser.friends}");
                                    });
                                    currentNotifi.hasNewRequestAccepted = true;
                                  },
                                  child: Text(
                                    "Accept",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                SizedBox(
                                  width: width * .1,
                                ),
                                MaterialButton(
                                  color:
                                      const Color.fromARGB(255, 247, 244, 244),
                                  onPressed: () {
                                    setState(() {
                                      friendNotification.removeAt(index);

                                      currentNotifi.hasRemoved = true;
                                      SharedPrefService.setString(
                                        key: "sign-up",
                                        value: jsonEncode(existingUsers),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("Removed Request")));
                                    });
                                  },
                                  child: Text(
                                    "Reject",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height * .03,
                            ),
                            Text(
                              currentNotifi.createdAt.toString(),
                              style:
                                  TextStyle(fontSize: 10, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
