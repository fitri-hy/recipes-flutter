import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../plugin/ShimmerDetailLoading.dart';
import '../services/Service.dart';
import 'Search.dart';
import 'Landing.dart';

class DetailPage extends StatefulWidget {
  final String slug;

  DetailPage({required this.slug});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic> recipe = {};
  String? recipeError;
  final RecipeService recipeService = RecipeService();
	
  Image getImageBanner(Map<String, dynamic> recipe) {
    String imageUrl = recipe['imageUrl'];
    if (imageUrl.startsWith('data:image')) {
      List<int> bytes = base64Decode(imageUrl.split(',').last);
      Uint8List uint8List = Uint8List.fromList(bytes);
      return Image.memory(uint8List, fit: BoxFit.cover);
    } else {
      return Image.network(imageUrl, fit: BoxFit.cover);
    }
  }
  
  @override
  void initState() {
    super.initState();
    fetchRecipeDetail();
  }

  Future<void> fetchRecipeDetail() async {
    try {
      final data = await recipeService.fetchRecipeDetail(widget.slug);
      setState(() {
        recipe = data;
      });
    } catch (e) {
      setState(() {
        recipeError = e.toString();
      });
      print('Error fetching recipe detail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title'] ?? 'Memuat...'),
        actions: [
		  IconButton(
            icon: Icon(Icons.home),
			onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
              );
			},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
      ),
      body: recipeError != null
          ? Center(child: Text('Error: $recipeError', style: TextStyle(color: Colors.red, fontSize: 16)))
          : recipe.isEmpty
              ? ShimmerDetailLoading()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
						borderRadius: BorderRadius.circular(5),
						child: getImageBanner(recipe),
					  ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          recipe['title'],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          recipe['excerpt'],
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Chip(
                              label: Row(
                                children: [
                                  Icon(Icons.timer, size: 14, color: Colors.white),
                                  SizedBox(width: 5),
                                  Text('${recipe['time']}'),
                                ],
                              ),
                              backgroundColor: Colors.green,
                              labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                              elevation: 0,
                              shape: StadiumBorder(side: BorderSide.none),
                            ),
                            SizedBox(width: 10),
                            Chip(
                              label: Row(
                                children: [
                                  Icon(Icons.star, size: 14, color: Colors.white),
                                  SizedBox(width: 5),
                                  Text('${recipe['difficulty']}'),
                                ],
                              ),
                              backgroundColor: Colors.blueAccent,
                              labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                              elevation: 0,
                              shape: StadiumBorder(side: BorderSide.none),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Bahan-Bahan:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      ...recipe['ingredients'].map<Widget>((ingredient) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle, size: 18, color: Colors.green),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  ingredient,
                                  style: TextStyle(fontSize: 14),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Instruksi:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      ...recipe['instructions'].map<Widget>((instruction) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.blue),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  instruction,
                                  style: TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}
