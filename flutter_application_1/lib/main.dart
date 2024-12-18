import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
      home: const MyHomePage(title: 'Joke App'),
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
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkInternetAndFetchJokes();
  }

  Future<void> _checkInternetAndFetchJokes() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    
    setState(() {
      _isOffline = connectivityResult == ConnectivityResult.none;
      _isLoading = true;
    });

    try {
      final jokes = await _jokeService.fetchJokes();
      setState(() {
        _jokes = jokes.take(5).toList();
      });
      print("fvdfvdfvdfvdfvdfvdfvd\n");
      print(_isOffline);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching jokes: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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

            const SizedBox(height: 16),
            Expanded(
              child: _jokes.isEmpty
                  ? const Center(child: Text('No jokes available'))
                  : ListView.builder(
                      itemCount: _jokes.length,
                      itemBuilder: (context, index) {
                        final joke = _jokes[index];
                        return Card(
                          elevation: 4,
                          color:Color(0xFFFFF8E1),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              joke.setup != null
                                  ? '${joke.setup} - ${joke.delivery}'
                                  : joke.joke ?? 'No joke available',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black),
                            ),
                          ),
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