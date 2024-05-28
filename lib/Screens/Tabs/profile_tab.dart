import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_app/Screens/edit_profile.dart';
import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';

class ProfileTab extends StatefulWidget {
  final String username;
  final String password;
  final isDark;
  ProfileTab({
    Key? key,
    required this.username,
    required this.password,
    this.isDark,
  }) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  List<userModel> existingUsers = [];
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
  void updateProfile(){
    loadUsers().then((_){
      setState(() {
        
      });

    });
  }
  @override
  void initState() {
    loadUsers();
    super.initState();
    updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    String username = widget.username;
    String password = widget.password;

    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    final currentUser = existingUsers.firstWhere(
        (user) => user.username == username && user.password == password,
        orElse: () => userModel(
            username: " username",
            password: "password",
            profileImagePath: "profileImagePath",
            address: "",
            education: "",
            gender: ""));

    print("currentUser is ${currentUser.username}");
    String ppPath = currentUser.profileImagePath.toString();

    return Scaffold(
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
                              File(currentUser.coverImagePath.toString())),
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
                              File(currentUser.profileImagePath.toString()))),
                    ),
                  ),
                ),
              ]),
              Text(
                "Name : ${currentUser.name}",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Gender: ${currentUser.gender} ",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Address: ${currentUser.address}",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Education: ${currentUser.education} ",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: height * .01,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 15, 231, 220),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  iconColor: widget.isDark ? Colors.white : Colors.black,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(
                                  updateProfileScreen : (){ updateProfile();},
                                    isDark: widget.isDark,
                                    username: currentUser.username,
                                    password: currentUser.password)));
                      },
                      icon: Icon(Icons.person_2_outlined)),
                  trailing: IconButton(
                      onPressed: () {}, icon: Icon(Icons.add_a_photo)),
                ),
              )
            ],
          ),
        ));
  }
}
