import 'package:flutter/material.dart';
import '../services/Service.dart';
import '../plugin/ShimmerListLoading.dart';
import 'Detail.dart';
import 'Landing.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List recipes = [];
  String query = '';
  int currentPage = 1;
  int? nextPage;
  int? prevPage;
  final RecipeService recipeService = RecipeService();
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> searchRecipes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await recipeService.searchRecipes(query, currentPage);
      setState(() {
        recipes = data['recipes'];
        nextPage = data['pagination']['nextPage'];
        prevPage = data['pagination']['prevPage'];
        isLoading = false;
      });
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error searching recipes: $e');
    }
  }

  void goToNextPage() {
    if (nextPage != null) {
      setState(() {
        currentPage = nextPage!;
      });
      searchRecipes();
    }
  }

  void goToPrevPage() {
    if (prevPage != null) {
      setState(() {
        currentPage = prevPage!;
      });
      searchRecipes();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
			children: [
			  Image.asset(
				'assets/logo.png',
				height: 30,
			  ),
			  SizedBox(width: 10),
			  Text(
			  'Pencarian',
				style: TextStyle(
				  fontWeight: FontWeight.bold,
				),
			  ),
			],
		),
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
        ],
      ),
      body: isLoading
          ? ShimmerListLoading(
              isList: true,
              scrollController: _scrollController,
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        query = text;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Cari Resep',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: searchRecipes,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: recipes.length + 1,
                    itemBuilder: (context, index) {
                      if (index < recipes.length) {
                        var recipe = recipes[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                          child: InkWell(
                            onTap: () {
                              String slug = recipe['slug'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(slug: slug),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 0.3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        recipe['imageUrl'],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recipe['title'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '${recipe['time']} - ${recipe['difficulty']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (prevPage != null)
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: goToPrevPage,
                                ),
                              SizedBox(width: 20),
                              if (nextPage != null)
                                IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: goToNextPage,
                                ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
