import 'package:flutter/material.dart';

class SellersPage extends StatelessWidget {
  const SellersPage({super.key}); // Converted 'key' to a super parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sellers Page'),
      ),
      body: const Center(
        child: Text('This is the Sellers Page'),
      ),
    );
  }
}
