import 'package:dlivremappv2/cart_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class RestaurantDetail extends StatefulWidget {
  @override
  _RestaurantDetailState createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  String _selectedCategory = "Popular";
  Map<int, int> _cartItems = {};

  final Map<String, dynamic> _restaurant = {
    "name": "Pizza Palace",
    "rating": 4.5,
    "reviews": 324,
    "deliveryTime": "25-30 min",
    "deliveryFee": "\$2.99",
    "address": "123 Food Street, Downtown",
    "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
  };

  final List<String> _categories = ["Popular", "Pizza", "Pasta", "Salads", "Desserts", "Drinks"];

  final List<Map<String, dynamic>> _menuItems = [
    {
      "id": 1,
      "name": "Margherita Pizza",
      "description": "Fresh tomatoes, mozzarella, basil, olive oil",
      "price": 14.99,
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "category": "Popular",
      "popular": true,
    },
    {
      "id": 2,
      "name": "Pepperoni Pizza",
      "description": "Pepperoni, mozzarella, tomato sauce",
      "price": 16.99,
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "category": "Popular",
      "popular": true,
    },
    {
      "id": 3,
      "name": "Caesar Salad",
      "description": "Romaine lettuce, parmesan, croutons, caesar dressing",
      "price": 9.99,
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "category": "Salads",
    },
    {
      "id": 4,
      "name": "Spaghetti Carbonara",
      "description": "Pasta with eggs, cheese, pancetta, black pepper",
      "price": 13.99,
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "category": "Pasta",
    },
  ];

  List<Map<String, dynamic>> get _filteredItems => _menuItems.where((item) {
        if (_selectedCategory == "Popular") return item["popular"] == true;
        return item["category"] == _selectedCategory;
      }).toList();

  void _addToCart(int itemId) {
    setState(() {
      _cartItems[itemId] = (_cartItems[itemId] ?? 0) + 1;
    });
  }

  void _removeFromCart(int itemId) {
    setState(() {
      _cartItems[itemId] = max((_cartItems[itemId] ?? 0) - 1, 0);
    });
  }

  int _getTotalItems() {
    return _cartItems.values.fold(0, (sum, count) => sum + count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Header Image
                Stack(
                  children: [
                    Image.network(
                      _restaurant["image"],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 30,
                      left: 16,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Positioned(
                      top: 30,
                      right: 16,
                      child: IconButton(
                        icon: Icon(Icons.favorite_border, color: Colors.black),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),

                // Restaurant Info
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _restaurant["name"],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow[700], size: 16),
                              Text(
                                "${_restaurant["rating"]}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(" (${_restaurant["reviews"]} reviews)",
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16),
                              SizedBox(width: 4),
                              Text(_restaurant["deliveryTime"], style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16),
                              SizedBox(width: 4),
                              Text(_restaurant["address"], style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                          Chip(
                            backgroundColor: Colors.grey[200],
                            label: Text(_restaurant["deliveryFee"]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Categories
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) {
                        return Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedCategory == category ? Colors.teal[600] : Colors.grey[200],
                              foregroundColor: _selectedCategory == category ? Colors.white : Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(category),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Menu Items
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: _filteredItems.map((item) {
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Image.network(
                                item["image"],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text("\$${item["price"].toStringAsFixed(2)}",
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    if (item["popular"] == true)
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: Chip(label: Text("Popular", style: TextStyle(fontSize: 12))),
                                      ),
                                    Text(item["description"], style: TextStyle(color: Colors.grey[600])),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        if (_cartItems[item["id"]] != null && _cartItems[item["id"]]! > 0)
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () => _removeFromCart(item["id"]),
                                              ),
                                              Text("${_cartItems[item["id"]]}"),
                                            ],
                                          ),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          color: Colors.teal[600],
                                          onPressed: () => _addToCart(item["id"]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Spacing for cart button
                SizedBox(height: 80),
              ],
            ),
          ),

          // Cart Button
          if (_getTotalItems() > 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text("View Cart (${_getTotalItems()} items)",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}