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
  FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<bool> _onWillPop() async {
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
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
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
                onPressed: () => Navigator.pushNamed(context, '/login_page'),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
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
        backgroundColor: const Color.fromARGB(255, 44, 90, 46),
      ),
      body: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return ListView(padding: const EdgeInsets.all(6), children: [
              imageCard(),
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
          shadowColor: Colors.green,
          elevation: 3,
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
                color: Colors.orange,
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
          shadowColor: Colors.green,
          elevation: 3,
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
                color: Colors.orange,
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
          shadowColor: Colors.green,
          elevation: 3,
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
                _phoneNumber,
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
          shadowColor: Colors.green,
          elevation: 3,
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
          shadowColor: Colors.green,
          elevation: 3,
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
          shadowColor: Colors.green,
          elevation: 3,
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
