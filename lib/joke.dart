import 'package:json_annotation/json_annotation.dart';

part 'joke.g.dart';

@JsonSerializable()
class Joke {
  final List categories;
  final String createdAt;
  final String iconUrl;
  final String id;
  final String url;
  final String updatedAt;
  final String value;
  bool completed = false;

  Joke(this.categories, this.createdAt, this.iconUrl, this.id, this.updatedAt, this.url, this.value);

  Joke copyWith(joke) {
    joke.completed = !joke.completed;
    return joke;
  }

  factory Joke.fromJson(Map<String, dynamic> json) => _$JokeFromJson(json);

  Map<String, dynamic> toJson() => {
    'categories': categories.toString(),
    'createdAt': createdAt,
    'iconUrl': iconUrl.toString(),
    'id': id,
    'url': url,
    'updatedAt': updatedAt,
    'value': value,
    'completed': completed,
  };
}
