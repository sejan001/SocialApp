import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_app/Screens/FriendList.dart';
import 'package:social_app/Screens/Tabs/profile_tab.dart';
import 'package:social_app/Screens/showProfiles.dart';
import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';

class Friends extends StatefulWidget {
  final isDark;
  final currentUsername;
  final currentPassword;
  final isGuest;
  const Friends({
    super.key,
    this.currentUsername,
    this.currentPassword, this.isDark, this.isGuest,
  });

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  TextEditingController _friends = TextEditingController();
  List<userModel> existingUsers = [];
  List<userModel> searchedUsers = [];
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

  _search() {
    setState(() {
      if (_friends.text.isEmpty) {
        searchedUsers.clear();
      } else {
        searchedUsers = existingUsers
            .where((user) =>
                user.name!
                    .toLowerCase()
                    .startsWith(_friends.text.toLowerCase()) &&
                user.username != widget.currentUsername)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: width * .5,
                        child: TextField(
                          style: TextStyle(color:  widget.isDark ? Colors.white : Colors.black,),
                          onChanged: (value) {
                            _search();
                          },
                          controller: _friends,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color:  widget.isDark ? Colors.white : Colors.black,),
                              hintText: "Search username",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          _search();
                        },
                        icon: Icon(Icons.search,color:  widget.isDark ? Colors.white : Colors.black,)),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      tooltip: 'Friend List',
                        onPressed: () {

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FriendList(
                                    isDark : widget.isDark,
                                        
                                        currentUsername: widget.currentUsername,
                                        currentPassword: widget.currentPassword,
                                      )));
                        },
                        icon: Icon(Icons.people_alt,color:  widget.isDark ? Colors.white : Colors.black,))
                  ],
                ),
                SizedBox(
                  height: height * .03,
                ),
                Expanded(
                  child: searchedUsers.isEmpty
                      ? Center(
                          child: _friends.text.isEmpty
                              ? Text("Search for Users",style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),)
                              : Text("No Users found",style: TextStyle(color: widget.isDark ? Colors.white : Colors.black)),
                        )
                      : ListView.builder(
                          itemCount: searchedUsers.length,
                          itemBuilder: (context, index) {
                            final user = searchedUsers[index];

                         
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Showprofiles(
                                            isGuest: widget.isGuest,
                                                currentUsername:
                                                    widget.currentUsername,
                                                currentPassword:
                                                    widget.currentPassword,
                                                targetUser: user,
                                                isDark: widget.isDark,
                                                friendPassword: user.password,
                                                friendUsername: user.username,
                                               
                                               
                                              )));
                                  print(widget.currentUsername);
                                  print(user);
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: FileImage(File(
                                              user.profileImagePath.toString())),
                                        ),
                                        title: Text(
                                          user.name.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        )),
                                  ),
                                ),
                              ),
                            );
                          }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
