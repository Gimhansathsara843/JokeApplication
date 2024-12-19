import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


class AnimatedSplashScreen extends StatefulWidget {
  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Animation duration
    );

    _animation = Tween<double>(begin: 0.0, end: 3.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // Navigate to the main page after the animation completes
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Joke App')),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
         Lottie.network(
          'https://lottie.host/24c2ae49-71a9-4551-823c-aff86a43d409/VoRlBxlSR9.json',
          height: 300,
        ),
  
              const SizedBox(height: 20),
              Text(
                "Welcome to Joke App!",
                style: GoogleFonts.comicNeue(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
