import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 187, 243, 187),
      // backgroundImage: AssetImage('assets/dboy.png'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(72.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Container(
                height: 100,
                padding: const EdgeInsets.all(50),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/head.jpg"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 100),
              Container(
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/dboy.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 100),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login_page');
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
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
