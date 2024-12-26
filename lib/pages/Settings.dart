import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'Landing.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffffffff),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Informasi',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Tentang Aplikasi',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                    fontSize: 20,
                  ),
            ),
            SizedBox(height: 8),
            Text(
              'Aplikasi "Resep Masakan" hadir untuk memudahkan Anda dalam menemukan beragam resep lezat dari berbagai masakan tradisional hingga modern. Apakah Anda seorang koki amatir atau ahli kuliner, aplikasi ini menyediakan ribuan resep dengan langkah-langkah jelas dan praktis untuk memandu Anda menciptakan hidangan yang memanjakan lidah.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[800],
              ),
            ),
            SizedBox(height: 24),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final String appLink = 'https://play.google.com/store/apps/details?id=com.iasdev.resepmasakan';
                    Clipboard.setData(ClipboardData(text: appLink));
                    final snackBar = SnackBar(
                      content: Text('Tautan aplikasi telah disalin!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  icon: Icon(Icons.content_copy, color: Colors.white),
                  label: Text('Bagikan Aplikasi', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Pengembang',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                    fontSize: 20,
                  ),
            ),
            SizedBox(height: 8),
            Card(
			  elevation: 3,
			  shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(5),
			  ),
			  child: Container(
				padding: const EdgeInsets.all(16.0),
				decoration: BoxDecoration(
				  gradient: LinearGradient(
					colors: [Colors.blueAccent, Colors.blue],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				  ),
				  borderRadius: BorderRadius.circular(5),
				),
				child: Column(
				  crossAxisAlignment: CrossAxisAlignment.start,
				  children: [
					Row(
					  children: [
						ClipRRect(
						  borderRadius: BorderRadius.circular(50),
						  child: Image.asset(
							'assets/developer.png',
							width: 60,
							height: 60,
							fit: BoxFit.cover,
						  ),
						),
						SizedBox(width: 16),
						Expanded(
						  child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
							  Text(
								'Fitri HY',
								style: TextStyle(
								  fontWeight: FontWeight.bold,
								  fontSize: 20,
								  color: Colors.white,
								),
							  ),
							  SizedBox(height: 5),
							  Text(
								'Fullstack Developer',
								style: TextStyle(
								  fontSize: 14,
								  color: Colors.white,
								),
							  ),
							  Row(
								children: [
								  Icon(
									Icons.apartment,
									color: Colors.white,
									size: 18,
								  ),
								  SizedBox(width: 4),
								  Text(
									'I-As.Dev',
									style: TextStyle(
									  fontSize: 14,
									  color: Colors.white,
									),
								  ),
								],
							  ),
							],
						  ),
						),
						IconButton(
						  icon: Image.asset(
							'assets/wa.png',
							width: 25,
							height: 25,
						  ),
						  onPressed: () {
							final phoneNumber = '6281525977595';
							final whatsappUrl = 'https://wa.me/$phoneNumber';
							launchURL(whatsappUrl);
						  },
						),
					  ],
					),
					SizedBox(height: 20),
					Text(
					  'Hai, aku Fitri Herma Yanti (Fitri HY). Aku sangat antusias dalam pengembangan aplikasi dan web. Jika kamu memiliki proyek atau ide yang ingin dikembangkan, jangan ragu untuk berdiskusi denganku. Aku dan Tim siap membantu dan berbagi pengalaman dalam membangun solusi yang efektif dan berkualitas!',
					  style: TextStyle(
						fontSize: 14,
						color: Colors.white,
					  ),
					),
					SizedBox(height: 15),
					_buildReference('Situs', 'https://i-as.dev'),
					_buildReference('Dukungan & Kontak', 'mailto:noreply.orzpartners@gmail.com'),
				  ],
				),
			  ),
			),
          ],
        ),
      ),
    );
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildFeature(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.greenAccent,
            size: 22,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReference(String title, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        children: [
          Icon(
            Icons.link,
            color: Colors.white,
            size: 22,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                launchURL(url);
              },
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
