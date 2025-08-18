import 'package:flutter/material.dart';

// Define our custom colors
const Color primaryColor = Color(0xFF4CAF50); 
const Color lightGrayColor = Color(0xFFEDF7ED);
const Color darkTextColor = Color(0xFF333333);
const Color lightTextColor = Color(0xFF424242);

// Define the main app theme
final ThemeData appTheme = ThemeData(
  useMaterial3: true,

  // Color Scheme
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
  ),

  // Scaffold Background Color
  scaffoldBackgroundColor: lightGrayColor,

  // AppBar Theme
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: darkTextColor, // For title and icons
  ),

  // Card Theme
  cardTheme: CardThemeData(
    elevation: 2.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    color: Colors.white,
  ),

  // Text Theme
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: darkTextColor),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: darkTextColor),
    bodyLarge: TextStyle(fontSize: 16.0, color: darkTextColor),
    bodyMedium: TextStyle(fontSize: 14.0, color: lightTextColor),
  ),
);