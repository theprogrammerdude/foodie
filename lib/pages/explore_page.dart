import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/methods/meals_api.dart';
import 'package:foodie/pages/category_food_page.dart';
import 'package:foodie/pages/ingredients_page.dart';
import 'package:foodie/pages/meal_page.dart';
import 'package:http/http.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:velocity_x/velocity_x.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final Meals _meals = Meals();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
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
                          'for Recipes'
                              .text
                              .color(Theme.of(context).primaryColor)
                              .size(24)
                              .make(),
                        ],
                      ),
                      IconButton(
                          onPressed: () => pushNewScreen(context,
                              screen: const Ingredients(), withNavBar: false),
                          icon: const Icon(
                            Icons.restaurant_menu_rounded,
                            size: 30,
                            color: Color(0xFFFFC439),
                          ))
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'ricepe name',
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
                    future: _meals.getCategoriesList(),
                    builder: (context, AsyncSnapshot<Response> snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data =
                            jsonDecode(snapshot.data!.body);

                        return SizedBox(
                          height: 50,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: data['meals'].length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => pushNewScreen(context,
                                    screen: CategoryFood(
                                      category: data['meals'][index]
                                          ['strCategory'],
                                    ),
                                    withNavBar: false),
                                child: Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3,
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: data['meals'][index]['strCategory']
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
                    future: _meals.random(),
                    builder: (context, AsyncSnapshot<Response> snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> data =
                            jsonDecode(snapshot.data!.body);

                        List tags = [];
                        if (data['meals'][0]['strTags'] != null) {
                          List tempTags = data['meals'][0]['strTags']
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
                                  builder: (context) => Meal(
                                      name: data['meals'][0]['strMeal'],
                                      id: data['meals'][0]['idMeal']))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: CachedNetworkImage(
                                    imageUrl: data['meals'][0]['strMealThumb']),
                              ),
                              data['meals'][0]['strMeal']
                                  .toString()
                                  .text
                                  .bold
                                  .size(26)
                                  .make()
                                  .pSymmetric(v: 5, h: 10),
                              Wrap(
                                children: tags
                                    .map((e) => Chip(
                                          label: e
                                              .toString()
                                              .text
                                              .bold
                                              .white
                                              .make(),
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                        ).pSymmetric(h: 5))
                                    .toList(),
                              ),
                              data['meals'][0]['strInstructions']
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
              )
            ],
          ).p16(),
        ),
      ),
    );
  }
}
