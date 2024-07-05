import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_searcher/artical.dart';

class ApiService {
  final String apiKey = '5cc93d57634243e0b056f0c67e0b1715';
  final String baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<Article>> fetchArticles(String query) async {
    final response =
        await http.get(Uri.parse('$baseUrl?q=$query&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> articlesJson = json['articles'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
