import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utk19rsh/screens/landing/cartProvider.dart';
import 'package:utk19rsh/screens/landing/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => ChangeNotifierProvider(
            create: (context) => CartProvider(),
            child: const Home(),
          ),
        ),
      ),
    );
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/gifs/loader.gif",
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.9,
        ),
      ),
    );
  }
}
