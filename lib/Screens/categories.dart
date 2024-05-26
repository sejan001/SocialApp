import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/Screens/details_screen.dart';
import 'package:social_app/models/course_category_model.dart';
import 'package:social_app/models/courses_model.dart';

class CategoriesScreen extends StatefulWidget {
  final String title;
  final bool isDark;
  const CategoriesScreen({
    Key? key,
    required this.isDark,
    required this.title,
  }) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Course> courses = [];

  @override
  void initState() {
    load_courses();
    super.initState();
  }

  Future<void> load_courses() async {
    try {
      String jsonData =
          await rootBundle.loadString("lib/assets/course_categories.json");
      List<dynamic> jsonList = jsonDecode(jsonData);
      List<Course> courseList =
          jsonList.map((e) => Course.fromJson(e)).toList();
      setState(() {
        courses = courseList;
      });
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: widget.isDark ? Colors.black : Colors.white,
          ),
          title: Text(
            widget.title,
            style: TextStyle(
                color: widget.isDark ? Colors.black : Colors.white,
                fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: widget.isDark ? Colors.white : Colors.black,
        ),
        body: ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.isDark ? Colors.white : Colors.black,
                      )),
                  child: ListTile(
                    leading: Icon(Icons.pin_end_sharp),
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                    course: course,
                                    isDark: widget.isDark,
                                    course2: CourseModel(),
                                    course3: CourseModel(),
                                  )));
                    },
                    title: Text(
                      "${course.id}",
                      style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text("${course.title}",
                        style: TextStyle(
                            color: widget.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              );
            }));
  }
}

class TopCourses extends StatefulWidget {
  final bool isDark;
  final String title;
  const TopCourses({super.key, required this.isDark, required this.title});

  @override
  State<TopCourses> createState() => _TopCoursesState();
}

class _TopCoursesState extends State<TopCourses> {
  List<CourseModel> courses = [];

  @override
  void initState() {
    load_courses();
    super.initState();
  }

  Future<void> load_courses() async {
    try {
      String jsonData =
          await rootBundle.loadString("lib/assets/course_details.json");
      List<dynamic> jsonList = jsonDecode(jsonData);
      List<CourseModel> courseList =
          jsonList.map((e) => CourseModel.fromJson(e)).toList();
      setState(() {
        courses = courseList;
      });
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(courses);
    final selectedCourse =
        courses.where((course) => course.isTopCourse == true);
    print("Sejan : $selectedCourse");

    List<CourseModel> topCourse = selectedCourse.toList();

    print(selectedCourse);
    return Scaffold(
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: widget.isDark ? Colors.black : Colors.white,
          ),
          title: Text(
            widget.title,
            style: TextStyle(
                color: widget.isDark ? Colors.black : Colors.white,
                fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: widget.isDark ? Colors.white : Colors.black,
        ),
        body: ListView.builder(
            itemCount: topCourse.length,
            itemBuilder: (context, index) {
              final course = topCourse[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.isDark ? Colors.white : Colors.black,
                      )),
                  child: ListTile(
                    trailing: Icon(Icons.one_k),
                    leading: Icon(Icons.pin_end_sharp),
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                    course: Course(id: -1, title: ""),
                                    isDark: widget.isDark,
                                    course2: course,
                                    course3: CourseModel(id: -1),
                                  )));
                    },
                    title: Text(
                      course.id.toString(),
                      style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(course.title.toString(),
                        style: TextStyle(
                            color: widget.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              );
            }));
  }
}

class PopularCourses extends StatefulWidget {
  final bool isDark;
  final String title;
  const PopularCourses({super.key, required this.isDark, required this.title});

  @override
  State<PopularCourses> createState() => _PopularCoursesState();
}

class _PopularCoursesState extends State<PopularCourses> {
  List<CourseModel> courses = [];

  @override
  void initState() {
    load_courses();
    super.initState();
  }

  Future<void> load_courses() async {
    try {
      String jsonData =
          await rootBundle.loadString("lib/assets/course_details.json");
      List<dynamic> jsonList = jsonDecode(jsonData);
      List<CourseModel> courseList =
          jsonList.map((e) => CourseModel.fromJson(e)).toList();
      setState(() {
        courses = courseList;
      });
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final PopularCourse =
        courses.where((course) => course.isRecentlyViewedCourse == true);

    List<CourseModel> topCourse = PopularCourse.toList();
    return Scaffold(
        backgroundColor: widget.isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: widget.isDark ? Colors.black : Colors.white,
          ),
          title: Text(
            widget.title,
            style: TextStyle(
                color: widget.isDark ? Colors.black : Colors.white,
                fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: widget.isDark ? Colors.white : Colors.black,
        ),
        body: ListView.builder(
            itemCount: PopularCourse.length,
            itemBuilder: (context, index) {
              final course = topCourse[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.isDark ? Colors.white : Colors.black,
                      )),
                  child: ListTile(
                    trailing: Icon(Icons.people),
                    leading: Icon(Icons.pin_end_sharp),
                    iconColor: Colors.green,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                  course: Course(id: -1, title: ""),
                                  isDark: widget.isDark,
                                  course2: CourseModel(id: -1),
                                  course3: course)));
                    },
                    title: Text(
                      course.id.toString(),
                      style: TextStyle(
                          color: widget.isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(course.title.toString(),
                        style: TextStyle(
                            color: widget.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              );
            }));
  }
}
