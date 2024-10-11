import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/sign_in_page.dart'; // Ensure this path is correct
import 'auth/sign_up_page.dart'; // Ensure this path is correct
import 'pages/home_page.dart'; // Ensure you have this page created
import 'pages/buyers_page.dart'; // Import BuyersPage
import 'pages/sellers_page.dart'; // Import SellersPage
import 'pages/transport_page.dart'; // Import TransportPage
import 'pages/location_picker_page.dart'; // Import LocationPickerPage
import 'config/firebase_options.dart'; // Import the generated Firebase options file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the Firebase options
  );
  runApp(const MyApp()); // Run your app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DirtHub',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login', // Set the initial route to the Sign In Page
      routes: {
        '/login': (context) => const SignInPage(), // Navigate to Sign In Page
        '/signup': (context) => const SignUpPage(), // Navigate to Sign Up Page
        '/home': (context) => const HomePage(), // Define your HomePage widget
        '/buyers': (context) => const BuyersPage(), // Navigate to Buyers Page
        '/sellers': (context) => const SellersPage(), // Navigate to Sellers Page
        '/transport': (context) => const TransportPage(), // Navigate to Transport Page
        '/location_picker': (context) => LocationPickerPage(
          onLocationSelected: (position) {
            // Handle the selected position here
            Navigator.of(context).pop(position); // Pass the selected position back to the previous page
          },
        ), // Navigate to Location Picker Page with onLocationSelected parameter
      },
    );
  }
}