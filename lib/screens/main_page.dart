import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:untitled/joke_providers/joke_service.dart';
import 'package:untitled/joke.dart';
import 'package:untitled/screens/favorite_page.dart';
import 'package:swiping_card_deck/swiping_card_deck.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Joke> joke = ref.watch(jokeProvider);
    List<Card> cardDeck = [];
    ref.watch(jokesProvider);

    Card createCard(text) {
      return Card(
        child: Padding(padding: const EdgeInsets.all(32.0), child: Text(text)),
      );
    }

    List<Card> getCardDeck() {
      cardDeck.add(joke.when(
        data: (joke) => createCard(joke.value),
        error: (e, s) => createCard('404'),
        loading: () => createCard('loading in progress'),
      ));
      return cardDeck;
    }

    final SwipingCardDeck deck = SwipingCardDeck(
      cardDeck: getCardDeck(),
      onDeckEmpty: () => null,
      onLeftSwipe: (Card card) =>
          {ref.refresh(jokeProvider), debugPrint("Swiped left!")},
      onRightSwipe: (Card card) =>
          {ref.refresh(jokeProvider), debugPrint("Swiped right!")},
      cardWidth: 350,
      swipeThreshold: MediaQuery.of(context).size.width / 3,
      minimumVelocity: 1000,
      rotationFactor: 0.8 / 3.14,
      swipeAnimationDuration: const Duration(milliseconds: 500),
    );
    // ref.watch(jokesProvider).clear();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Center(child: Text(title)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.star_half),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritePage(title: 'Favorite'),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'images/hw1.png',
                  fit: BoxFit.contain,
                  width: 200,
                ),
                SizedBox(
                  height: 250,
                  child: FractionallySizedBox(widthFactor: 1, child: deck),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      iconSize: 30,
                      color: Colors.red,
                      onPressed: () => ref.refresh(jokeProvider),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                        icon: Icon((joke.value?.completed ?? false)
                            ? Icons.star
                            : Icons.star_border),
                        iconSize: 30,
                        color: Colors.yellow,
                        onPressed: () => {
                              ref
                                  .watch(jokesProvider.notifier)
                                  .toggle(joke.when(
                                    data: (joke) => joke,
                                    error: (e, s) => Joke(
                                        [''],
                                        'Oh... no error with joke loading',
                                        '',
                                        '',
                                        '',
                                        '',
                                        ''),
                                    loading: () => Joke(
                                        [''], 'Loading', '', '', '', '', ''),
                                  )),
                            }),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.check),
                      iconSize: 30,
                      color: Colors.green,
                      onPressed: () => ref.refresh(jokeProvider),
                    ),
                  ],
                ),
                const DialogExample(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Modified: https://api.flutter.dev/flutter/material/AlertDialog-class.html
class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Chuck oh..no..'),
          content: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Hi, my name is Arina Drenyassova'),
                Text(
                    'My track is software engineer and I am 4th year bachelor in inno.'),
                Text('email: a.drenyasova@innopolis.university'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'CLOSE'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show credentials'),
    );
  }
}
