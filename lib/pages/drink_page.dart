import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:foodie/methods/cocktail_api.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';

class Drink extends StatefulWidget {
  const Drink({Key? key, required this.name, required this.id})
      : super(key: key);

  final String name;
  final String id;

  @override
  _DrinkState createState() => _DrinkState();
}

class _DrinkState extends State<Drink> {
  final Cocktail _cocktail = Cocktail();

  FlutterTts flutterTts = FlutterTts();

  bool isSpeakingInstructions = false;
  bool isSpeakingIngredients = false;

  Future _speak(String data) async {
    await flutterTts.speak(data);
  }

  Future _stop() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.name.text.ellipsis.make(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: _cocktail.searchById(widget.id),
        builder: (context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = jsonDecode(snapshot.data!.body);
            List ingredients = [];

            // print(data['drinks'][0]['strTags']);

            for (var i = 1; i <= 20; i++) {
              if (data['drinks'][0]['strIngredient$i'].toString() != 'null' &&
                  data['drinks'][0]['strMeasure$i'].toString() != 'null') {
                ingredients.add({
                  'ingredient': data['drinks'][0]['strIngredient$i'],
                  'measure': data['drinks'][0]['strMeasure$i']
                });
              }
            }

            // print(ingredients);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                      imageUrl: data['drinks'][0]['strDrinkThumb']),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data['drinks'][0]['strDrink']
                          .toString()
                          .text
                          .bold
                          .size(28)
                          .make(),
                      Row(
                        children: [
                          data['drinks'][0]['strArea'].toString() != 'null'
                              ? Chip(
                                  label: data['drinks'][0]['strArea']
                                      .toString()
                                      .text
                                      .bold
                                      .white
                                      .make(),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                )
                              : const SizedBox(
                                  width: 0,
                                ),
                          const SizedBox(
                            width: 8,
                          ),
                          Chip(
                            label: data['drinks'][0]['strCategory']
                                .toString()
                                .text
                                .bold
                                .white
                                .make(),
                            backgroundColor: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                      ingredients.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    'Ingredients'
                                        .text
                                        .bold
                                        .size(24)
                                        .make()
                                        .pSymmetric(v: 5),
                                    !isSpeakingIngredients
                                        ? IconButton(
                                            onPressed: () {
                                              _speak(ingredients.toString())
                                                  .then((value) {
                                                setState(() {
                                                  isSpeakingIngredients = true;
                                                  isSpeakingInstructions =
                                                      false;
                                                });

                                                VxToast.show(context,
                                                    msg:
                                                        "Text to Speech Active");
                                              });
                                            },
                                            icon: const Icon(Icons.volume_up))
                                        : IconButton(
                                            onPressed: () {
                                              _stop().then((value) {
                                                setState(() {
                                                  isSpeakingIngredients = false;
                                                });

                                                VxToast.show(context,
                                                    msg:
                                                        "Text to Speech inactive");
                                              });
                                            },
                                            icon:
                                                const Icon(Icons.volume_mute)),
                                  ],
                                ),
                                Wrap(
                                  children: ingredients
                                      .map((e) => Chip(
                                            label: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                (e['ingredient'].toString() +
                                                        ' - ')
                                                    .toString()
                                                    .text
                                                    .bold
                                                    .white
                                                    .make(),
                                                e['measure']
                                                    .toString()
                                                    .text
                                                    .bold
                                                    .white
                                                    .make(),
                                              ],
                                            ),
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                          ).pSymmetric(h: 5))
                                      .toList(),
                                )
                              ],
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      Row(
                        children: [
                          'Instructions'
                              .text
                              .bold
                              .size(24)
                              .make()
                              .pSymmetric(v: 5),
                          !isSpeakingInstructions
                              ? IconButton(
                                  onPressed: () {
                                    _speak(data['drinks'][0]['strInstructions'])
                                        .then((value) {
                                      setState(() {
                                        isSpeakingInstructions = true;
                                        isSpeakingIngredients = false;
                                      });

                                      VxToast.show(context,
                                          msg: "Text to Speech Active");
                                    });
                                  },
                                  icon: const Icon(Icons.volume_up))
                              : IconButton(
                                  onPressed: () {
                                    _stop().then((value) {
                                      setState(() {
                                        isSpeakingInstructions = false;
                                      });

                                      VxToast.show(context,
                                          msg: "Text to Speech inactive");
                                    });
                                  },
                                  icon: const Icon(Icons.volume_mute)),
                        ],
                      ),
                      data['drinks'][0]['strInstructions']
                          .toString()
                          .text
                          .make()
                          .pSymmetric(v: 5),
                    ],
                  ).p12(),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
