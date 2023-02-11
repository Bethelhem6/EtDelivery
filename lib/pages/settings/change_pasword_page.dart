// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, empty_catches, unused_field

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  var newPassword = "";
  final newPasswordContrller = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  late File image;
  late String imgUrl;
  @override
  void dispose() {
    newPasswordContrller.dispose();
    super.dispose();
  }

  changePassword() async {
    try {
      await currentUser!.updatePassword(newPassword);
      // FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => Login()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black26,
        content: Text("Your Password has Changed Successfully! "),
      ));
    } catch (error) {}
  }

  late PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // imageProfile(),
              // SizedBox(height: 10,),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.70,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Change Password",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              autofocus: false,
                              obscureText: true,
                              decoration: InputDecoration(
                                label: Text("New password"),
                                hintText: "enter new password",
                                labelStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(),
                                errorStyle: TextStyle(
                                    color: Colors.red, fontSize: 15.0),
                              ),
                              controller: newPasswordContrller,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "please enter password";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          // ignore: deprecated_member_use
                          MaterialButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  newPassword = newPasswordContrller.text;
                                });
                                changePassword();
                              }
                            },
                            color: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Update",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






















































































































// // ignore_for_file: no_leading_underscores_for_local_identifiers

// import 'package:flutter/material.dart';

// class ChangePassword extends StatefulWidget {
//   const ChangePassword({Key? key}) : super(key: key);

//   @override
//   State<ChangePassword> createState() => _ChangePasswordState();
// }

// class _ChangePasswordState extends State<ChangePassword> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: const Icon(Icons.arrow_back_ios)),
//         title: const Text(
//           "Change Password",
//           style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 1,
//       ),
//       body: Form(
//         child: Container(
//           margin: const EdgeInsets.all(30),
//           height: MediaQuery.of(context).size.height * 0.40,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               password(),
//               const SizedBox(
//                 height: 10,
//               ),
//               newPassword(),
//               const SizedBox(
//                 height: 10,
//               ),
//               confirm(),
//               const SizedBox(
//                 height: 10,
//               ),
//               changePassword(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget password() {
//     return TextFormField(
//       obscureText: true,
//       decoration: InputDecoration(
//           labelStyle: const TextStyle(
//               fontSize: 25, fontWeight: FontWeight.normal, color: Colors.black),
//           labelText: "Password",
//           hintText: "Enter old password",
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//           )),
//     );
//   }

//   Widget newPassword() {
//     return TextFormField(
//       obscureText: true,
//       decoration: InputDecoration(
//           labelStyle: const TextStyle(
//               fontSize: 25, fontWeight: FontWeight.normal, color: Colors.black),
//           labelText: "New password",
//           hintText: "Enter new password",
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//           )),
//     );
//   }

//   Widget confirm() {
//     return TextFormField(
//       obscureText: true,
//       decoration: InputDecoration(
//           labelStyle: const TextStyle(
//               fontSize: 25, fontWeight: FontWeight.normal, color: Colors.black),
//           labelText: "Confirm password",
//           hintText: "Re-enter new password",
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//           )),
//     );
//   }

//   Widget changePassword(BuildContext _context) {
//     return Container(
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//         decoration: BoxDecoration(
//             color: Colors.green, borderRadius: BorderRadius.circular(100)),
//         child: MaterialButton(
//           onPressed: () {
//             // Navigator.pushNamed(context, '/cart');
//           },
//           child: const Center(
//             child: Text(" Change ",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w800,
//                 ),
//                 textAlign: TextAlign.center),
//           ),
//         ));
//   }
// }
