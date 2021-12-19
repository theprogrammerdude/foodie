import 'package:http/http.dart' as http;

class Meals {
  Future<http.Response> getCategoriesList() {
    var url =
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?c=list');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> filterByCategory(String category) {
    var url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> filterByIngredient(String ingredient) {
    var url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?i=$ingredient');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> searchMealByName(String name) {
    var url =
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$name');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> searchMealById(String id) {
    var url =
        Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> random() {
    var url = Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php');
    var res = http.get(url);

    return res;
  }

  Future<http.Response> getIngredientsList() {
    var url =
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?i=list');
    var res = http.get(url);

    return res;
  }
}
