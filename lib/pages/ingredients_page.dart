import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/methods/meals_api.dart';
import 'package:foodie/pages/ingredient_food_page.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';

class Ingredients extends StatefulWidget {
  const Ingredients({Key? key}) : super(key: key);

  @override
  _IngredientsState createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  final Meals _meals = Meals();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Ingredients'.text.make(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: _meals.getIngredientsList(),
        builder: (context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = jsonDecode(snapshot.data!.body);

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: data['meals'].length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IngredientFood(
                              ingredient: data['meals'][index]
                                  ['strIngredient']))),
                  child: Card(
                    child: CachedNetworkImage(
                            imageUrl:
                                'https://www.themealdb.com/images/ingredients/${data['meals'][index]['strIngredient']}.png')
                        .p8(),
                  ),
                );
              },
            );
          }

          return const SizedBox(
            height: 0,
          );
        },
      ).p12(),
    );
  }
}
