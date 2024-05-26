// import "dart:async";

// import "package:flutter/material.dart";

// import "package:google_fonts/google_fonts.dart";
// import "package:lottie/lottie.dart";
// import "package:social_app/Screens/homeScreen.dart";

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 4), () {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => HomeScreen()));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.sizeOf(context).height * 1;

//     return Scaffold(
//         body: Container(
//             decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 245, 240, 240),
//                 image: DecorationImage(
//                     image: NetworkImage(""), fit: BoxFit.cover)),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Center(
//                   child: Container(
//                     width: 120,
//                     height: 60,
//                     child: LottieBuilder.network(
//                         "https://lottie.host/0d2ed2b8-57aa-43b3-9264-29a35fbd5eac/Fid7h4O9A0.json"),
//                   ),
//                 ),
//                 SizedBox(
//                   height: height * 0.04,
//                 ),
//                 Text(
//                   "Sej An",
//                   style: GoogleFonts.anton(color: Colors.grey),
//                 ),
//                 SizedBox(
//                   height: height * 0.04,
//                 ),
//               ],
//             )));
//   }
// }
