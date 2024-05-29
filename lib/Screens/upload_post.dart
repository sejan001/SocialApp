import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/postModel.dart';
import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';
import 'package:uuid/uuid.dart';


class uploadPosts extends StatefulWidget {
  final  username;
  final password;
final VoidCallback updateProfile;
  const uploadPosts({super.key, this.username, this.password, required this.updateProfile});

  @override
  State<uploadPosts> createState() => _uploadPostsState();
}

class _uploadPostsState extends State<uploadPosts> {
  TextEditingController _postTitle = TextEditingController();
  File? image; 
List<userModel> existingUsers = [];
var uuid = Uuid();
Future<void> loadUsers ()async{
  String? json = SharedPrefService.getString(key: 'sign-up');
  if (json != null) {
    List<dynamic> loadJson = jsonDecode(json);
    existingUsers = loadJson.map((user) => userModel.fromJson(user)).toList();
    
  }
}

  Future<void> imagePick() async {
     final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
      print('select vayo');
    } 
  }

  @override
  void initState() {
loadUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height *1;
      double width= MediaQuery.sizeOf(context).width *1;
      bool imageSelected = image != null;

      final currentUser = existingUsers.firstWhere(
        (user) => user.username == widget.username && user.password == widget.password,
        orElse: () => userModel(
            username: " username",
            password: "password",
            profileImagePath: "profileImagePath"));
            print('ma is $currentUser');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: height*.5,
                width: width *1,
                decoration: BoxDecoration(
                  border: Border.all(),
                 borderRadius: BorderRadius.circular(20)
                ),
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                         CircleAvatar(
                          radius: 23,
                          backgroundImage: FileImage(File(currentUser.profileImagePath.toString())),),
                          SizedBox(width: 4,),
                          Container(
                            width: width *.65,
                            child: TextField(
                              controller: _postTitle,
                              decoration: InputDecoration(
                                hintText: 'Enter Post Title'
                              ),
                            
                            ),
                            
                          ),
                          IconButton(onPressed: (){
                            imagePick();
                          }, icon:Icon(Icons.image))
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: image != null
                                  ? DecorationImage(
                                      image: FileImage(image!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                          
                              
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          
                        if (image!= null) {
  setState(() {
          final post = PostModel(
          postId: uuid.v4(),
          title: _postTitle.text,
          username: currentUser.username,
          imageUrl: image!.path, 
          createdAt: DateTime.now().toString(),
        );
        currentUser.posts!.add(post);
        widget.updateProfile();
  });
        SharedPrefService.setString(key: 'sign-up', value: jsonEncode(existingUsers));
        print('naya post ${currentUser.posts}');
        
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Posted")));
      } else {
    
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select an image before posting")));
      }
                         
                        }, child: Text('Post',style: TextStyle(fontWeight: FontWeight.bold),)),
                      )
                    ],
                  ),
          
                ),
              )
          
            ],
          ),
        ),
      ),
    );
  }
}
