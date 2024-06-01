import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_app/Screens/message_see.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/sharedPrefService';

import 'package:social_app/models/usermodel.dart';

class MesssageScreen extends StatefulWidget {
  final isDark;
  final currentUsername;
  final currentPassword;
final isGuest;
  const MesssageScreen({
    Key? key,
    required this.currentUsername,
    required this.currentPassword, this.isDark, this.isGuest,
  }) : super(key: key);

  @override
  State<MesssageScreen> createState() => _MesssageScreenState();
}

class _MesssageScreenState extends State<MesssageScreen> {
  late List<userModel> existingUsers;
  bool isLoading = true;
  late userModel currentUser;
  TextEditingController _friends = TextEditingController();
  List<userModel> searchedUsers = [];
  Future<void> loadUsers() async {
    String? json = SharedPrefService.getString(key: "sign-up");
    if (json != null && json.isNotEmpty) {
      List<dynamic> jsonUsers = jsonDecode(json);
      existingUsers =
          jsonUsers.map((user) => userModel.fromJson(user)).toList();
      currentUser = existingUsers.firstWhere(
        (user) =>
            user.username == widget.currentUsername &&
            user.password == widget.currentPassword,
        orElse: () => userModel(
          username: 'Unknown',
          password: '',
          profileImagePath: '',
          messages: [],
        ),
      );
    } else {
      print("Error loading JSON");
    }
    setState(() {
      isLoading = false;
    });
  }
  void updateMessagesList() {

    loadUsers().then((_) {
      setState(() {});
    });
  }
  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loadUsers(),
        builder: (context, snapshot) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return buildMessagesScreen();
          }
        },
      ),
    );
  }

  Widget buildMessagesScreen() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Map<String, List<Message>> groupedMessages = {};
    currentUser.messages!.forEach((message) {
      String otherUser = message.senderUsername == currentUser.username
          ? message.receiverUsername!
          : message.senderUsername!;
      if (!groupedMessages.containsKey(otherUser)) {
        groupedMessages[otherUser] = [];
      }
      groupedMessages[otherUser]!.add(message);
    });

    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: groupedMessages.isEmpty ? Center(child: Text('No Messages',style: TextStyle(
          color: widget.isDark ? Colors.white : Colors.black
        ),),): SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: height * .01),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedMessages.length,
                    itemBuilder: (context, index) {
                      final otherUser = groupedMessages.keys.toList()[index];
                      final latestMessage = groupedMessages[otherUser]!.last;
                      final friendUser = existingUsers.firstWhere(
                        (user) => user.username == otherUser,
                        orElse: () => userModel(
                          username: 'Unknown',
                          password: '',
                          profileImagePath: '',
                          messages: [],
                        ),
                      );
if (friendUser.messages!.where((message)=>  (message.senderUsername == currentUser.username &&
                message.receiverUsername == friendUser.username) ||
            (message.senderUsername == friendUser.username &&
                message.receiverUsername == currentUser.username) ||
            (message.senderUsername == friendUser.username &&
                message.receiverUsername == currentUser.username) ||
            (message.senderUsername == currentUser.username &&
                message.receiverUsername == friendUser.username)).isNotEmpty && friendUser.messages!.where((message)=>  (message.senderUsername == currentUser.username &&
                message.receiverUsername == friendUser.username) ||
            (message.senderUsername == friendUser.username &&
                message.receiverUsername == currentUser.username) ||
            (message.senderUsername == friendUser.username &&
                message.receiverUsername == currentUser.username) ||
            (message.senderUsername == currentUser.username &&
                message.receiverUsername == friendUser.username)).isNotEmpty) 
    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessageSee(
                                   onUpdateMessagesList: updateMessagesList,
                                  friendUser: friendUser,
                                  currentUser: currentUser,
                                ),
                              ),
                            );
                            print("sathi is ${friendUser.username}");
                            print('ma is ${currentUser.username}');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: FileImage(File(
                                      friendUser.profileImagePath.toString()))),
                              title: Text(
                                  friendUser.username!.toUpperCase().toString(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              subtitle: Text(latestMessage.content!), //
                            ),
                          ),
                        ),
                      );
                      
  
                  }

                    
                    ,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
