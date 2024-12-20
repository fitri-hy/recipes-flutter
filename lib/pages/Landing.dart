import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/Service.dart';
import '../plugin/ShimmerLoading.dart';
import 'Search.dart';
import 'List.dart';
import 'Detail.dart';
import 'Settings.dart';
import '../services/AdMobConfig.dart';

// AdMob
import 'package:google_mobile_ads/google_mobile_ads.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Future<List<Map<String, dynamic>>> recipes;
  late Future<List<Map<String, dynamic>>> randomRecipes;
  late Future<List<Map<String, dynamic>>> randomRecipes2;
  
  // AdMob
  late BannerAd _bannerAd;
  late BannerAd _bannerAd2;
  bool _isBannerAdLoaded = false;
  bool _isBannerAdLoaded2 = false;

  @override
  void initState() {
    super.initState();
    recipes = fetchRecipes();
    randomRecipes = fetchRandomRecipes();
    randomRecipes2 = fetchRandomRecipes();
	
	// AdMob
    _initAdMob();
    _initAdMob2();
  }

  // AdMob
  void _initAdMob() {
    _bannerAd = BannerAd(
      adUnitId: AdMobConfig.bannerAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('First Ad failed to load: $error');
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );
    _bannerAd.load();
  }

  // AdMob
  void _initAdMob2() {
    _bannerAd2 = BannerAd(
      adUnitId: AdMobConfig.bannerAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded2 = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Second Ad failed to load: $error');
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );
    _bannerAd2.load();
  }

  Future<List<Map<String, dynamic>>> fetchRecipes() async {
    final recipeService = RecipeService();
    try {
      final data = await recipeService.fetchRecipeList(1);
      final recipes = List<Map<String, dynamic>>.from(data['recipes']);
      return recipes;
    } catch (e) {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRandomRecipes() async {
    final recipeService = RecipeService();
    try {
      final data = await recipeService.fetchRecipeList(1);
      final recipes = List<Map<String, dynamic>>.from(data['recipes']);
      recipes.shuffle();
      return recipes;
    } catch (e) {
      throw Exception('Failed to load random recipes');
    }
  }

  Image getImageList(Map<String, dynamic> recipe) {
    String imageUrl = recipe['imageUrl'];
    if (imageUrl.startsWith('data:image')) {
      List<int> bytes = base64Decode(imageUrl.split(',').last);
      Uint8List uint8List = Uint8List.fromList(bytes);
      return Image.memory(
        uint8List,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        imageUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

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
              'Resep Masakan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: randomRecipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ShimmerLoading(isGrid: true);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Failed to load recipes'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No recipes available'),
                  );
                } else {
                  final randomRecipes = snapshot.data!;
                  return CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.9,
                      pageSnapping: true,
                      enlargeFactor: 0.3,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                    ),
                    items: randomRecipes.map((recipe) {
                      return GestureDetector(
                        onTap: () {
                          String slug = recipe['slug'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(slug: slug),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: getImageBanner(recipe),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 10,
                                right: 10,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    recipe['title'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10.0,
                                          color: Colors.black,
                                          offset: Offset(0.0, 0.0),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
			// AdMob
			if (_isBannerAdLoaded)
              Container(
                alignment: Alignment.center,
                child: AdWidget(ad: _bannerAd),
                width: _bannerAd.size.width.toDouble(),
                height: _bannerAd.size.height.toDouble(),
				margin: EdgeInsets.only(top: 25),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 10, left: 15),
              child: Row(
                children: [
                  Text(
                    'Resep Terbaru',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: recipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ShimmerLoading(isGrid: false);
                } else if (snapshot.hasError) {
                  return Text('Failed to load recipes');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No recipes available');
                } else {
                  final recipes = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recipes.length < 6 ? recipes.length : 6,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return GestureDetector(
                        onTap: () {
                          String slug = recipe['slug'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(slug: slug),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                          child: Card(
                            elevation: 0.3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: getImageList(recipe),
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
                    },
                  );
                }
              },
            ),
			// AdMob
			if (_isBannerAdLoaded2)
              Container(
                alignment: Alignment.center,
                child: AdWidget(ad: _bannerAd2),
                width: _bannerAd2.size.width.toDouble(),
                height: _bannerAd2.size.height.toDouble(),
				margin: EdgeInsets.only(top: 25),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 10, left: 15),
              child: Row(
                children: [
                  Text(
                    'Resep Populer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: randomRecipes2,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ShimmerLoading(isGrid: false);
                } else if (snapshot.hasError) {
                  return Text('Failed to load recipes');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No recipes available');
                } else {
                  final randomRecipes2 = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: randomRecipes2.length < 6 ? randomRecipes2.length : 6,
                    itemBuilder: (context, index) {
                      final recipe = randomRecipes2[index];
                      return GestureDetector(
                        onTap: () {
                          String slug = recipe['slug'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(slug: slug),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                          child: Card(
                            elevation: 0.3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: getImageList(recipe),
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
                    },
                  );
                }
              },
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20, top: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeListPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Resep Lainnya',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _bannerAd2.dispose();
    super.dispose();
  }
}
