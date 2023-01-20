import 'package:dboy_two/auth/auth_screen.dart';
import 'package:dboy_two/pages/orders/Delivered.dart';
import 'package:dboy_two/pages/orders/allPendingOrders.dart';
import 'package:dboy_two/pages/orders/order_details.dart';
import 'package:dboy_two/pages/orders/reason.dart';
import 'package:dboy_two/pages/orders/verification.dart';
import 'package:dboy_two/pages/ppages/home_page.dart';
import 'package:dboy_two/pages/ppages/login_page.dart';
import 'package:dboy_two/pages/ppages/main_homepage.dart';
import 'package:dboy_two/pages/settings/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: const AuthStateScreen(),
    debugShowCheckedModeBanner: false,
    // initialRoute: '/home_page',
    routes: {
      '/home_page': (context) => const HomePage(),
      '/login_page': (context) => const LoginPage(),
      '/mainpage': (context) => const MainPage(),
      '/pendingOrders_page': (context) => const PendingOrdersPage(),
      '/delivered_page': (context) => const DeliveredPage(),
      '/settings_page': (context) => const SettingsPage(),
      // '/details_page': (context) =>  OrderDetailsPage(),
      '/reason_page': (context) => const ReasonPage(),
      '/verify': (context) => const VerificationPage(),
    },
  ));
}














// void main()   {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(),
//     );
//   }
// }
