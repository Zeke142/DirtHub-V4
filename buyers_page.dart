import 'package:flutter/material.dart';

class BuyersPage extends StatelessWidget {
  const BuyersPage({super.key}); // Converted 'key' to a super parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buyers Page'),
      ),
      body: const Center(
        child: Text('This is the Buyers Page'),
      ),
    );
  }
}
