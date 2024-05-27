import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:social_app/Screens/showProfiles.dart';
import 'package:social_app/models/friendListModel.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';
import 'package:uuid/uuid.dart';

class MessageSee extends StatefulWidget {
  final userModel friendUser;
  final userModel currentUser;

  const MessageSee({
    super.key,
    required this.friendUser,
    required this.currentUser,
  });

  @override
  State<MessageSee> createState() => _MessageState();
}

class _MessageState extends State<MessageSee> {
  var uuid = Uuid();
  List<userModel> existingUsers = [];
  List<Message> _messages = [];
  TextEditingController _messageController = TextEditingController();
  bool isDark = false;

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
    final currentUser = existingUsers.firstWhere(
      (user) => user.username == widget.currentUser.username,
      orElse: () => widget.currentUser,
    );
    final friendUser = existingUsers.firstWhere(
      (user) => user.username == widget.friendUser.username,
      orElse: () => widget.friendUser,
    );

    _messages = (widget.currentUser.messages ?? [])
        .where((message) =>
            (message.senderUsername == currentUser.username &&
                message.receiverUsername == friendUser.username) ||
            (message.senderUsername == friendUser.username &&
                message.receiverUsername == currentUser.username) ||
            (message.senderUsername == friendUser.username &&
                message.receiverUsername == currentUser.username) ||
            (message.senderUsername == currentUser.username &&
                message.receiverUsername == friendUser.username))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final currentUser = existingUsers.firstWhere(
      (user) => user.username == widget.currentUser.username,
      orElse: () => widget.currentUser,
    );
    final friendUser = existingUsers.firstWhere(
      (user) => user.username == widget.friendUser.username,
      orElse: () => widget.friendUser,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        flexibleSpace: Row(
          children: [
            SizedBox(
              width: width * .13,
            ),
            SafeArea(
              child: CircleAvatar(
                radius: 27,
                backgroundImage:
                    FileImage(File(friendUser.profileImagePath.toString())),
              ),
            ),
            SizedBox(
              width: width * .03,
            ),
            Text(
              friendUser.username.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  bool isMe =
                      message.senderUsername == widget.currentUser.username;
                  return ListTile(
                    key: Key(message.messageId),
                    title: Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(message.content),
                        )),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type your message...',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        setState(() {
                          final newMessage = Message(
                            messageId: uuid.v4(),
                            senderUsername: currentUser.username.toString(),
                            receiverUsername: friendUser.username.toString(),
                            content: _messageController.text,
                            timestamp: DateTime.now(),
                          );

                          int currentUserIndex = existingUsers.indexWhere(
                              (user) => user.username == currentUser.username);
                          int friendUserIndex = existingUsers.indexWhere(
                              (user) => user.username == friendUser.username);
                          if (!widget.currentUser.messages!
                                  .contains(newMessage) &&
                              !widget.friendUser.messages!
                                  .contains(newMessage)) {
                            widget.currentUser.messages!.add(newMessage);
                            widget.friendUser.messages!.add(newMessage);
                            _messages.add(newMessage);

                            if (currentUserIndex != -1 &&
                                friendUserIndex != -1) {
                              existingUsers[currentUserIndex] =
                                  widget.currentUser;
                              existingUsers[friendUserIndex] =
                                  widget.friendUser;
                            }
                          }
                        });
                        SharedPrefService.setString(
                            key: "sign-up", value: jsonEncode(existingUsers));
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
