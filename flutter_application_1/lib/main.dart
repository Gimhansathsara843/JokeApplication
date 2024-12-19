import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_application_1/AnimatedSplashScreen.dart';
import 'package:flutter_application_1/JokeCard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'joke_service.dart';
import 'joke_model.dart';

void main() {
  runApp(const JokeApp());
}

class JokeApp extends StatelessWidget {
  const JokeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     title: 'Joke App',

      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
      ),
      home:AnimatedSplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final JokeService _jokeService = JokeService();
  List<Joke> _jokes = [];
  bool _isLoading = false;
  bool _isOffline = true;

  @override
  void initState() {
    super.initState();
    _checkInternetAndFetchJokes();
  }

Future<void> _checkInternetAndFetchJokes() async {
  if (_isLoading) {
    print("Already loading, returning early to prevent duplicate requests.");
    return;
  }
  print("Checking internet connectivity...");

  setState(() {
    _isLoading = true;
  });

  // First check connectivity status
  final connectivityResult = await Connectivity().checkConnectivity();
  bool wasOffline = _isOffline;
  print("Connectivity result: $connectivityResult");

  // Actually test the connection by making a small request
  bool hasInternet = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    hasInternet = false;
  }

  print("Actual internet connectivity: $hasInternet");

  setState(() {
    _isOffline = !hasInternet;
    _isLoading = !_isOffline;
  });

  print("Current connection state - _isOffline: $_isOffline, wasOffline: $wasOffline");

  // If we're offline, show appropriate message
  if (_isOffline) {
    print("Device is offline. Showing offline message.");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Please check your WiFi.'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
    return;
  }

  // If we were offline but now online, show reconnected message
  if (wasOffline && !_isOffline) {
    print("Connection restored! Was offline, now online.");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Back online! Fetching jokes...'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  try {
    print("Attempting to fetch jokes...");
    final jokes = await _jokeService.fetchJokes();

    if (mounted) {
      setState(() {
        _jokes = jokes.take(5).toList();
        print("Successfully fetched ${_jokes.length} jokes.");
      });
    }
  } catch (error) {
    print("Error occurred while fetching jokes: $error");
    if (mounted) {
      // Set offline if we can't reach the server
      setState(() {
        _isOffline = true;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unable to fetch jokes. Please check your connection.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _checkInternetAndFetchJokes,
          ),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
        print("Request completed. Loading status set to false.");
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar:AppBar(
  title: Center(
    child: Text(
      'Jokes App', 
      style: GoogleFonts.balooBhai2(
        fontSize: 50, 
        fontWeight: FontWeight.bold, 
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
    ),
  ),        
  
  leading: _isOffline 
    ? const Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(Icons.wifi_off_outlined, color: Color.fromARGB(255, 255, 0, 0)),
      )
    : const Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(Icons.wifi, color: Color.fromARGB(255, 0, 0, 0)),
      ),
      
  actions: [
    // Empty actions to balance the layout
    SizedBox(width: 56), // Matches the width of the leading icon
  ],
),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
Container(
  width: 300,
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(30), // Oval shape
    border: Border.all(
      color: _isOffline ? Color(0xFFFF0000 ) : Color(0xFF4CAF50 ),
      width: 2,
    ),
    color: _isOffline 
      ? Color(0xFFFF0000 ).withOpacity(0.1)  // Light red background when offline
      : Color(0xFF4CAF50 ).withOpacity(0.1)// Light black background when online
  ),
  child: Text(
    _isOffline ? 'Offline Mode' : 'Online Mode',
    style: TextStyle(
      fontSize: 15, 
      fontWeight: FontWeight.bold,
      color: _isOffline ? Color(0xFFFF0000 ) : Color(0xFF4CAF50 ),
    ),
    textAlign: TextAlign.center,
  ),
),
            const SizedBox(height: 16),
ElevatedButton(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.amber), // Button background color
    foregroundColor: MaterialStateProperty.all(Colors.black), // Text color
    elevation: MaterialStateProperty.all(4), // Button elevation
  ),
  onPressed: _isLoading ? null : _checkInternetAndFetchJokes,
  child: _isLoading
      ? const CircularProgressIndicator(color: Colors.white)
      : Row(
          mainAxisSize: MainAxisSize.min, // Ensures the button size wraps content
          children: const [
            Icon(Icons.refresh), // Icon widget
            SizedBox(width: 8), // Spacing between icon and text
            Text(
              'Refresh',
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ],
        ),
),

            const SizedBox(height: 10),
            Expanded(
              child: _jokes.isEmpty
                  ? const Center(child: Text('No jokes available'))
                  : ListView.builder(
                      itemCount: _jokes.length,
                      itemBuilder: (context, index) {
                        final joke = _jokes[index];
return JokeCard(
  jokeText: joke.setup != null
      ? '${joke.setup} - ${joke.delivery}'
      : joke.joke ?? 'No joke available',
);

                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}