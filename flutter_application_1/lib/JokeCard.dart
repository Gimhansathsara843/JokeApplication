import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JokeCard extends StatefulWidget {
  final String jokeText;
  final bool isOffline;

  const JokeCard({Key? key, required this.jokeText, required this.isOffline})
      : super(key: key);

  @override
  _JokeCardState createState() => _JokeCardState();
}

class _JokeCardState extends State<JokeCard>
    with TickerProviderStateMixin {
  Map<String, bool> reactions = {
    'haha': false,
    'heart': false,
  };
  
  late Map<String, AnimationController> _animationControllers;

  @override
  void initState() {
    super.initState();
    // Initialize animation controllers for each emoji
    _animationControllers = Map.fromEntries(
      reactions.keys.map(
        (emoji) => MapEntry(
          emoji,
          AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 300),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all animation controllers
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void toggleReaction(String emojiType) {
    setState(() {
      reactions[emojiType] = !reactions[emojiType]!;
      if (reactions[emojiType]!) {
        _animationControllers[emojiType]?.forward();
      } else {
        _animationControllers[emojiType]?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: widget.isOffline
          ? Colors.orange.withOpacity(0.2)
          : const Color(0xFF4CAF50).withOpacity(0.2),
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
                buildEmojiRow('haha'),
                const SizedBox(width: 12),
                buildEmojiRow('heart'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEmojiRow(String emojiType) {
    String animatedPath = 'assets/images/${emojiType}_emoji.gif';
    String staticPath = 'assets/images/${emojiType}_emoji_static.gif';
    
    return GestureDetector(
      onTap: () => toggleReaction(emojiType),
      child: Column(
        children: [
          ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.3).animate(
              CurvedAnimation(
                parent: _animationControllers[emojiType]!,
                curve: Curves.elasticOut,
              ),
            ),
            child: reactions[emojiType]!
                ? Image.asset(
                    animatedPath,
                    width: 24,
                    height: 24,
                  )
                : Image.asset(
                    staticPath,
                    width: 24,
                    height: 24,
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            emojiType[0].toUpperCase() + emojiType.substring(1),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: reactions[emojiType]! ? Colors.orange : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}