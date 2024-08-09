import 'package:flutter/material.dart';
import 'package:qr_code_reader/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3),
        () {}); // Duración de la pantalla de apertura
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'CODEC',
          style: TextStyle(
            fontFamily: 'Clashdisplay',
            fontSize: 50,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
