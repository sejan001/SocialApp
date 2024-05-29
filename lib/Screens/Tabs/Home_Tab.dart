import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/models/postModel.dart';

class HomeTab extends StatefulWidget {
  final UserName;
  final Pass;
  final bool isDark;
  HomeTab({
    super.key,
    this.UserName,
    this.Pass,
    required this.isDark,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List<PostModel> posts = [];

  @override
  void initState() {
    loadPosts();

    super.initState();
  }

  Future<void> loadPosts() async {
    try {
      String json = await rootBundle.loadString("lib/assets/post_details.json");
      List<dynamic> jsonList = jsonDecode(json);
      List<PostModel> Posts =
          jsonList.map((Posts) => PostModel.fromJson(Posts)).toList();
      print(Posts.first);
      setState(() {
        posts = Posts;
      });
    } catch (e) {
      print("Error is $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 1;
    double width = MediaQuery.sizeOf(context).width * 1;
    print(posts);
    Color buttonColor = Colors.grey;

    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // child: Center(
        //   child: ListView.builder(
        //       itemCount: posts.length,
        //       itemBuilder: (BuildContext context, index) {
        //         final post = posts[index];
        //         return Padding(
        //           padding: const EdgeInsets.all(10.0),
        //           child: Container(
        //             decoration: BoxDecoration(
        //                 border: Border.all(
        //                     width: 3,
        //                     color: widget.isDark ? Colors.white : Colors.black),
        //                 borderRadius: BorderRadius.circular(20)),
        //             child: Stack(
        //               children: [
        //                 Container(
        //                   height: height * .40,
        //                   width: width * 1,
        //                   child: Card(
        //                       child: Column(children: [
        //                     SizedBox(
        //                       height: 10,
        //                     ),
        //                     Expanded(
        //                         child: ListView.builder(
        //                             scrollDirection: Axis.horizontal,
        //                             itemCount: post.image!.length,
        //                             itemBuilder: (context, index) {
        //                               final image = post.image![index];
        //                               return Container(
        //                                 child: Row(
        //                                   children: [
        //                                     Align(
        //                                       alignment: Alignment.topCenter,
        //                                       child: Container(
        //                                         height: height * .30,
        //                                         width: width * .9,
        //                                         decoration: BoxDecoration(
        //                                             image: DecorationImage(
        //                                                 image: NetworkImage(post
        //                                                     .image![index]
        //                                                     .toString()),
        //                                                 fit: BoxFit.cover)),
        //                                       ),
        //                                     ),
        //                                     SizedBox(
        //                                       width: 10,
        //                                     )
        //                                   ],
        //                                 ),
        //                               );
        //                             })),
        //                     Container(
        //                         decoration: BoxDecoration(
        //                           borderRadius: BorderRadius.only(
        //                               bottomLeft: Radius.circular(10),
        //                               bottomRight: Radius.circular(10)),
        //                           color: widget.isDark
        //                               ? Colors.black
        //                               : Colors.white,
        //                         ),
        //                         child: ListTile(
        //                           leading: IconButton(
        //                               color: buttonColor,
        //                               onPressed: () {
        //                                 setState(() {
        //                                   buttonColor = Colors.blue;
        //                                 });
        //                               },
        //                               icon: Icon(
        //                                 Icons.thumb_up,
        //                                 color: widget.isDark
        //                                     ? Colors.white
        //                                     : Colors.black,
        //                               )),
        //                           trailing: Text(
        //                             post.createdAt.toString(),
        //                             style: TextStyle(
        //                                 color: widget.isDark
        //                                     ? Colors.white
        //                                     : Colors.black),
        //                           ),
        //                         )),
        //                   ])),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         );
        //       }),
        // ),
      ),
    );
  }
}
