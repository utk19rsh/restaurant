import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:utk19rsh/app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
