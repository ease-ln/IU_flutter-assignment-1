import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/applicaton/joke_service.dart';
import 'package:untitled/joke.dart';

class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Joke> jokes = ref.watch(jokesProvider);
    Card createCard(text) {// return Card(child: Text(alreadyAdd.toString()));
      return Card(
          child: Container(
            width: MediaQuery.of(context).size.width*0.8,
            child: Padding(padding: const EdgeInsets.all(32.0), child: Text(text)),
          )
      );
    }
    final Iterable<Row> cards = ref.watch(jokesProvider.notifier).state.map(
            (joke) =>
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  createCard(joke.value),
                  IconButton(
                      icon: Icon( joke.completed ? Icons.star: Icons.star_border),
                      iconSize: 30,
                      color: Colors.yellow,
                      onPressed: () => {
                        ref.read(jokesProvider.notifier).toggle(joke),
                      }
                  ),
                ]
            )
    );

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text('Favorites')),
            body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: cards.toList(),
                )
            )
        )
    );
  }
}