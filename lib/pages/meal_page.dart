import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:foodie/methods/meals_api.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';

class Meal extends StatefulWidget {
  const Meal({Key? key, required this.name, required this.id})
      : super(key: key);

  final String name;
  final String id;

  @override
  _MealState createState() => _MealState();
}

class _MealState extends State<Meal> {
  final Meals _meals = Meals();

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
        future: _meals.searchMealById(widget.id),
        builder: (context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = jsonDecode(snapshot.data!.body);
            List ingredients = [];

            // print(data['meals'][0]['strTags']);

            for (var i = 1; i <= 20; i++) {
              if (data['meals'][0]['strIngredient$i'].toString().isNotEmpty &&
                  data['meals'][0]['strMeasure$i'].toString().isNotEmpty) {
                ingredients.add({
                  'ingredient': data['meals'][0]['strIngredient$i'],
                  'measure': data['meals'][0]['strMeasure$i']
                });
              }
            }

            // print(ingredients);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                      imageUrl: data['meals'][0]['strMealThumb']),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data['meals'][0]['strMeal']
                          .toString()
                          .text
                          .bold
                          .size(28)
                          .make(),
                      Row(
                        children: [
                          Chip(
                            label: data['meals'][0]['strArea']
                                .toString()
                                .text
                                .bold
                                .white
                                .make(),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Chip(
                            label: data['meals'][0]['strCategory']
                                .toString()
                                .text
                                .bold
                                .white
                                .make(),
                            backgroundColor: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                      Column(
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
                                            isSpeakingInstructions = false;
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
                                            isSpeakingIngredients = false;
                                          });

                                          VxToast.show(context,
                                              msg: "Text to Speech inactive");
                                        });
                                      },
                                      icon: const Icon(Icons.volume_mute)),
                            ],
                          ),
                          Wrap(
                            children: ingredients
                                .map((e) => Chip(
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (e['ingredient'] + ' - ')
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
                                    _speak(data['meals'][0]['strInstructions'])
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
                      data['meals'][0]['strInstructions']
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
