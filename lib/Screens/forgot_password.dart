import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:social_app/models/sharedPrefService';

import "dart:convert";

import 'package:social_app/models/usermodel.dart';

void main() {
  runApp(MaterialApp(
    home: ForgotPassword(
      isDark: false,
    ),
  ));
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key, required this.isDark});
  final bool isDark;

  @override
  State<ForgotPassword> createState() => _LoginState();
}

class _LoginState extends State<ForgotPassword> {
  static TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<userModel> existingUsers = [];
  bool _showPass = true;

  clear() {
    _username.clear();
    _password.clear();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;

    final width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
          iconTheme:
              IconThemeData(color: widget.isDark ? Colors.white : Colors.black),
          backgroundColor: widget.isDark ? Colors.black : Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text("Change Password",
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
                  width: width * .3,
                  child: LottieBuilder.network(
                      "https://lottie.host/6be7ae32-5eee-4e83-ba66-e219beb590eb/ij4p86Dq9M.json"),
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
                                color: widget.isDark
                                    ? Colors.white
                                    : Colors.black),
                            validator: (value) {
                              if (value!.length > 10) {
                                return "Cant have more than 10 letters";
                              }
                              if (value!.length <= 0 || value.isEmpty) {
                                return "Enter a username";
                              }
                            },
                            controller: _username,
                            decoration: InputDecoration(
                                suffix: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: IconButton(
                                        onPressed: null, icon: Icon(null))),
                                hintText: "Username",
                                hintStyle: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                labelStyle: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                labelText: "Enter  Username"),
                          ),
                        ),
                        SizedBox(height: height * .01),
                        Container(
                          width: width * .7,
                          child: TextFormField(
                            style: TextStyle(
                                color: widget.isDark
                                    ? Colors.white
                                    : Colors.black),
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
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    onPressed: () {
                                      setState(() {
                                        _showPass = !_showPass;
                                      });
                                    },
                                    icon: Icon(Icons.remove_red_eye)),
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                labelStyle: TextStyle(
                                    color: widget.isDark
                                        ? Colors.white
                                        : Colors.black),
                                labelText: "Enter new Password"),
                          ),
                        ),
                        SizedBox(
                          height: height * .03,
                        ),
                        Center(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 236, 35, 220)),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  String? jsonString =
                                      SharedPrefService.getString(
                                          key: "sign-up");
                                  if (jsonString != null) {
                                    List<dynamic> jsonList =
                                        json.decode(jsonString);
                                    List<userModel> existingUsers = jsonList
                                        .map((e) => userModel.fromJson(e))
                                        .toList();
                                    int index = existingUsers.indexWhere(
                                        (user) =>
                                            user.username == _username.text);
                                    String newpassword = _password.text;
                                    if (index != -1) {
                                      existingUsers[index].password =
                                          newpassword;

                                      String encodedUsers =
                                          jsonEncode(existingUsers);

                                      SharedPrefService.setString(
                                          key: "sign-up", value: encodedUsers);
                                      print(encodedUsers);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  "Password Changed Successfully")));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.red,
                                              content:
                                                  Text("User doesnot Exist")));
                                    }
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text("Enter Details")));
                                }
                              },
                              child: Text("ChangePassword",
                                  style: GoogleFonts.getFont('Roboto',
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 235, 241, 247),
                                      )))),
                        ),
                        SizedBox(
                          width: width * .1,
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
