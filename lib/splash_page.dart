import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quick_bite/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.title});

  final String title;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Onboarding()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(widget.title, style: const TextStyle(fontSize: 40))),
    );
  }
}
