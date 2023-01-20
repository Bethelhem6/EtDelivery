import 'package:flutter/material.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Future passwordReset() sync {
  //   try{
  //     await FirebaseAuth.instance.sendPasswordResetEmail(email:_emailController.text.trim());

  //  showDialog(
  //   context:context,
  //   builder:(context){
  //     return AlertDialog(
  //       content: Text('Password reset link sent! Check your email'),
  //     );
  //   },
  //  );
  // } on FirebaseAuthException catch {e} {
  //   print(e);
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Password Reset"),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 100, 0, 0),
                child: Text(
                  'Enter your Email and we wil send you a password reset link.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.green),
                    ),

                    prefixIcon: const Icon(Icons.email),
                    hintText: 'E-mail',
                    // icon: const Icon(Icons.email),
                    // icon: const Icon(Icons.password),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: () {},
                color: Colors.lightGreen,
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
