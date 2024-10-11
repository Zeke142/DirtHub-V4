import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/buyers'); // Navigate to Buyers Page
              },
              child: const Text('Go to Buyers Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sellers'); // Navigate to Sellers Page
              },
              child: const Text('Go to Sellers Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/transport'); // Navigate to Transport Page
              },
              child: const Text('Go to Transport Page'),
            ),
          ],
        ),
      ),
    );
  }
}
