import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../global_method.dart';
import '../forgotpasswordpage.dart';
// import '../pages/forgotpasswordpage.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;

  bool _isVisible = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();

  String _email = '';
  String _password = '';
  String _uid = '';

  void _submitData() async {
    final _isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();

      try {
        final newUser = await _auth.signInWithEmailAndPassword(
            email: _email.toLowerCase().trim(),
            password: _password.toLowerCase().trim());
        Navigator.pushNamed(context, '/mainpage');
        // if (newUser != null) {
        //   User? user = _auth.currentUser;
        //   _uid = user!.uid;
        //   final DocumentSnapshot result = await FirebaseFirestore.instance
        //       .collection('users')
        //       .doc(_uid)
        //       .get()

        // String role = result.get('role');
        // if (role == 'customer') {
        //   Navigator.pop(context);
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) =>const HomeHeader()),
        // );
        // }
        // else {
        //   if (mounted) {
        //     _globalMethods.showDialogues(
        //         context, 'It is not customer account.');
        //   }
        // }
        // }
        // print("logged in");
      } catch (e) {
        if (mounted) {
          _globalMethods.showDialogues(context, e.toString());
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Welcome!!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        backgroundColor: const Color.fromARGB(255, 210, 243, 205),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                    child: Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/logo.jpg'),
                        radius: 95.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        onChanged: (value) {
                          _email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
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
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      onChanged: (value) {
                        _password = value;
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.green),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          child: Icon(obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        hintText: 'Password',
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      obscureText: obscureText,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ForgotPassPage();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'forget passsword?',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  GestureDetector(
                    onTap: _submitData,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Sign in',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ));
  }
}
