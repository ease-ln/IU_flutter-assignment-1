import 'package:json_annotation/json_annotation.dart';

part 'joke.g.dart';

@JsonSerializable()
class Joke {
  Joke(this.categories, this.createdAt, this.iconUrl, this.id, this.updatedAt,
      this.url, this.value);

  @JsonKey(name: 'categories')
  List categories;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'icon_url')
  String iconUrl;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  @JsonKey(name: 'url')
  String url;

  @JsonKey(name: 'value')
  String value;

  factory Joke.fromJson(Map<String, dynamic> json) => _$JokeFromJson(json);
}
