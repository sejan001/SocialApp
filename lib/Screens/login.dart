import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/Screens/categories.dart';
import 'package:social_app/Screens/forgot_password.dart';
import 'package:social_app/Screens/homeScreen.dart';

import 'package:social_app/Screens/signup.dart';
import 'package:social_app/Screens/splashScreen.dart';
import 'package:social_app/models/sharedPrefService';

import "dart:convert";

import 'package:social_app/models/usermodel.dart';

void main() {
  runApp(MaterialApp(
    home: Login(
      isDark: false,
    ),
  ));
}

class Login extends StatefulWidget {
  final isDark;
  const Login({super.key,this.isDark});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<userModel> existingUsers = [];
  bool _showPass = true;
  List<String> dropDownItems = [
    "Course Categories",
    "Top Courses",
    "Popular Courses"
  ];

  bool isDark = false;
  Future<void> loadUsers() async {
   
  }

  @override
  void initState() {
    loadUsers();
    super.initState();
  }

  clear() {
    _username.clear();
    _password.clear();
  }

  @override
  Widget build(BuildContext context) {
    dynamic username;
    dynamic password;

    final height = MediaQuery.sizeOf(context).height * 1;

    final width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text("Login",
                      style: GoogleFonts.getFont(
                        'Roboto',
                        textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      )),
                ),
                SizedBox(
                  height: height * .05,
                ),
                Container(
                  height: height * .2,
                  width: width * .5,
                  child: LottieBuilder.network(
                      "https://lottie.host/26ae8d19-9da9-4457-b5b0-b952335c2486/vlQj5tVLT8.json"),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          width: width * .7,
                          child: TextFormField(
                            style: TextStyle(
                              color: widget.isDark ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                            validator: (value) {
                              if (value!.length > 10) {
                                return "Cant have more than 10 letters";
                              }
                              if (value.length <= 0 || value.isEmpty) {
                                return "Enter a username";
                              }
                            },
                            controller: _username,
                            decoration: InputDecoration(
                                suffix: IconButton(
                                    color: widget.isDark ? Colors.white : Colors.black,
                                    onPressed: null,
                                    icon: Icon(null)),
                                hintText: "Username",
                                hintStyle: TextStyle(
                                  color: widget.isDark ? Colors.white : Colors.black,
                                  fontSize: 18,
                                ),
                                labelStyle: TextStyle(
                                  color: widget.isDark ? Colors.white : Colors.black,
                                  fontSize: 18,
                                ),
                                labelText: "Enter  Username"),
                          ),
                        ),
                        SizedBox(height: height * .01),
                        Container(
                          width: width * .7,
                          child: TextFormField(
                            style: TextStyle(
                              color: widget.isDark ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                            obscureText: _showPass,
                            validator: (value) {
                              if (value!.length > 10) {
                                return "Cant have more than 10 letters";
                              }
                              if (value!.length <= 0 || value.isEmpty) {
                                return "Enter a password";
                              }
                            },
                            controller: _password,
                            decoration: InputDecoration(
                                suffixIconColor: Colors.blue,
                                suffix: IconButton(
                                    color: widget.isDark ? Colors.white : Colors.black,
                                    onPressed: () {
                                      setState(() {
                                        _showPass = !_showPass;
                                      });
                                    },
                                    icon: Icon(Icons.remove_red_eye)),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  color: widget.isDark ? Colors.white : Colors.black,
                                  fontSize: 18,
                                ),
                                labelStyle: TextStyle(
                                  color: widget.isDark ? Colors.white : Colors.black,
                                  fontSize: 18,
                                ),
                                labelText: "Enter Password"),
                          ),
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 236, 35, 220)),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                 
                                      username = _username.text;
                                      password = _password.text;
                                    String? json = SharedPrefService.getString(key:"sign-up");
    if (json != null && json.isNotEmpty) {
      List<dynamic> jsonUsers = jsonDecode(json);
      existingUsers =
          jsonUsers.map((user) => userModel.fromJson(user)).toList();
    } else {
      print("error loading json");
    }
                              
                                      bool isValid = existingUsers.any((user) =>
                                          user.username == _username.text &&
                                          user.password == _password.text);
                                      bool bothInvalid = existingUsers.any(
                                          (user) =>
                                              user.username != _username.text &&
                                              user.password != _password.text);
                                      bool wrongPassword = existingUsers.any(
                                          (user) =>
                                              user.username == _username.text &&
                                              user.password != _password.text);
                                      bool wrongUsername = existingUsers.any(
                                          (user) =>
                                              user.username != _username.text &&
                                              user.password == _password.text);
                                      if (isValid) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    HomeScreen(
                                                      UserName: username,
                                                      Pass: password,
                                                      isDark: widget.isDark ,
                                                    ))));
                                        ;
                                        
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              backgroundColor: Color.fromARGB(
                                                  255, 21, 236, 67),
                                              content:
                                              
                                                  Text("Login successful")),
                                        );
                                
                                      } else if (wrongPassword) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              backgroundColor: Colors.red,
                                              content:
                                                  Text("Invalid password")),
                                        );
                                      } else if (wrongUsername) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              backgroundColor: Colors.red,
                                              content:
                                                  Text("Invalid username")),
                                        );
                                      } else if (bothInvalid) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  "Try a genuine username and password")),
                                        );
                                      
                                    }
                                            clear();
                                  }
                                },
                                child: Text("Login",
                                    style: GoogleFonts.getFont('Roboto',
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 235, 241, 247),
                                        )))),
                            SizedBox(
                              width: width * .1,
                            ),
                            Column(
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      clear();
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  SignUp(isDark: widget.isDark))));
                                    },
                                    child: Text("Don't have an account",
                                        style: GoogleFonts.getFont('Roboto',
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 19, 127, 235),
                                            )))),
                                TextButton(
                                    onPressed: () async {
                                      clear();
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  ForgotPassword(
                                                    isDark: widget.isDark,
                                                  ))));
                                    },
                                    child: Text("Forgot Password",
                                        style: GoogleFonts.getFont('Roboto',
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 19, 127, 235),
                                            )))),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: width * .05)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
