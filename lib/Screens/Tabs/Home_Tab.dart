import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/models/postModel.dart';
import 'package:social_app/models/sharedPrefService';
import 'package:social_app/models/usermodel.dart';
import 'package:flutter/foundation.dart';
class HomeTab extends StatefulWidget {
  final UserName;
  final Pass;
  final bool isDark;
  final isGuest;
  HomeTab({
    super.key,
    this.UserName,
    this.Pass,
    required this.isDark, this.isGuest,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<PostModel> posts = [];
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    print(posts);
    Color buttonColor = Colors.grey;
    List<PostModel> allPosts = existingUsers.expand((user)=> user.posts!).toList();
    List <PostModel> randomPost = List.from(allPosts)..shuffle(Random());
    

    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: randomPost.isEmpty ?  Center(child: Text('No posts'),) : ListView.builder(
          itemCount: allPosts.length,
          itemBuilder: (context, index){
           final post = allPosts.reversed.toList()[index];
           final currentUser = existingUsers.firstWhere((user)=> user.username == widget.UserName && user.password == widget.Pass,
           orElse: () => userModel(
                    username: "",
                    password: "",
                    profileImagePath: ""));
           final postUser = existingUsers.firstWhere((user)=> user.username == post.username,  orElse: () => userModel(
                    username: " ",
                    password: "",
                    profileImagePath: ""));
             bool isLiked = post.postLikedBy!= null && post.postLikedBy!.any((user) => user.username == currentUser.username);
       
           
        print('title is ${post.title}');
        print('ma isss ${currentUser.username}');
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
              color: widget.isDark ? Color.fromARGB(255, 37, 35, 35) : Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                     CircleAvatar(
                      radius: 23,
                      backgroundImage: FileImage(File(postUser.profileImagePath.toString())),),
                      SizedBox(width: 5,),
                    Text('@ ${postUser.username.toString()}',style: TextStyle(color: widget.isDark ? Colors.white : Colors.black,fontWeight: FontWeight.w700,fontSize: 17),),
                     SizedBox(width: 65,),
                     Text(post.createdAt.toString(),style: TextStyle(color: widget.isDark ? Colors.white : Colors.black,fontWeight: FontWeight.w600),),
                     SizedBox.shrink(),
                    ],
                  ),
                   Padding(
                     padding: const EdgeInsets.all(5.0),
                     child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(post.title.toString(),style: TextStyle(color: widget.isDark ? Colors.white : Colors.black,fontWeight: FontWeight.w600),)),
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
        SharedPrefService.setString(key: 'sign-up', value: jsonEncode(existingUsers));
                        });
        
                        }, icon: Icon(Icons.thumb_up_alt_outlined, color: Colors.blue,)) : IconButton(onPressed: (){
                               if (widget.isGuest) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Login first to interact with posts')));


                          
                        }
                          else {
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
        
                        
        Text(post.postLikedBy != null ? post.postLikedBy!.length.toString() : '0',style: TextStyle(fontWeight: FontWeight.w700,color: Colors.blue),),
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
      ),
    );
  }
}
