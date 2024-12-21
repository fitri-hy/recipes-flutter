import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeService {
  final String baseUrl = 'https://api.i-as.dev/api/recipe';

  Future<Map<String, dynamic>> fetchRecipeList(int page) async {
    final response = await http.get(Uri.parse('$baseUrl/list?page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<Map<String, dynamic>> fetchRecipeDetail(String slug) async {
    final String encodedSlug = Uri.encodeComponent(slug);
    final url = 'https://api.i-as.dev/api/recipe/detail/$encodedSlug';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipe detail');
    }
  }

  Future<Map<String, dynamic>> searchRecipes(String query, int page) async {
    final response = await http.get(Uri.parse('$baseUrl/search?q=$query&page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to search recipes');
    }
  }

  Future<Map<String, dynamic>> fetchCategoryList(int page) async {
    final response = await http.get(Uri.parse('$baseUrl/category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load category');
    }
  }
  
  Future<Map<String, dynamic>> fetchCategoryDetail(String slug, int page) async {
    final response = await http.get(Uri.parse('$baseUrl/category/$slug?page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load category detail');
    }
  }
}
