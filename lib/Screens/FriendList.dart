import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_app/Screens/showProfiles.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';
import 'package:uuid/uuid.dart';

class FriendList extends StatefulWidget {
  
  final currentUsername;
  final currentPassword;
  const FriendList(
      {super.key, this.currentUsername, this.currentPassword});

  @override
  State<FriendList> createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  var uuid = Uuid();
  TextEditingController _friends = TextEditingController();
  List<userModel> existingUsers = [];
  List<String> currentUserFriends = [];
  List<Message> messages = [];
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
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    TextEditingController _message = TextEditingController();

    final currentuser = existingUsers.firstWhere(
        (user) =>
            user.username == widget.currentUsername &&
            user.password == widget.currentPassword,
        orElse: () => userModel(username: "", password: "", friends: []));

    if (currentuser != null && currentuser.friends != null) {
      setState(() {
        currentUserFriends = currentuser.friends ?? [];
      });
    }
    print("saathis are $currentUserFriends");
    return Scaffold(
      appBar: AppBar(),
      body: currentUserFriends.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("You don't have any friends"),
                  const SizedBox(height: 16),
                ],
              ),
            )
          : ListView.builder(
              itemCount: currentUserFriends.length,
              itemBuilder: (context, index) {
                final currentfriend = currentUserFriends[index];
                final currentFriend = existingUsers.firstWhere(
                    (user) => user.username!.toLowerCase() == currentfriend.toLowerCase(), orElse: () => userModel(username: "", password: "", profileImagePath: "", address: "", education: "", gender: ""));
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Showprofiles(
                                  isDark: false,
                                  currentUsername: currentuser.username,

                                  currentPassword: currentuser.password,
                                  friendUsername: currentFriend.username,
                                  friendPassword:
                                      currentFriend.password)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 199, 203, 206),
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundImage: FileImage(File(
                                currentFriend.profileImagePath.toString()))),
                        title: Text(
                          currentfriend,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Send Message"),
                                      actions: [
                                        TextField(
                                          controller: _message,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                            hintText: "send message",
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              final newMessage = Message(messageId: uuid.v4(), senderUsername: currentuser.username.toString(),
                                              receiverUsername: currentFriend.username.toString(), content: _message.text, timestamp: DateTime.now());
                                              currentFriend.messages!.add(newMessage);
                                              currentuser.messages!.add(newMessage);
                                              SharedPrefService.setString(key: 'sign-up', value: jsonEncode(existingUsers));
                                              Navigator.pop(context);
                                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sent Message')));
                                              print('pahilo message is ${currentuser.messages}');
                                              print('dusro message is ${newMessage.content}');

                                            },
                                            icon: Icon(Icons.arrow_forward)),
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(Icons.message)),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
