import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../plugin/ShimmerDetailLoading.dart';
import '../services/Service.dart';
import 'Search.dart';
import 'Landing.dart';
import '../services/AdMobConfig.dart';

// AdMob
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  
  // AdMob
  late InterstitialAd _interstitialAd;
  late BannerAd _bannerAd1;
  late BannerAd _bannerAd2;
  bool _isInterstitialAdLoaded = false;
  bool _isBannerAdLoaded1 = false;
  bool _isBannerAdLoaded2 = false;

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
    
    // AdMob initialization
    _initInterstitialAd();
    _initBannerAd1();
    _initBannerAd2();
  }
  
  // AdMob: Interstitial Ad
  void _initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobConfig.initInterstitialAd,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
            _isInterstitialAdLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          print('Interstitial Ad failed to load: $error');
        },
      ),
    );
  }
  
  // AdMob: Banner Ad 1
  void _initBannerAd1() {
    _bannerAd1 = BannerAd(
      adUnitId: AdMobConfig.bannerAdUnitId,
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded1 = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner Ad 1 failed to load: $error');
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );
    _bannerAd1.load();
  }
  
  // AdMob: Banner Ad 2
  void _initBannerAd2() {
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
          print('Banner Ad 2 failed to load: $error');
          ad.dispose();
        },
      ),
      request: AdRequest(),
    );
    _bannerAd2.load();
  }
  
  @override
  void dispose() {
    _interstitialAd.dispose(); // AdMob: Interstitial Ad
    _bannerAd1.dispose();       // AdMob: Banner Ad 1
    _bannerAd2.dispose();       // AdMob: Banner Ad 2
    super.dispose();
  }

  Future<void> fetchRecipeDetail() async {
    try {
      final data = await recipeService.fetchRecipeDetail(widget.slug);
      setState(() {
        recipe = data;
      });
      
      if (_isInterstitialAdLoaded) {
        _interstitialAd.show();
      }
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
					  
					  //AdMob
                      if (_isBannerAdLoaded1)
					  Center(
						child: Container(
						  alignment: Alignment.center,
						  child: AdWidget(ad: _bannerAd1),
						  width: _bannerAd1.size.width.toDouble(),
						  height: _bannerAd1.size.height.toDouble(),
						  margin: EdgeInsets.only(top: 15),
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
					  
					  //AdMob
                      if (_isBannerAdLoaded2)
					  Center(
						child: Container(
						  alignment: Alignment.center,
						  child: AdWidget(ad: _bannerAd2),
						  width: _bannerAd2.size.width.toDouble(),
						  height: _bannerAd2.size.height.toDouble(),
						  margin: EdgeInsets.only(top: 15),
						),
					  ),
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
