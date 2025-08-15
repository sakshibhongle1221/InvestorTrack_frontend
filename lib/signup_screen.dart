import 'package:flutter/material.dart';
import 'services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final ApiService _apiService = ApiService();
  //final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    //nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InvestorTrack - Sign Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //TextField(
            //  controller: nameController,
            //  decoration: const InputDecoration(labelText: 'Full Name'),
           // ),
          //  const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
              //  final String name = nameController.text.trim();
                final String email = emailController.text.trim();
                final String password = passwordController.text;
                final String confirmPassword = confirmPasswordController.text;

                if( email.isEmpty || password.isEmpty || confirmPassword.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content:Text("Please Fill All The Fields")),
                  );
                  return;
                }

                if(!email.contains('@') || !email.contains('.')){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content:Text("Please Enter A Valid Email Address")),
                  );
                  return;
                }

                if(password != confirmPassword){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password Do Not Match")),
                  );
                  return;
                }

                try{
                  final response = await _apiService.registerUser(email,password);

                  if(mounted){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Signup Successful!! ")),
                    );
                    Navigator.pop(context);
                  }
                }
                catch(e){
                  if(mounted){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content:Text('Failed To Register:$e')),
                    );
                  }
                }
                print('Register Clicked');
                //print('Name: $name');
                print('Email: $email');
                print('Password: $password');
                print('Confirm Password: $confirmPassword');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}