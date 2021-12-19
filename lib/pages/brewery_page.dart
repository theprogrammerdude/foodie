import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/methods/cocktail_api.dart';
import 'package:foodie/pages/category_cocktail_page.dart';
import 'package:foodie/pages/drink_page.dart';
import 'package:foodie/pages/ingredients1_page.dart';
import 'package:http/http.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:velocity_x/velocity_x.dart';

class Brewery extends StatefulWidget {
  const Brewery({Key? key}) : super(key: key);

  @override
  _BreweryState createState() => _BreweryState();
}

class _BreweryState extends State<Brewery> {
  final Cocktail _cocktail = Cocktail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Search'
                      .text
                      .bold
                      .color(Theme.of(context).primaryColor)
                      .size(28)
                      .make(),
                  'for Drinks'
                      .text
                      .color(Theme.of(context).primaryColor)
                      .size(24)
                      .make(),
                ],
              ),
              IconButton(
                  onPressed: () => pushNewScreen(context,
                      screen: const Ingredients1(), withNavBar: false),
                  icon: const Icon(
                    Icons.wine_bar_rounded,
                    size: 30,
                    color: Color(0xFFFFC439),
                  ))
            ],
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'cocktail name',
              fillColor: Vx.gray200,
              filled: true,
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xFFFFC439),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
              enabled: false,
            ),
          ).pSymmetric(v: 20),
          FutureBuilder(
            future: _cocktail.getCategoryList(),
            builder: (context, AsyncSnapshot<Response> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data = jsonDecode(snapshot.data!.body);

                return SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: data['drinks'].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => pushNewScreen(context,
                            screen: CategoryCocktail(
                              category: data['drinks'][index]['strCategory'],
                            ),
                            withNavBar: false),
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 3,
                                color: Theme.of(context).primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: data['drinks'][index]['strCategory']
                              .toString()
                              .text
                              .extraBold
                              .color(Theme.of(context).primaryColor)
                              .make()
                              .p8()
                              .centered(),
                        ).pSymmetric(h: 5),
                      );
                    },
                  ),
                );
              }

              return const SizedBox(
                height: 0,
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          'Random Select for the Day'
              .text
              .bold
              .size(24)
              .make()
              .pSymmetric(v: 5),
          FutureBuilder(
            future: _cocktail.random(),
            builder: (context, AsyncSnapshot<Response> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data = jsonDecode(snapshot.data!.body);

                List tags = [];
                if (data['drinks'][0]['strTags'] != null) {
                  List tempTags = data['drinks'][0]['strTags']
                      .toString()
                      .split(',')
                      .toList();

                  for (var element in tempTags) {
                    if (element.toString().isNotEmpty) {
                      tags.add(element);
                    }
                  }
                }

                // print(tags);

                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Drink(
                              name: data['drinks'][0]['strDrink'],
                              id: data['drinks'][0]['idDrink']))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                            imageUrl: data['drinks'][0]['strDrinkThumb']),
                      ),
                      data['drinks'][0]['strDrink']
                          .toString()
                          .text
                          .bold
                          .size(26)
                          .make()
                          .pSymmetric(v: 5, h: 10),
                      Wrap(
                        children: tags
                            .map((e) => Chip(
                                  label: e.toString().text.bold.white.make(),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ).pSymmetric(h: 5))
                            .toList(),
                      ),
                      data['drinks'][0]['strInstructions']
                          .toString()
                          .text
                          .ellipsis
                          .make()
                          .pSymmetric(v: 5, h: 10),
                    ],
                  ),
                );
              }

              return const SizedBox(
                height: 0,
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ).p16(),
    )));
  }
}
