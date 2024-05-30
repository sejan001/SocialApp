import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import "dart:convert";

import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';
import 'package:uuid/uuid.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.isDark});
  final bool isDark;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var uuid = Uuid();
  bool _showPass = true;
  bool _showLoader = false;
  String NoImageSelected = "No image selected";
  File? image;
  File? imageCover;
  String _gender = "male";
  List<String> genders = ["male", "female", "others"];
  clear() {
    _username.clear();
    _password.clear();
  }

  showLoader() {
    return Center(
      child: Container(
        height: 30,
        width: 50,
        child: LottieBuilder.network(
            "https://lottie.host/e0444601-f121-4116-b2d9-311b26cdc79f/rsi1KPpVgG.json"),
      ),
    );
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

  Future<void> clearData() async {
    await SharedPrefService.pref!.remove("sign-up");
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;

    final width = MediaQuery.sizeOf(context).width * 1;

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
                Text("SignUp",
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
                                  color:
                                      const Color.fromARGB(255, 221, 220, 220),
                                  image: imageCover != null
                                      ? DecorationImage(
                                          image: FileImage(imageCover!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                height: height * .3,
                                width: width * .8,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Align(
                                        alignment: Alignment.bottomCenter,
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
                                                : null,
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
                                if (value!.length > 10) {
                                  return "Cant have more than 10 letters";
                                }
                                if (value!.length <= 0 || value.isEmpty) {
                                  return "Enter a username";
                                }
                              },
                              style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black),
                              controller: _username,
                              decoration: InputDecoration(
                                  suffix: IconButton(
                                      onPressed: null, icon: Icon(null)),
                                  hintText: " New Username",
                                  hintStyle: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black),
                                  labelStyle: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black),
                                  labelText: "Enter New Username"),
                            ),
                          ),
                          Container(
                            width: width * .7,
                            child: TextFormField(
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
                              style: TextStyle(
                                  color: widget.isDark
                                      ? Colors.white
                                      : Colors.black),
                              decoration: InputDecoration(
                                  suffix: IconButton(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      onPressed: () {
                                        setState(() {
                                          _showPass = !_showPass;
                                          clearData();
                                        });
                                      },
                                      icon: Icon(Icons.remove_red_eye)),
                                  hintText: " New Password",
                                  hintStyle: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black),
                                  labelStyle: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black),
                                  labelText: "Enter New Password"),
                            ),
                          ),
                          // Radio(
                          //     value: genders[0],
                          //     groupValue: _gender,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         _gender = value!;
                          //       });
                          //     }),
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
                                  String name2 = _username.text.toUpperCase();
                                  // SharedPrefService.clearSignUpData();
                                  // SharedPrefService.pref!.remove('sign-up');

                                  userModel user = userModel(
                                      id: uuid.v4(),
                                      username: _username.text,
                                      password: _password.text,
                                      name: name2,
                                      profileImagePath: image!.path,
                                      coverImagePath: imageCover!.path,
                                      gender: "",
                                      education: "",
                                      address: "");
                                  String? existingUsers =
                                      SharedPrefService.getString(
                                          key: 'sign-up');

                                  List<userModel> newUser = [];

                                  if (existingUsers != null &&
                                      existingUsers.isNotEmpty) {
                                    List<dynamic> decodedUsers =
                                        jsonDecode(existingUsers!);
                                    newUser = decodedUsers
                                        .map((jsonUsers) =>
                                            userModel.fromJson(jsonUsers))
                                        .toList();
                                  }
                                  if (newUser.any((user) =>
                                      user.username == _username.text)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "username already  exists")));
                                  } else {
                                    setState(() {
                                      _showLoader = true;
                                                                          newUser.add(user);
                                    String? encodeJson = jsonEncode(newUser
                                        .map((user) => user.toJson())
                                        .toList());
                                    SharedPrefService.setString(
                                      key: "sign-up",
                                      value: encodeJson,
                                    );
                                    

                                    print(encodeJson);
                                    });

                                    Timer(Duration(seconds: 2), () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.blue,
                                              content:
                                                  Text("SignUp Successful")));

                                      Navigator.pop(context);
                                    });

                                    log(existingUsers ?? '');
                                    print(user.username);
                                    print(user.id);
                                    print(user.password);
                                    clear();
                                  }
                                }
                              },
                              child: Text(
                                "Submit",
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
