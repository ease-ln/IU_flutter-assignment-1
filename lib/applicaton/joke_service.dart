import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/joke.dart';

final FutureProvider<Joke> jokeProvider = FutureProvider<Joke> ((ref) async {
  String url = "https://api.chucknorris.io/jokes/random";
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Joke.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return Joke([''], '', '', '', '', '', 'oh.. no');
    }
  } catch (e) {
    return Joke([''], '', '', '', '', '', 'oh.. no.. '+e.toString());
  }

});

final jokeState = StateProvider<AsyncValue<Joke>>((ref) =>
  const AsyncValue.loading(),
);


final jokesProvider = StateNotifierProvider<Jokes, List<Joke>>((ref) => Jokes());

class Jokes extends StateNotifier<List<Joke>> {
  Jokes(): super([]);

  void writeJoke(newJoke) async {
    state = [...state, newJoke];
  }

  void deleteJoke(jokeTar) async {
    state = [for (final joke in state) if (joke.value != jokeTar.value) joke,];
  }

  void toggle(Joke joke) {
    joke.completed = !joke.completed;
    if (state.contains(joke)) {
      this.deleteJoke(joke);
    } else {
      this.writeJoke(joke);
    }
  }
}


