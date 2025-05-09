import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plants_app/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plants_app/ui/splash_screen.dart';

void main() async {
  await dotenv.load();
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


