import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swiping_card_deck/swiping_card_deck.dart';
import 'package:untitled/joke.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment 1',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        backgroundColor: const Color(0xFFe2e2e2),
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'Tinder with Chuck'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _text = 'Swipe to left or right to see the jokes';
  List<Card> cardDeck = [];

  // This future request data from provided url and save joke to _chuckJoke variable
  Future<String> getRequest() async {
    String url = "https://api.chucknorris.io/jokes/random";
    final response = await http.get(Uri.parse(url));
    final joke =
        Joke.fromJson(jsonDecode(response.body) as Map<String, dynamic>);

    setState(() => _text = joke.value);

    return joke.value;
  }

  Card createCard(text) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(32.0), child: Text(text)),
    );
  }

  List<Card> getCardDeck() {
    List<Card> cardDeck = [];
    for (int i = 0; i < 5; ++i) {
      cardDeck.add(createCard(_text));
    }
    return cardDeck;
  }

  @override
  Widget build(BuildContext context) {
    final SwipingCardDeck deck = SwipingCardDeck(
      cardDeck: getCardDeck(),
      onDeckEmpty: () => getRequest(),
      onLeftSwipe: (Card card) => {getRequest(), debugPrint("Swiped left!")},
      onRightSwipe: (Card card) => {getRequest(), debugPrint("Swiped right!")},
      cardWidth: 300,
      swipeThreshold: MediaQuery.of(context).size.width / 3,
      minimumVelocity: 1000,
      rotationFactor: 0.8 / 3.14,
      swipeAnimationDuration: const Duration(milliseconds: 500),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Center(child: Text(widget.title)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'images/hw1.png',
                  fit: BoxFit.contain,
                  width: 200,
                ),
                SizedBox(
                  height: 200,
                  child: deck,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      iconSize: 30,
                      color: Colors.red,
                      onPressed:
                          deck.animationActive ? null : () => getRequest(),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      icon: const Icon(Icons.check),
                      iconSize: 30,
                      color: Colors.green,
                      onPressed:
                          deck.animationActive ? null : () => getRequest(),
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
            height: 100,
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
