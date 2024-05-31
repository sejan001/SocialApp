import "dart:async";

import "package:connectivity/connectivity.dart";
import "package:flutter/material.dart";

import "package:google_fonts/google_fonts.dart";
import "package:lottie/lottie.dart";
import "package:social_app/Screens/homeScreen.dart";
import "package:social_app/Screens/login.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isConnected = true;
 
  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectionState.none){
    
    }
    else {
    Timer(Duration(seconds: 3),(){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login(isDark: false,)));
    });
    }
  }
 @override
  void initState() {
    super.initState();
    checkConnectivity();
    
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
        body: isConnected ? Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 245, 240, 240),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 120,
                    height: 60,
                    child: LottieBuilder.network(
                        "https://lottie.host/0d2ed2b8-57aa-43b3-9264-29a35fbd5eac/Fid7h4O9A0.json"),
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Text(
                  "Sej An",
                  style: GoogleFonts.anton(color: Colors.grey),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
              ],
            )) : Center(child: Text('No Internet Connection',style: TextStyle(color: Colors.red),),));
  }
}
