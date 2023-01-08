import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utk19rsh/constant.dart';
import 'package:utk19rsh/screens/preLogin/splashScreen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    // FirebaseAuth.instance.signOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant',
      theme: ThemeData(
        primaryColor: theme,
        splashColor: theme.withOpacity(0.25),
        highlightColor: theme.withOpacity(0.25),
        scaffoldBackgroundColor: white,
        appBarTheme: const AppBarTheme(
          foregroundColor: grey,
          backgroundColor: theme,
          iconTheme: IconThemeData(
            color: white,
          ),
          titleTextStyle: TextStyle(
            color: black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: theme),
      ),
      home: const SplashScreen(),
    );
  }
}
