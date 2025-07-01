import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {"name": "Pizza", "icon": "🍕", "color": Colors.orange[100]},
    {"name": "Burger", "icon": "🍔", "color": Colors.yellow[100]},
    {"name": "Sushi", "icon": "🍣", "color": Colors.pink[100]},
    {"name": "Pasta", "icon": "🍝", "color": Colors.red[100]},
    {"name": "Salad", "icon": "🥗", "color": Colors.green[100]},
    {"name": "Dessert", "icon": "🍰", "color": Colors.purple[100]},
  ];

  final List<Map<String, dynamic>> featuredRestaurants = [
    {
      "id": 1,
      "name": "Pizza Palace",
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "rating": 4.5,
      "deliveryTime": "25-30 min",
      "deliveryFee": "\$2.99",
      "category": "Italian",
      "distance": "1.2 km",
      "promoted": true,
    },
    {
      "id": 2,
      "name": "Burger House",
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "rating": 4.3,
      "deliveryTime": "20-25 min",
      "deliveryFee": "\$1.99",
      "category": "American",
      "distance": "0.8 km",
      "promoted": false,
    },
    {
      "id": 3,
      "name": "Sushi Express",
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "rating": 4.7,
      "deliveryTime": "30-35 min",
      "deliveryFee": "\$3.99",
      "category": "Japanese",
      "distance": "2.1 km",
      "promoted": false,
    },
    {
      "id": 4,
      "name": "Healthy Bowls",
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "rating": 4.6,
      "deliveryTime": "25-30 min",
      "deliveryFee": "Free",
      "category": "Healthy",
      "distance": "1.5 km",
      "promoted": false,
    },
  ];

  final List<Map<String, dynamic>> quickActions = [
    {"name": "Reorder", "icon": "🔄", "color": Colors.blue[100]},
    {"name": "Favorites", "icon": "❤️", "color": Colors.red[100]},
    {"name": "Offers", "icon": "🎉", "color": Colors.green[100]},
    {"name": "Track Order", "icon": "📍", "color": Colors.purple[100]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.teal[500],
              padding: EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Deliver to",
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                              Text(
                                "Home - 123 Main St",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite, color: Colors.white),
                            onPressed: () {},
                          ),
                          Stack(
                            children: [
                              IconButton(
                                icon: Icon(Icons.shopping_cart, color: Colors.white),
                                onPressed: () {},
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[500],
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                                  child: Text(
                                    "2",
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        hintText: "Search for restaurants or food",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
            ),

            // Quick Actions
            Padding(
              padding: EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: quickActions.map((action) {
                  return Card(
                    elevation: 0,
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: action["color"],
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Text(action["icon"], style: TextStyle(fontSize: 20))),
                          ),
                          SizedBox(height: 8),
                          Text(
                            action["name"],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Categories
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: categories.map((category) {
                      return Card(
                        elevation: 0,
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: category["color"],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(child: Text(category["icon"], style: TextStyle(fontSize: 24))),
                              ),
                              SizedBox(height: 8),
                              Text(
                                category["name"],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Featured Restaurants
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Featured Restaurants",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text("See all", style: TextStyle(color: Colors.teal[600])),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: featuredRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = featuredRestaurants[index];
                      return Card(
                        elevation: 0,
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Image.network(
                                    'http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg',
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                  if (restaurant["promoted"])
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      color: Colors.orange[500],
                                      child: Text(
                                        "Promoted",
                                        style: TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                      icon: Icon(Icons.favorite, color: Colors.grey[400]),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              restaurant["name"],
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              restaurant["category"],
                                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star, color: Colors.yellow[700], size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              "${restaurant["rating"]}",
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                            ),
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
                                            Text("${restaurant["deliveryTime"]}  "),
                                            Text("${restaurant["distance"]}"),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: restaurant["deliveryFee"] == "Free"
                                                ? Colors.teal[500]
                                                : Colors.grey[200],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            restaurant["deliveryFee"] == "Free"
                                                ? "Free delivery"
                                                : restaurant["deliveryFee"],
                                            style: TextStyle(
                                              color: restaurant["deliveryFee"] == "Free"
                                                  ? Colors.white
                                                  : Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
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
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}