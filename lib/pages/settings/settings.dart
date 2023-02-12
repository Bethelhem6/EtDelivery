// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image_picker/image_picker.dart';

import 'change_pasword_page.dart';
// import 'reset_password.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  XFile? imgXFile;
  var _url;
  String _uid = "";
  String _phoneNumber = "";
  String _name = "";
  String _email = "";
  String _joinedDate = "";
  File? _image;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ImagePicker imagePicker = ImagePicker();

  void _getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;

    final DocumentSnapshot userDocs = await FirebaseFirestore.instance
        .collection("delivery person")
        .doc(_uid)
        .get();
    setState(() {
      _phoneNumber = userDocs.get('phoneNumber').toString();
      _name = userDocs.get('name');
      _email = userDocs.get('email');
      _url = userDocs.get("imageUrl");
      _joinedDate = userDocs.get("joinedDate");
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
    });
    final ref =
        FirebaseStorage.instance.ref().child('adminImage').child('$_name.jpg');

    await ref.putFile(_image!);
    _url = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection("delivery person")
        .doc(_uid)
        .update({
      "imageUrl": _url,
    });
    setState(() {});
  }

  void _update(name, phoneNumber) async {
    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection("delivery person")
        .doc(_uid)
        .update({
      "name": name,
      "phoneNumber": phoneNumber,
    });
    setState(() {
      _phoneNumber = phoneNumber;
      _name = name;
      isLoading = false;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(
        milliseconds: 200,
      ),
      backgroundColor: Colors.black26,
      content: Text(
        "Updated successfully",
      ),
    ));
  }

  logoutMessage() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to Logout?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushNamed(context, '/login_page');
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Color primaryColor = const Color(0xff18203d);
  Color secondaryColor = const Color(0xff232c51);
  Color logoGreen = const Color(0xff25bcbb);

  CollectionReference ref =
      FirebaseFirestore.instance.collection('delivery person');

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  final bool _isLoading = false;

  _builtTextField(TextEditingController controller, String labelText) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 223, 201, 201),
          // border: Border.all(color: Colors.green)
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              labelText: labelText,
              labelStyle: const TextStyle(color: Colors.black),
              border: InputBorder.none),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
                centerTitle: true,elevation: 0,

        backgroundColor: const Color.fromARGB(255, 44, 90, 46),
      ),
      body: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return ListView(padding: const EdgeInsets.all(6), children: [
              imageCard(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            _builtTextField(
                                                nameController, "Name"),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            _builtTextField(numberController,
                                                'Phone Number'),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                print("calling");
                                                _update(
                                                    nameController.value.text ==
                                                            ""
                                                        ? _name
                                                        : nameController
                                                            .value.text,
                                                    numberController
                                                                .value.text ==
                                                            ""
                                                        ? _name
                                                        : numberController
                                                            .value.text);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25.0),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 108, 155, 109),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Center(
                                                    child: isLoading
                                                        ? const CircularProgressIndicator(
                                                            color: Colors.white,
                                                          )
                                                        : const Text(
                                                            'Update',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                        child: const Icon(Icons.edit)),
                  ],
                ),
              ),
              nameCard(),
              emailCard(),
              phoneCard(),
              dateCard(),
              changePassword(),
              logoutCard(),
            ]);
          }),
    );
  }

//there's something to add!!

  Widget imageCard() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color.fromARGB(255, 207, 206, 206),
              backgroundImage: _url == null ? null : NetworkImage(_url!),
            ),
            const SizedBox(height: 5),
            const Icon(Icons.camera_alt),
            GestureDetector(
              onTap: () {
                _getImage();
              },
              child: const Text(
                'Change photo',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget nameCard() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Card(
          shadowColor: const Color.fromARGB(255, 50, 190, 55),
          elevation: 6,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(26, 15, 15, 15),
                  Color.fromARGB(26, 15, 15, 15),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: const Text(
                'Name',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                _name,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      );

  Widget emailCard() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
        child: Card(
          shadowColor: const Color.fromARGB(255, 50, 190, 55),
          elevation: 6,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(26, 15, 15, 15),
                  Color.fromARGB(26, 15, 15, 15),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(
                Icons.email_outlined,
                color: Colors.black,
              ),
              title: const Text(
                'Email',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                _email,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      );

  Widget phoneCard() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
        child: Card(
          shadowColor: const Color.fromARGB(255, 50, 190, 55),
          elevation: 6,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(26, 15, 15, 15),
                  Color.fromARGB(26, 15, 15, 15),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(
                Icons.phone,
                color: Colors.black,
              ),
              // suffixIcon: Icon(Icons.edit),
              title: const Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                "+251-$_phoneNumber",
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      );

  Widget dateCard() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Card(
          shadowColor: const Color.fromARGB(255, 50, 190, 55),
          elevation: 6,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(26, 15, 15, 15),
                  Color.fromARGB(26, 15, 15, 15),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
              border: const Border(
                top: BorderSide(color: Color(0xFFFFFFFF)),
                left: BorderSide(color: Color(0xFFFFFFFF)),
                right: BorderSide(color: Color(0xFFFFFFFF)),
                bottom: BorderSide(color: Color(0xFFFFFFFF)),
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(
                Icons.date_range_outlined,
                color: Colors.black,
              ),
              title: const Text(
                'Joined Date',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                _joinedDate,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      );

  Widget changePassword() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Card(
          shadowColor: const Color.fromARGB(255, 50, 190, 55),
          elevation: 6,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(26, 15, 15, 15),
                  Color.fromARGB(26, 15, 15, 15),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const ChangePassword())));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.question_mark_rounded,
                  color: Colors.blue,
                ),
                title: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget logoutCard() => Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Card(
          shadowColor: const Color.fromARGB(255, 50, 190, 55),
          elevation: 6,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(26, 15, 15, 15),
                  Color.fromARGB(26, 196, 46, 46),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: ListTile(
              onTap: () {
                logoutMessage();
              },
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );

  // Widget logoutCard() => WillPopScope(
  //       onWillPop: _onWillPop,
  // padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
  //   child: Card(
  //     shadowColor: Colors.green,
  //     elevation: 3,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         gradient: const LinearGradient(
  //           colors: [
  //             Color.fromARGB(26, 15, 15, 15),
  //             Color.fromARGB(26, 15, 15, 15),
  //           ],
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //         ),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       padding: const EdgeInsets.all(8),
  //       child: ListTile(
  //         onTap: () async {
  //           await FirebaseAuth.instance.signOut();
  //           // ignore: use_build_context_synchronously
  //           Navigator.pushReplacementNamed(context, '/home_page');
  //         },
  //         leading: const Icon(
  //           Icons.logout,
  //           color: Colors.red,
  //         ),
  //         title: const Text(
  //           'Logout',
  //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //     ),
  //   ),
  // );
}




// Center(
      //     child: _image == null
      //         ? const Text('No image Selected')
      //         : Image.file(_image)),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: getImage,
      //   backgroundColor: Colors.blue,
      //   child: const Icon(Icons.camera_alt),
      // ),
    
    
    //  CircleAvatar(
    //   child: Container(
    //     height: 200,
    //     padding: const EdgeInsets.all(60),
    //     decoration: const BoxDecoration(
    //         // image: DecorationImage(
    //         // image: AssetImage("assets/dboy.png"),
    //         // fit: BoxFit.contain,
    //         ),
    //   ),
    // );
    // // );
