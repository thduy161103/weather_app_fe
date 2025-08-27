import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Dashboard',
      theme: ThemeData(
        primaryColor: const Color(0xFF4A6CF7),
        textTheme: GoogleFonts.rubikTextTheme(),
      ),
      home: DashboardScreen(),
    );
  }
}
