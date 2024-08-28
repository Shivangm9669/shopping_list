import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list/screen/listscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Grocery List",
        theme: ThemeData(
            useMaterial3: false,
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue[100],
                foregroundColor: Colors.black87),
            primaryColor: const Color.fromARGB(255, 127, 192, 244),
            primaryColorDark: const Color.fromARGB(255, 229, 226, 226),
            scaffoldBackgroundColor: const Color.fromARGB(255, 247, 233, 233),
            textTheme: TextTheme(
              titleLarge: GoogleFonts.oswald(
                fontSize: 21,
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.blue[100],
                foregroundColor: Colors.black87),
                ),
        home: const UserScreen());
  }
}
