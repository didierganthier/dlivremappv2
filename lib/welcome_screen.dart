

import 'package:dlivremappv2/main_navigation.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[500]!, Colors.teal[600]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo/Emoji Section
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.teal[100],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('🍕', style: TextStyle(fontSize: 48)),
                      ),
                    ),
                    SizedBox(height: 32),
                    // Title Section
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                    Text(
                      'D-LIVREM',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Discover the best food & drinks from local restaurants delivered to your door',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 32),
                    // Buttons Section
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainNavigation(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[600],
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 48),
                          ),
                          child: Text(
                            'Get Started',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 48),
                            side: BorderSide(color: Colors.grey),
                          ),
                          child: Text(
                            'I already have an account',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainNavigation(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(double.infinity, 48),
                            foregroundColor: Colors.teal[600],
                          ),
                          child: Text(
                            'Just Explore',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
