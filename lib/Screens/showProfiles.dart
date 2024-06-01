import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/friendListModel.dart';
import 'package:social_app/models/postModel.dart';

import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';

class Showprofiles extends StatefulWidget {
  final friendUsername;
  final friendPassword;
  final isGuest;


  final isDark;
  final currentUsername;
  final currentPassword;
  final targetUser;
  Showprofiles({
    Key? key,
   
    this.isDark,
    this.targetUser,
    this.currentUsername,
    this.currentPassword, this.friendUsername, this.friendPassword, this.isGuest,
 
  }) : super(key: key);

  @override
  State<Showprofiles> createState() => _ShowprofilesState();
}

class _ShowprofilesState extends State<Showprofiles> {
  List<userModel> existingUsers = [];
  List<FriendModel> friends = [];
  List<PostModel> posts = [];

  Future<void> loadUsers() async {
    try {
      String? json = SharedPrefService.getString(key: "sign-up");
      if (json != null && json.isNotEmpty) {
        try {
          List<dynamic> jsonUsers = jsonDecode(json);
          existingUsers =
              jsonUsers.map((user) => userModel.fromJson(user)).toList();
        } on FormatException {
          print("Invalid JSON string: $json");
        }
      }
    } catch (e) {
      print("error is $e");
    }
  }

  @override
  void initState() {
    loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String username = widget.friendUsername;
    String password = widget.friendPassword;
    DateTime now = DateTime.now();
    String dateFormate = DateFormat("yyyy-MM-dd").format(now);
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    final currentUser = existingUsers.firstWhere(
        (user) =>
            user.username == widget.currentUsername &&
            user.password == widget.currentPassword,
         orElse: () => userModel(
          id: '',
          name: '',
            username: " username",
            password: "password",
            profileImagePath: "",
            coverImagePath: '',
            address: "",
            education: "",
            messages: [],
            posts: [],
            friendList: [],
            friends: [],
            gender: ""),);
    final friendUser = existingUsers.firstWhere(
        (user) => user.username == username && user.password == password,
 orElse: () => userModel(
          id: '',
          name: '',
            username: " username",
            password: "password",
            profileImagePath: "",
            coverImagePath: '',
            address: "",
            education: "",
            messages: [],
            posts: [],
            friendList: [],
            friends: [],
            gender: ""),);

    String ppPath = friendUser.profileImagePath.toString();
     posts = friendUser.posts!.toList();

    sendRequest(userModel currentUser, userModel targetUser) {
      final newFriendReq = FriendModel(
          username: currentUser.username.toString(),
          friendUsername: friendUser.username.toString(),
          requestedByUsername: currentUser.username.toString(),
          createdAt: now,
          hasNewRequest: true,
          hasNewRequestAccepted: false,
          hasRemoved: false);
      setState(() {
        friendUser.friendList!.add(newFriendReq);
        SharedPrefService.setString(
            key: "sign-up", value: jsonEncode(existingUsers));
      });

      print("saathi is ${friendUser.username}");
      print("ma is ${currentUser.username}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("Sent Request")));
    }
    currentUser.friends = currentUser.friends ?? [];
friendUser.friends = friendUser.friends ?? [];
bool isFriend = (friendUser.friends != null && (friendUser.friends!.contains(currentUser.username!.toUpperCase()) || friendUser.friends!.contains(username.toUpperCase())));
bool sent = true;

    return Scaffold(
        appBar: AppBar(backgroundColor: widget.isDark? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: widget.isDark? Colors.white : Colors.black),),
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
                              File(friendUser.coverImagePath.toString())),
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
                              File(friendUser.profileImagePath.toString()))),
                    ),
                  ),
                ),
              ]),
              Text(
                "Name : ${friendUser.name}",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Gender: ${friendUser.gender} ",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Address: ${friendUser.address}",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Education: ${friendUser.education} ",
                style: TextStyle(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: height * .01,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 210, 219, 219),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  leading: isFriend
                      ? Icon((Icons.person), color: Colors.green)
                      : IconButton(
                    tooltip: 'Add Friend',

                          onPressed: () {
                            if (widget.isGuest) {
                               ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Login to add friends"),
                          ));
                              
                            }

                            else{
                               sendRequest(currentUser, friendUser);

                            }

                           
                          },
                          icon:  Icon(Icons.person_add)),
                  trailing: IconButton(
                    tooltip: 'Unfriend',
                      onPressed: () {
                        if(!isFriend){
                           ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Add friend First"),
                          ));

                        } else { setState(() {
                          print(isFriend);
                          currentUser.friends = currentUser.friends ?? [];
                          currentUser.friends!.remove(friendUser.username!.toUpperCase());
                          friendUser.friends!.remove(currentUser.username!.toUpperCase());
                          SharedPrefService.setString(
                            key: "sign-up",
                            value: jsonEncode(existingUsers),
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Removed Friend"),
                          ),
                        );


                        }
                       
                      },
                      icon: Icon(Icons.person_off)),
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                           CircleAvatar(
                            radius: 23,
                            backgroundImage: FileImage(File(friendUser.profileImagePath.toString())),),
                            SizedBox(width: 4,),
                           Text(post.title.toString()),
                           
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

                              }, icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.blue,)) : IconButton(onPressed: (){
                                if (widget.isGuest) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Login first to upload posts')));


                          
                        } else {
                          setState(() {
                                   post.postLikedBy??= [];
                                  final postLiked = PostLikedBy(
                                  username: currentUser.username,
                                  dateTime: DateTime.now().toString()
                                


                                  
                                );
post.postLikedBy!.add(postLiked);
                                });
SharedPrefService.setString(key: 'sign-up', value: jsonEncode(existingUsers));
                        }
                                
                              }, icon: Icon(Icons.thumb_up_alt_outlined))  ) ,

                              
Text(post.postLikedBy != null ? post.postLikedBy!.length.toString() : '0'),
SizedBox(width: width*.03,),
if(post.postLikedBy != null && post.postLikedBy!.length == 1)
Text('liked by ${  post.postLikedBy!.last.username.toString() } ',style: TextStyle(fontWeight: FontWeight.w700),),

if(post.postLikedBy != null && post.postLikedBy!.length > 1)
Text('liked by ${  post.postLikedBy!.last.username.toString() } and others',style: TextStyle(fontWeight: FontWeight.w700))
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
        )
            ,
          )
        ;
  }
}
