import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utk19rsh/screens/landing/cartProvider.dart';
import 'package:utk19rsh/screens/landing/home.dart';

class PostSubmit extends StatelessWidget {
  const PostSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (builder) => ChangeNotifierProvider(
              create: (context) => CartProvider(),
              child: const Home(),
            ),
          ),
          (route) => false),
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/gifs/success.gif",
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.9,
            ),
            const SizedBox(height: 20),
            const Text(
              "You will now be redirected to home page",
              style: TextStyle(
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
