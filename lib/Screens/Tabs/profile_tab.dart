import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_app/Screens/edit_profile.dart';
import 'package:social_app/Screens/upload_post.dart';
import 'package:social_app/models/postModel.dart';

import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';

class ProfileTab extends StatefulWidget {
  final String username;
  final String password;
  final isGuest;
  final isDark;
  ProfileTab({
    Key? key,
    required this.username,
    required this.password,
    this.isDark, this.isGuest,
  }) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  List<userModel> existingUsers = [];
List<PostModel> posts = [];
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
          id: '',
          name: '',
            username: " username",
            password: "password",
            profileImagePath: "profileImagePath",
            coverImagePath: '',
            address: "",
            education: "",
            messages: [],
            posts: [],
            friendList: [],
            friends: [],
            gender: ""),
            );


            posts = currentUser.posts!.toList();

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
                    tooltip: 'Edit Profile',
                      onPressed: () {
                        if (widget.isGuest) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Login first to Edit profile')));


                          
                        }
                        else {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(
                                  updateProfileScreen : (){updateProfile();},
                                    isDark: widget.isDark,
                                    username: currentUser.username,
                                    password: currentUser.password)));

                        }
                      },
                      icon: Icon(Icons.person_2_outlined)),
                  trailing: IconButton(
                    tooltip: 'Upload Posts',
                      onPressed: () {
                        if (widget.isGuest) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Login first to upload posts')));


                          
                        }
                        else{
                           Navigator.push(context, MaterialPageRoute(builder: (context)=> uploadPosts(
                          updateProfile : (){updateProfile();},
                          isDark: widget.isDark,
                             username: currentUser.username,
                                    password: currentUser.password

                        )));
                        }
                       
                      }, icon: Icon(Icons.add_a_photo)),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index){
                  final post = posts.reversed.toList()[index];
                  bool isLiked = post.postLikedBy!= null && post.postLikedBy!.any((user) => user.username == currentUser.username);

return Padding(
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
                    color: widget.isDark ? Colors.black : Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                           CircleAvatar(
                            radius: 23,
                            backgroundImage: FileImage(File(currentUser.profileImagePath.toString())),),
                            SizedBox(width: 4,),
                           Text(post.title.toString(),style: TextStyle(color: widget.isDark ? Colors.white : Colors.black),),
SizedBox(width: width*.56,),
                           IconButton(
                            tooltip: 'Delete this post',
                            onPressed: (){
                            setState(() {
                              currentUser.posts!.remove(post);
                           
                            });
                            SharedPrefService.setString(key: 'sign-up', value: jsonEncode(existingUsers));
                           }, icon: Icon(
                            
                            Icons.delete,color: Colors.red,))
                           
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(image: FileImage(File(post.imageUrl.toString())))
                            
                                
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: isLiked ? IconButton(onPressed: (){
                              setState(() {
                                  post.postLikedBy!.removeWhere((user)=> user.username == currentUser.username);

                              });
SharedPrefService.setString(key: 'sign-up', value: jsonEncode(existingUsers));
                              }, icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.blue,)) : IconButton(onPressed: (){
                                setState(() {
                                   post.postLikedBy??= [];
                                  final postLiked = PostLikedBy(
                                  username: currentUser.username,
                                  dateTime: DateTime.now().toString()
                                

                                );
post.postLikedBy!.add(postLiked);
                                });
SharedPrefService.setString(key: 'sign-up', value: jsonEncode(existingUsers));
                              }, icon: Icon(Icons.thumb_up_alt_outlined,color: widget.isDark ? Colors.white : Colors.black))  ) ,
                              Text(post.postLikedBy != null ? post.postLikedBy!.length.toString() : '0',style: TextStyle(fontWeight: FontWeight.w700,color: widget.isDark ? Colors.white : Colors.black)),
SizedBox(width: width*.03,),
if(post.postLikedBy != null && post.postLikedBy!.length == 1)
Text('liked by ${  post.postLikedBy!.last.username.toString() } ',style: TextStyle(fontWeight: FontWeight.w700,color: widget.isDark ? Colors.white : Colors.black),),

if(post.postLikedBy != null && post.postLikedBy!.length > 1)
Text('liked by ${  post.postLikedBy!.last.username.toString() } and others',style: TextStyle(fontWeight: FontWeight.w700,color: widget.isDark ? Colors.white : Colors.black))
                          ],
                        )

                      
                      ],
                    ),
            
                  ),
                )
            
              ],
            ),
          ),
);
              
              }),
            )
            ],
          ),
        ));
  }
}


