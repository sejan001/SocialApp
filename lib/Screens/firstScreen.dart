import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late ConnectivityResult result;
  late Connectivity connectivity;

  @override
  void initState() {
    super.initState();
    connectivity = Connectivity();
    _checkNet();
  }

  Future<void> _checkNet() async {
    try {
      result = await connectivity.checkConnectivity();
    } catch (e) {
      print(e);
      result = ConnectivityResult.none;
    }
    setState(() {
      connectivityResult = _getResultString(result);
    });
  }

  String _getResultString(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'Connected to WiFi';
      case ConnectivityResult.mobile:
        return 'Connected to Mobile Data';
      case ConnectivityResult.none:
        return 'No Internet Connection';
      default:
        return 'Unknown';
    }
  }

  String? connectivityResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          connectivityResult ?? 'Checking Connectivity...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
