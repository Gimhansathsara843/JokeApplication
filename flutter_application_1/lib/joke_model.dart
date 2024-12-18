import 'package:json_annotation/json_annotation.dart';

part 'joke_model.g.dart';

@JsonSerializable()
class Joke {
  final String? setup;
  final String? delivery;
  final String? joke;
  final String? type;

  Joke({this.setup, this.delivery, this.joke, this.type});

  factory Joke.fromJson(Map<String, dynamic> json) => _$JokeFromJson(json);
  Map<String, dynamic> toJson() => _$JokeToJson(this);
}