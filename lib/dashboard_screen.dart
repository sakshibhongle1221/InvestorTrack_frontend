import 'package:flutter/material.dart';

class DashboardScreen extends statelessWidget{
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        centerTitle: true,
      //automaticallyImplyLeading: false,  
      ),
      body: const Center(
        child: Text(
          'Welcome!! You Are Logged In :)',
          style: TextStyle(fontSize:24),
        ),
      ),
    );
  }
}