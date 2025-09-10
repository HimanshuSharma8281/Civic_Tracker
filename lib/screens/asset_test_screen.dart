import 'package:flutter/material.dart';

class AssetTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asset Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Testing Social Media Icons:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // Google Icon Test
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Google Icon:'),
                  SizedBox(height: 8),
                  Image.asset(
                    'assets/icons/google_icon.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        color: Colors.red.shade100,
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Facebook Icon Test
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Facebook Icon:'),
                  SizedBox(height: 8),
                  Image.asset(
                    'assets/icons/facebook_icon.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        color: Colors.red.shade100,
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Twitter Icon Test
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Twitter Icon:'),
                  SizedBox(height: 8),
                  Image.asset(
                    'assets/icons/twitter_icon.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 40,
                        height: 40,
                        color: Colors.red.shade100,
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            Text('Red boxes with error icons = Images not found',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
