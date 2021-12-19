import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/methods/cocktail_api.dart';
import 'package:foodie/pages/drink_page.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';

class IngredientCocktail extends StatefulWidget {
  const IngredientCocktail({Key? key, required this.ingredient})
      : super(key: key);

  final String ingredient;

  @override
  _IngredientCocktailState createState() => _IngredientCocktailState();
}

class _IngredientCocktailState extends State<IngredientCocktail> {
  final Cocktail _cocktail = Cocktail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.ingredient.text.make(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: _cocktail.filterByIngredient(widget.ingredient),
        builder: (context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = jsonDecode(snapshot.data!.body);
            List drinks = data['drinks'];

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: drinks.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Drink(
                              name: drinks[index]['strDrink'].toString(),
                              id: drinks[index]['idDrink'].toString()))),
                  child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: ZStack([
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: drinks[index]['strDrinkThumb'],
                            colorBlendMode: BlendMode.overlay,
                            color: Colors.black45,
                          ),
                        ),
                        drinks[index]['strDrink']
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
