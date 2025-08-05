import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // like for example take this above code , whatever we are writing in the 'class MyApp extends StatelessWidget' Anything that are in the inside of MyApp class like in this case SignUpScreen we didn't care of that whether it is stateless or statefull We just care of whatever MyApp is which in this is stateless// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvestorTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner : false,
      //home: const SignupScreen(),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard':(context) => const DashboardScreen(),
      },
    );
  }
}
