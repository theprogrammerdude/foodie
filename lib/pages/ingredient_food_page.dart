import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/methods/meals_api.dart';
import 'package:foodie/pages/meal_page.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';

class IngredientFood extends StatefulWidget {
  const IngredientFood({Key? key, required this.ingredient}) : super(key: key);

  final String ingredient;

  @override
  _IngredientFoodState createState() => _IngredientFoodState();
}

class _IngredientFoodState extends State<IngredientFood> {
  final Meals _meals = Meals();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.ingredient.text.make(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: _meals.filterByIngredient(widget.ingredient),
        builder: (context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = jsonDecode(snapshot.data!.body);
            List meals = data['meals'];

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Meal(
                              name: meals[index]['strMeal'].toString(),
                              id: meals[index]['idMeal'].toString()))),
                  child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: ZStack([
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: meals[index]['strMealThumb'],
                            colorBlendMode: BlendMode.overlay,
                            color: Colors.black45,
                          ),
                        ),
                        meals[index]['strMeal']
                            .toString()
                            .text
                            .bold
                            .white
                            .size(22)
                            .make()
                            .backgroundColor(Colors.black45)
                            .objectBottomLeft()
                            .pSymmetric(v: 5, h: 8),
                      ])),
                );
              },
            );
          }

          return const SizedBox(
            height: 0,
          );
        },
      ),
    );
  }
}
