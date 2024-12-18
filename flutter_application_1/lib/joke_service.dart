import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'joke_model.dart';

class JokeService {
  final Dio _dio = Dio();
  static const String _cachedJokesKey = 'cached_jokes';

  Future<List<Joke>> fetchJokes() async {
    try {
      // Try to fetch jokes from the internet
      final response = await _dio.get(
        'https://v2.jokeapi.dev/joke/Any?amount=5',
      );

      if (response.statusCode == 200 && response.data != null) {
        final jokesData = response.data['jokes'] as List;
        final jokes = jokesData.map((jokeJson) => Joke.fromJson(jokeJson)).toList();
        
        // Cache the jokes
        await _cacheJokes(jokes);
        
        return jokes;
      } else {
        // If internet fetch fails, try to get cached jokes
        return await _getCachedJokes();
      }
    } catch (e) {
      // If there's an error (like no internet), get cached jokes
      return await _getCachedJokes();
    }
  }

  Future<void> _cacheJokes(List<Joke> jokes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonJokes = jokes.map((joke) => joke.toJson()).toList();
    await prefs.setString(_cachedJokesKey, json.encode(jsonJokes));
  }

  Future<List<Joke>> _getCachedJokes() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJokesString = prefs.getString(_cachedJokesKey);

    if (cachedJokesString != null) {
      final List<dynamic> jsonJokes = json.decode(cachedJokesString);
      return jsonJokes.map((jokeJson) => Joke.fromJson(jokeJson)).toList();
    }

    // Return empty list if no cached jokes
    return [];
  }
}