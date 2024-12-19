import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JokeCard extends StatefulWidget {
  final String jokeText;

  const JokeCard({Key? key, required this.jokeText}) : super(key: key);

  @override
  _JokeCardState createState() => _JokeCardState();
}

class _JokeCardState extends State<JokeCard> with SingleTickerProviderStateMixin {
  bool isReacted = false; // Tracks if the emoji is reacted or not
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleReaction() {
    setState(() {
      isReacted = !isReacted;
      if (isReacted) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Color.fromARGB(255, 255, 249, 231),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.jokeText,
              style: GoogleFonts.comicNeue(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: toggleReaction,
                  child: Row(
                    children: [
                      Text(
                        "Haha",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isReacted ? Colors.orange : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 6),
                      ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 1.3).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.elasticOut,
                          ),
                        ),
                        child: Icon(
                          Icons.insert_emoticon_rounded,
                          color: isReacted ? Colors.orange : Colors.grey,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
