import 'package:http/http.dart' as http;

class Cocktail {
  Future<http.Response> getCategoryList() {
    var url =
        Uri.parse('http://www.thecocktaildb.com/api/json/v1/1/list.php?c=list');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> getIngredientList() {
    var url = Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> filterByCategory(String category) {
    var url = Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=$category');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> filterByIngredient(String ingredient) {
    var url = Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=$ingredient');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> searchById(String id) {
    var url = Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> random() {
    var url =
        Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/random.php');
    var res = http.get(url);

    return res;
  }
}
