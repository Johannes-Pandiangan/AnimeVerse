import 'package:flutter/material.dart';
import 'screens/detail_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Verse',
      theme: ThemeData(
        fontFamily: 'Urbanist',
      ),
      // Pilih salah satu halaman yang ingin ditampilkan:
      // home: const SignInScreen(),
      // home: const SignUpScreen(),
      // home: const HomeScreen(),
      // home: const DetailScreen(),
      home: const FavoriteScreen(),
      // home: const ProfileScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}