import 'package:flutter/material.dart';
import 'package:social_app/Screens/FriendList.dart';
import 'package:social_app/Screens/Tabs/Friends_Tab.dart';
import 'package:social_app/Screens/Tabs/Home_Tab.dart';
import 'package:social_app/Screens/Tabs/notification.dart';
import 'package:social_app/Screens/Tabs/profile_tab.dart';
import 'package:social_app/Screens/edit_profile.dart';
import 'package:social_app/Screens/homeScreen.dart';
import 'package:social_app/Screens/internet.dart';

import 'package:social_app/Screens/login.dart';
import 'package:social_app/Screens/message_see.dart';

import 'package:social_app/Screens/showProfiles.dart';
import 'package:social_app/Screens/signup.dart';

import 'package:social_app/models/sharedPrefService';

void main() {
  SharedPrefService.init();
  WidgetsFlutterBinding();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: Login(isDark: false));
  }
}
