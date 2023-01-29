import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  // Future getImage() async {
  //   // ignore: deprecated_member_use
  //   final image = await imagePicker.getImage(source: ImageSource.camera);
  //   setState(() {
  //     _image = File(image!.path);
  //   });
  // }

  // Future<bool> _onWillPop() async {
  //   return (await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Are you sure?'),
  //           content: const Text('Do you want to Exit?'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(false),
  //               child: const Text('No'),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(true),
  //               child: const Text('Yes'),
  //             ),
  //           ],
  //         ),
  //       )) ??
  //       false;
  // }

  @override
  void initState() {
    super.initState();
  }

  void pickImageFromGallery() async {
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgXFile;
    });
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
      body: ListView(padding: const EdgeInsets.all(6), children: [
        imageCard(),
        nameCard(),
        phoneCard(),
        dateCard(),
        logoutCard(),
      ]),
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
              backgroundImage:
                  imgXFile == null ? null : FileImage(File(imgXFile!.path)),
              // child: imgXFile == null
              //     ? const Icon(
              //         Icons.camera_alt,
              //         size: 40,
              //       )
              //     : null,
            ),
            const SizedBox(height: 5),
            const Icon(Icons.camera_alt),
            GestureDetector(
              onTap: () {
                pickImageFromGallery();
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
            child:  const ListTile(
              leading:  Icon(
                Icons.person,
                color: Colors.orange,
              ),
              title: Text(
                'name',
                style:  TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              subtitle:  Text(
                'their email',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
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
            child: const ListTile(
              leading: Icon(
                Icons.phone,
                color: Colors.purple,
              ),
              title: Text(
                'Phone Number',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '0977797876',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
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
            child: const ListTile(
              leading: Icon(
                Icons.phone,
                color: Colors.purple,
              ),
              title: Text(
                'Joined Date',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      );

  Widget logoutCard() => Card(
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
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/home_page');
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
      );
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
