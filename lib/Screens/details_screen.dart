import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/models/InstructorModel.dart';
import 'package:social_app/models/course_category_model.dart';
import 'package:social_app/models/courses_model.dart';

class DetailsScreen extends StatefulWidget {
  final CourseModel course2;
  final Course course;
  final CourseModel course3;
  final bool isDark;
  DetailsScreen(
      {Key? key,
      required this.course,
      required this.isDark,
      required this.course2,
      required this.course3})
      : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<CourseModel> courses2 = [];
  List<InstructorModel> instructors = [];
  bool isLoading = true;
  bool showMore = false;
  @override
  void initState() {
    load_courses();
    load_instructors();
    super.initState();
  }

  Future<void> load_courses() async {
    try {
      String jsonData =
          await rootBundle.loadString("lib/assets/course_details.json");
      List<dynamic> jsonList = jsonDecode(jsonData);
      List<CourseModel> courseList =
          jsonList.map((e) => CourseModel.fromJson(e)).toList();
      print("list is $jsonList");
      Timer(Duration(seconds: 2), () {});
      setState(() {
        courses2 = courseList;
        isLoading = false;
      });

      print("Courses loaded: $courses2");
    } catch (e) {
      print("Error is $e");
      print("no data");
      setState(() {
        isLoading = true;
      });
    }
  }

  Future<void> load_instructors() async {
    try {
      String jsonData =
          await rootBundle.loadString("lib/assets/instructors.json");
      List<dynamic> jsonList = jsonDecode(jsonData);
      List<InstructorModel> instructorsList =
          jsonList.map((e) => InstructorModel.fromJson(e)).toList();
      print("list is $jsonList");
      Timer(Duration(seconds: 2), () {});
      setState(() {
        instructors = instructorsList;
        isLoading = false;
      });

      print("Instructors : $instructors");
    } catch (e) {
      print("Error is $e");
      print("no Instructors");
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery.sizeOf(context).height * 1);
    double width = (MediaQuery.sizeOf(context).width * 1);
    int courseId = widget.course.id;
    int? course2Id = widget.course2.id;
    int? course3Id = widget.course3.id;

    int? id;
    if (courseId >= 0) {
      setState(() {
        id = courseId;
      });
    } else if (course2Id! >= 0) {
      setState(() {
        id = course2Id;
      });
    } else {
      setState(() {
        id = course3Id;
      });
    }
    bool courseFound = courses2.any((course) => course.id == id);

    if (!courseFound) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Details",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey,
        ),
        body: Center(child: Text("Course not found")),
      );
    }

    CourseModel selectedCourse =
        courses2.firstWhere((course) => course.id == id);
    InstructorModel instructor =
        instructors.firstWhere((instructor) => instructor.id == id);
    final image = instructor.image;

    String instructorId = instructor.id.toString();
    List<String>? field = instructor.field;
    String insField = field!.join(",");
    String WorkExp = instructor.workExperience.toString();
    return Scaffold(
      backgroundColor: widget.isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: widget.isDark ? Colors.black : Colors.white,
        ),
        title: Text(
          "Details",
          style: TextStyle(
              color: widget.isDark ? Colors.black : Colors.white,
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: widget.isDark ? Colors.white : Colors.black,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Card(
                        color: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: height * .3,
                            width: width * 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Title: ${selectedCourse.title}',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 162, 252, 17),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20)),
                                SizedBox(height: 4),
                                Text('Subtitle: ${selectedCourse.subTitle}',
                                    style: TextStyle(
                                        color: widget.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 4),
                                Text(
                                    'Description: ${selectedCourse.description}',
                                    style: TextStyle(
                                        color: widget.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700)),
                                SizedBox(height: 4),
                                Text('Price: \$${selectedCourse.price}',
                                    style: TextStyle(
                                        color: widget.isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * .03,
                        width: width * .03,
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey),
                              height: height * .5,
                              width: width * 1),
                          Positioned(
                            top: 20,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(image!),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: height * .1,
                                ),
                                Text(
                                  "ID :  $instructorId",
                                  style: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "Name: ${instructor.name as String}",
                                  style: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "Field: $insField",
                                  style: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "WorkExperience : $WorkExp",
                                  style: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  "Summary : ${instructor.summary as String}",
                                  style: TextStyle(
                                      color: widget.isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height * .03,
                ),
                Center(
                  child: MaterialButton(
                    color: Colors.deepPurpleAccent,
                    onPressed: (() {
                      setState(() {
                        showMore = !showMore;
                      });
                    }),
                    child: Text("Show More",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
                SizedBox(
                  height: height * .03,
                ),
                Visibility(
                    visible: showMore,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey),
                                        height: height * .4,
                                        width: width * 1),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Syllabus",
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Color.fromARGB(
                                                    255, 162, 252, 17),
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "ID : ${selectedCourse.syllabus![0].id.toString()}",
                                            style: TextStyle(
                                                color: widget.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            selectedCourse.syllabus![0].title
                                                .toString(),
                                            style: TextStyle(
                                                color: widget.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Summary : ${selectedCourse.syllabus![0].summary}"
                                                .toString(),
                                            style: TextStyle(
                                                color: widget.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Total Content : ${selectedCourse.syllabus![0].totalContent.toString()}",
                                            style: TextStyle(
                                                color: widget.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Hours to Be Completed : ${selectedCourse.syllabus![0].hoursToCompleted.toString()}",
                                            style: TextStyle(
                                                color: widget.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * .03,
                          ),
                          Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey),
                                        height: height * .4,
                                        width: width * 1),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "FAQ",
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Color.fromARGB(
                                                    255, 162, 252, 17),
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "ID : ${selectedCourse.fAQ![0].id.toString()}",
                                            style: TextStyle(
                                                color: widget.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            selectedCourse.fAQ![0].title
                                                .toString(),
                                            style: TextStyle(
                                                color: widget.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Summary : ${selectedCourse.fAQ![0].subtitle}"
                                                .toString(),
                                            style: TextStyle(
                                                color: widget.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Total Content : ${selectedCourse.fAQ![0].description.toString()}",
                                            style: TextStyle(
                                                color: widget.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
              ]),
            ),
    );
  }
}
