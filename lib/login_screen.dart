import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter-secure_storage.dart';
import 'services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>{

  final ApiService _apiService = ApiService();
  final _storage = const flutter_secure_storage();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: const Text('InvestorTrack Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: () async {

                final String email = emailController.text.trim();
                final String password = passwordController.text;
                
                if(email.isEmpty || password.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please Fill All Fields")),
                  );
                  return;
                }
                try{
                  final token
                }
              },
              child: const Text("Login",
                   style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed:(){
                    Navigator.pushNamed(context, '/signup');
              },
              child:
               Column(
                children:[
                  Text("Don't have an account ?"),
                  Text("Sign up",
                   style: TextStyle(fontWeight: FontWeight.bold), 
              ),
              ],
              ),                 
            ),
          ],
        ),
      ),
    );
  }
}
