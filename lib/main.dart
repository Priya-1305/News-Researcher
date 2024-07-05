import 'package:flutter/material.dart';

import 'package:news_searcher/artical.dart';

import 'package:news_searcher/sevices.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Search App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _controller = TextEditingController();
  List<Article> _articles = [];
  bool _isLoading = false;

  void _searchArticles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final articles = await _apiService.fetchArticles(_controller.text);
      setState(() {
        _articles = articles;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Search App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search for news',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchArticles,
                ),
              ),
            ),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _articles.length,
                      itemBuilder: (context, index) {
                        final article = _articles[index];
                        return ListTile(
                          title: Text(article.title),
                          subtitle: Text(article.description),
                          leading: article.urlToImage.isNotEmpty
                              ? Image.network(article.urlToImage)
                              : null,
                          onTap: () {
                            // Handle article tap
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
