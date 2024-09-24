import 'package:flutter/material.dart';
import 'package:news_searcher/artical.dart'; // Ensure correct import path
import 'package:news_searcher/sevices.dart'; // Ensure correct import path

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
      print('Error fetching articles: $e');
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
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _articles.length,
                      itemBuilder: (context, index) {
                        final article = _articles[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(
                                article.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(article.description),
                              leading: article.urlToImage.isNotEmpty
                                  ? Image.network(
                                      article.urlToImage,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[200],
                                      child: Icon(Icons.image),
                                    ),
                              onTap: () {
                                // Handle article tap
                                print('Tapped on: ${article.title}');
                              },
                            ),
                          ),
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
