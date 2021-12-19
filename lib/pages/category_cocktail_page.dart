import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/methods/cocktail_api.dart';
import 'package:foodie/pages/drink_page.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryCocktail extends StatefulWidget {
  const CategoryCocktail({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  _CategoryCocktailState createState() => _CategoryCocktailState();
}

class _CategoryCocktailState extends State<CategoryCocktail> {
  final Cocktail _cocktail = Cocktail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.category.text.make(),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: _cocktail.filterByCategory(widget.category),
        builder: (context, AsyncSnapshot<Response> snapshot) {
          if (snapshot.hasData) {
            List drinks = [];
            Map<String, dynamic> data = jsonDecode(snapshot.data!.body);

            drinks = data['drinks'];

            // print(drinks);

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
                              name: drinks[index]['strDrink'],
                              id: drinks[index]['idDrink']))),
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
