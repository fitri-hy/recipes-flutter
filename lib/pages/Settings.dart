import 'package:flutter/material.dart';
import 'Landing.dart';

class SettingsPage extends StatelessWidget {
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
			  'Pengaturan',
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                    fontSize: 16,
                  ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Aplikasi ini dirancang untuk memudahkan pengguna dalam menemukan dan mencoba berbagai resep masakan dari seluruh dunia. Dengan tampilan yang user-friendly dan fitur yang lengkap, aplikasi ini memungkinkan pengguna untuk mencari resep berdasarkan nama masakan yang mereka inginkan. Setiap resep dilengkapi dengan daftar bahan-bahan serta instruksi langkah demi langkah yang jelas dan mudah diikuti, sehingga pemula sekalipun dapat mencoba resep tersebut.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        color: Colors.blueGrey[600],
                      ),
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Fitur Aplikasi',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                    fontSize: 20,
                  ),
            ),
            SizedBox(height: 8),
			_buildFeature('Resep masakan dari berbagai daerah'),
			_buildFeature('Pencarian resep berdasarkan nama'),
			_buildFeature('Deskripsi resep dengan langkah-langkah'),
			_buildFeature('Deskripsi bahan dan cara pembuatan'),
			_buildFeature('Gambar resep yang menarik'),
			_buildFeature('Otomatis memperbaharui data'),
            SizedBox(height: 24),
            Text(
              'Changelog',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                    fontSize: 20,
                  ),
            ),
            SizedBox(height: 8),
            _buildFeature('Versi 1.0.0: Peluncuran'),
            SizedBox(height: 24),
			Text(
              'Developer',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                    fontSize: 20,
                  ),
            ),
            SizedBox(height: 8),
			Card(
			  elevation: 5,
			  shape: RoundedRectangleBorder(
				borderRadius: BorderRadius.circular(15),
			  ),
			  child: Container(
				padding: const EdgeInsets.all(16.0),
				decoration: BoxDecoration(
				  gradient: LinearGradient(
					colors: [Colors.blueAccent, Colors.blue],
					begin: Alignment.topLeft,
					end: Alignment.bottomRight,
				  ),
				  borderRadius: BorderRadius.circular(15),
				),
				child: Row(
				  children: [
					CircleAvatar(
					  radius: 40,
					  backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/155282015?v=4'),
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
						  Text(
							'https://github.com/fitri-hy',
							style: TextStyle(
							  fontSize: 14,
							  color: Colors.white,
							),
						  ),
						],
					  ),
					),
				  ],
				),
			  ),
			),
			SizedBox(height: 24),
          ],
        ),
      ),
    );
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
}
