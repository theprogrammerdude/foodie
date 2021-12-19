import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/methods/cocktail_api.dart';
import 'package:foodie/pages/ingredient_cocktail_page.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';

class Ingredients1 extends StatefulWidget {
  const Ingredients1({Key? key}) : super(key: key);

  @override
  _Ingredients1State createState() => _Ingredients1State();
}

class _Ingredients1State extends State<Ingredients1> {
  final Cocktail _cocktail = Cocktail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Ingredients'.text.make(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: _cocktail.getIngredientList(),
        builder: (context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = jsonDecode(snapshot.data!.body);

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: data['drinks'].length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IngredientCocktail(
                              ingredient: data['drinks'][index]
                                  ['strIngredient1']))),
                  child: Card(
                    child: CachedNetworkImage(
                            imageUrl:
                                'https://www.thecocktaildb.com/images/ingredients/${data['drinks'][index]['strIngredient1']}.png')
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
