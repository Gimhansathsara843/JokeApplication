part of 'joke_model.dart';

Joke _$JokeFromJson(Map<String, dynamic> json) => Joke(
      setup: json['setup'] as String?,
      delivery: json['delivery'] as String?,
      joke: json['joke'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$JokeToJson(Joke instance) => <String, dynamic>{
      'setup': instance.setup,
      'delivery': instance.delivery,
      'joke': instance.joke,
      'type': instance.type,
    };
