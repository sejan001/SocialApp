import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(
      {super.key,
      required this.isDark,
      required this.username,
      required this.password});
  final bool isDark;
  final username;
  final password;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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

  @override
  void initState() {
    loadUsers();
    super.initState();
  }

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _fullName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _education = TextEditingController();
  TextEditingController _address = TextEditingController();

  String NoImageSelected = "No image selected";
  File? image;
  File? imageCover;
  String _gender = "male";
  List<String> genders = ["male", "female", "others"];
  clear() {
    _username.clear();
    _password.clear();
  }

  Future<void> galleryImagePicker() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    } else {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(NoImageSelected),
              ));
    }
  }

  Future<void> galleryImagePickerCover() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageCover = File(pickedImage.path);
      });
    } else {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(NoImageSelected),
              ));
    }
  }

  Future<void> CameraImagePicker() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    } else {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(NoImageSelected),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;

    final width = MediaQuery.sizeOf(context).width * 1;
    String username = widget.username;
    String password = widget.password;

    final currentUser = existingUsers.firstWhere(
        (user) => user.username == username && user.password == password,
        orElse: () => userModel(
            username: " username",
            password: "password",
            profileImagePath: "profileImagePath"));

    _fullName.text = currentUser.name ?? '';
    _username.text = currentUser.username ?? '';
    _password.text = currentUser.password ?? '';
    _address.text = currentUser.address ?? '';
    _education.text = currentUser.education ?? '';

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: widget.isDark ? Colors.white : Colors.black,
        ),
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
      ),
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("EditProfile",
                    style: GoogleFonts.getFont(
                      'Roboto',
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    )),
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: height * .3,
                            child: Stack(children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Color.fromARGB(255, 168, 166, 166),
                                  image: imageCover != null
                                      ? DecorationImage(
                                          image: FileImage(imageCover!),
                                          fit: BoxFit.cover,
                                        )
                                      : DecorationImage(
                                          image: FileImage(File(currentUser
                                              .coverImagePath
                                              .toString())),
                                          fit: BoxFit.cover),
                                ),
                                height: height * .3,
                                width: width * .8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.green,
                                                    width: 2),
                                                color: Colors.amber,
                                                shape: BoxShape.circle),
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundImage: image != null
                                                  ? FileImage(image!)
                                                  : FileImage(File(currentUser
                                                      .profileImagePath
                                                      .toString())),
                                            ),
                                          ),
                                        )),
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: IconButton(
                                            onPressed: () {
                                              galleryImagePickerCover();
                                            },
                                            icon: Icon(Icons.edit))),
                                  ],
                                ),
                              )
                            ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: (() {
                                    galleryImagePicker();
                                  }),
                                  icon: Icon(Icons.photo_sharp),
                                  color: Colors.blue),
                              SizedBox(
                                width: width * .1,
                              ),
                              IconButton(
                                onPressed: (() {
                                  CameraImagePicker();
                                }),
                                icon: Icon(Icons.camera),
                                color: Colors.purple,
                              )
                            ],
                          ),
                          Container(
                            width: width * .7,
                            child: TextFormField(
                              validator: (value) {
                                final isString = value is String;
                                if (!isString) {
                                  return "Cant have numbers in Name";
                                }

                                if (value.length <= 0 || value.isEmpty) {
                                  return "Enter a username";
                                }
                              },
                              controller: _fullName,
                              style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black),
                              decoration: InputDecoration(
                                  hintText: " Full Name",
                                  hintStyle: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black),
                                  labelStyle: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black),
                                  labelText: "Enter your name"),
                            ),
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          Text("Select Gender",
                              style: GoogleFonts.getFont(
                                'Roboto',
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              )),
                          Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Radio(
                                        value: "Male",
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          _gender = value!;
                                        }),
                                    Text("Male",
                                        style: GoogleFonts.getFont(
                                          color: widget.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          'Roboto',
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 1, 7, 12),
                                          ),
                                        )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Radio(
                                        value: "Female",
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          setState(() {
                                            _gender = value!;
                                          });
                                        }),
                                    Text("Female",
                                        style: GoogleFonts.getFont(
                                          color: widget.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          'Roboto',
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 1, 7, 12),
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          Container(
                            width: width * .7,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.length > 10) {
                                  return "Cant have more than 10 letters";
                                }
                                if (value.length <= 0 || value.isEmpty) {
                                  return "Enter a username";
                                }
                              },
                              controller: _address,
                              style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black),
                              decoration: InputDecoration(
                                  hintText: "Address",
                                  hintStyle: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black),
                                  labelStyle: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black),
                                  labelText: "Enter your address"),
                            ),
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          Container(
                            width: width * .7,
                            child: TextFormField(
                              validator: (value) {
                                if (value!.length > 10) {
                                  return "Cant have more than 10 letters";
                                }
                                if (value.length <= 0 || value.isEmpty) {
                                  return "Enter a username";
                                }
                              },
                              controller: _education,
                              style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black),
                              decoration: InputDecoration(
                                  hintText: "Education",
                                  hintStyle: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black),
                                  labelStyle: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black),
                                  labelText: "Education"),
                            ),
                          ),
                          SizedBox(
                            height: height * .02,
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                // ignore: deprecated_member_use
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 207, 90, 223)),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    final userIndex = existingUsers.indexWhere(
                                      (user) =>
                                          user.username == username &&
                                          user.password == password,
                                    );
                                    existingUsers[userIndex].name =
                                        _fullName.text;
                                    existingUsers[userIndex].profileImagePath =
                                        image?.path ??
                                            currentUser.profileImagePath;
                                    existingUsers[userIndex].coverImagePath =
                                        imageCover?.path ??
                                            currentUser.coverImagePath;
                                    existingUsers[userIndex].gender = _gender;
                                    existingUsers[userIndex].education =
                                        _education.text;
                                    existingUsers[userIndex].address =
                                        _address.text;

                                    String encodedJson =
                                        jsonEncode(existingUsers);
                                    SharedPrefService.setString(
                                        key: "sign-up", value: encodedJson);
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor:
                                        Color.fromARGB(255, 8, 250, 60),
                                    content: Text(
                                      "Saved Users",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor:
                                        Color.fromARGB(255, 247, 11, 11),
                                    content: Text(
                                      "Cant Save",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                                }
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
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
