import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:social_app/Screens/Tabs/Friends_Tab.dart';
import 'package:social_app/Screens/Tabs/Home_Tab.dart';
import 'package:social_app/Screens/message_see.dart';
import 'package:social_app/Screens/Tabs/notification.dart';

import 'package:social_app/Screens/Tabs/profile_tab.dart';
import 'package:social_app/Screens/categories.dart';
import 'package:social_app/Screens/login.dart';

import 'package:social_app/Screens/Tabs/messages_screen_tab.dart';

import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';

class HomeScreen extends StatefulWidget {
  final String UserName;
  final String Pass;

  HomeScreen({
    Key? key,
    required this.UserName,
    required this.Pass,
    required bool isDark,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<userModel> existingUsers = [];
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
  }

  @override
  Widget build(BuildContext context) {
    String username = widget.UserName;
    String password = widget.Pass;
    final height = MediaQuery.sizeOf(context).height * 1;

    final width = MediaQuery.sizeOf(context).width * 1;

    final currentUser = existingUsers.firstWhere(
        (user) => user.username == username && user.password == password,
        orElse: () => userModel(
            username: " username",
            password: "password",
            profileImagePath: "profileImagePath"));

    print("currentUser is ${currentUser.username}");
    String ppPath = currentUser.profileImagePath.toString();
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        drawer: Container(
          decoration: BoxDecoration(),
          width: 250,
          child: Drawer(
            backgroundColor: isDark ? Colors.black : Colors.white,
            child: ListView(
              children: [
                Container(
                  height: height * .15,
                  child: DrawerHeader(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: isDark
                                  ? NetworkImage(
                                      "https://www.emoji.co.uk/files/phantom-open-emojis/travel-places-phantom/12735-night-with-stars.png")
                                  : NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRarRBZpwj825CzL1v8JWKVQ78T0g1jvCga7xuTk7q3xsv1Dw-5nCxHAlACkiT2KDby5rI&usqp=CAU"),
                              fit: BoxFit.cover),
                          color: isDark ? Colors.white : Colors.black),
                      child: Center(
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Center(
                                      child: Text(
                                    "Market",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Switch(
                                      activeTrackColor: Colors.black,
                                      inactiveThumbColor: Colors.black,
                                      activeColor: Colors.white,
                                      value: isDark,
                                      onChanged: (value) {
                                        setState(() {
                                          isDark = !isDark;
                                        });
                                      }),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoriesScreen(
                                  title: "Categories",
                                  isDark: isDark,
                                )));
                  },
                  leading: Icon(Icons.book_online_outlined,
                      color: isDark ? Colors.white : Colors.black),
                  title: Text(
                    "Course Categories",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TopCourses(
                                isDark: isDark, title: "Top Courses")));
                  },
                  leading: Icon(
                    Icons.book_online_outlined,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  title: Text("Top Courses",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      )),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PopularCourses(
                                isDark: isDark, title: "Popular Courses")));
                  },
                  leading: Icon(Icons.book_online_outlined,
                      color: isDark ? Colors.white : Colors.black),
                  title: Text("Popular Courses",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      )),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login(isDark: isDark)));
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                    ))
              ],
            ),
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                iconTheme:
                    IconThemeData(color: isDark ? Colors.white : Colors.black),
                backgroundColor: isDark ? Colors.black : Colors.white,
                title: Text(
                  "HomeScreen",
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
                centerTitle: true,
                floating: true,
                pinned: true,
                snap: true,
                bottom: TabBar(
                  tabs: [
                    Tab(
                        icon: Icon(Icons.person,
                            color: isDark ? Colors.white : Colors.black)),
                    Tab(
                        icon: Icon(
                      Icons.home,
                      color: isDark ? Colors.white : Colors.black,
                    )),
                    Tab(
                        icon: Icon(Icons.message,
                            color: isDark ? Colors.white : Colors.black)),
                    Tab(
                        icon: Icon(
                      Icons.people,
                      color: isDark ? Colors.white : Colors.black,
                    )),
                    Tab(
                      icon: Icon(Icons.notification_add_sharp, color: isDark ? Colors.white : Colors.black),
                    )
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ProfileTab(
                isDark: isDark,
                username: username,
                password: password,
              ),
              HomeTab(isDark: isDark,UserName : currentUser.username, Pass : currentUser.password),
              MesssageScreen(
                isDark: isDark,
                  currentUsername: currentUser.username,
                  currentPassword: currentUser.password),
              Friends(
                 isDark: isDark,
                  currentUsername: currentUser.username,
                  currentPassword: currentUser.password),
              NotificationTab(
                 isDark: isDark,
                  currentUsername: currentUser.username,
                  currentPassword: currentUser.password)
            ],
          ),
        ),
      ),
    );
  }
}
