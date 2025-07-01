import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;
  Map<String, dynamic> _activeFilters = {
    "cuisine": <String>[],
    "priceRange": [1, 4],
    "rating": 0.0,
    "deliveryTime": 60,
    "sortBy": "relevance",
    "openNow": false,
    "freeDelivery": false,
  };

  List<Map<String, dynamic>> _searchResults = [];
  final List<String> _recentSearches = ["Pizza", "Burger", "Sushi", "Italian", "Chinese"];
  final List<String> _popularSearches = ["Pizza near me", "Fast food", "Healthy options", "Desserts", "Coffee"];

  final List<String> _cuisineTypes = [
    "Italian",
    "Chinese",
    "Mexican",
    "Indian",
    "Japanese",
    "American",
    "Thai",
    "Mediterranean",
    "Korean",
    "Vietnamese",
    "Greek",
    "Lebanese",
  ];

  final List<Map<String, dynamic>> _mockRestaurants = [
    {
      "id": 1,
      "name": "Pizza Palace",
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "rating": 4.5,
      "reviews": 324,
      "deliveryTime": "25-30 min",
      "deliveryFee": 2.99,
      "cuisine": ["Italian", "Pizza"],
      "priceRange": 2,
      "distance": 1.2,
      "isOpen": true,
      "promoted": true,
    },
    {
      "id": 2,
      "name": "Burger House",
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "rating": 4.3,
      "reviews": 256,
      "deliveryTime": "20-25 min",
      "deliveryFee": 1.99,
      "cuisine": ["American", "Burgers"],
      "priceRange": 2,
      "distance": 0.8,
      "isOpen": true,
    },
    {
      "id": 3,
      "name": "Sushi Express",
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "rating": 4.7,
      "reviews": 189,
      "deliveryTime": "30-35 min",
      "deliveryFee": 3.99,
      "cuisine": ["Japanese", "Sushi"],
      "priceRange": 3,
      "distance": 2.1,
      "isOpen": false,
    },
    {
      "id": 4,
      "name": "Taco Fiesta",
      "image": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "rating": 4.2,
      "reviews": 412,
      "deliveryTime": "15-20 min",
      "deliveryFee": 0.0,
      "cuisine": ["Mexican", "Tacos"],
      "priceRange": 1,
      "distance": 0.5,
      "isOpen": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateSearchResults();
  }

  void _updateSearchResults() {
    final query = _searchController.text.toLowerCase();
    List<Map<String, dynamic>> filtered = _mockRestaurants.where((restaurant) {
      final matchesSearch = query.isEmpty ||
          restaurant["name"].toLowerCase().contains(query) ||
          (restaurant["cuisine"] as List).any((c) => c.toLowerCase().contains(query));

      final matchesCuisine = (_activeFilters["cuisine"] as List).isEmpty ||
          (restaurant["cuisine"] as List).any((c) => _activeFilters["cuisine"].contains(c));

      final matchesPrice = restaurant["priceRange"] >= (_activeFilters["priceRange"] as List)[0] &&
          restaurant["priceRange"] <= (_activeFilters["priceRange"] as List)[1];

      final matchesRating = restaurant["rating"] >= _activeFilters["rating"];

      final maxDeliveryTimeStr = restaurant["deliveryTime"].toString().split("-")[1].trim().split(" ")[0];
      final maxDeliveryTime = int.parse(maxDeliveryTimeStr);
      final matchesDeliveryTime = maxDeliveryTime <= _activeFilters["deliveryTime"];

      final matchesOpenNow = !_activeFilters["openNow"] || restaurant["isOpen"];
      final matchesFreeDelivery = !_activeFilters["freeDelivery"] || restaurant["deliveryFee"] == 0;

      return matchesSearch &&
          matchesCuisine &&
          matchesPrice &&
          matchesRating &&
          matchesDeliveryTime &&
          matchesOpenNow &&
          matchesFreeDelivery;
    }).toList();

    switch (_activeFilters["sortBy"]) {
      case "rating":
        filtered.sort((a, b) => (b["rating"] as num).compareTo(a["rating"] as num));
        break;
      case "deliveryTime":
        filtered.sort((a, b) => int.parse(a["deliveryTime"].toString().split("-")[0].trim()).compareTo(
            int.parse(b["deliveryTime"].toString().split("-")[0].trim())));
        break;
      case "distance":
        filtered.sort((a, b) => (a["distance"] as num).compareTo(b["distance"] as num));
        break;
      case "deliveryFee":
        filtered.sort((a, b) => (a["deliveryFee"] as num).compareTo(b["deliveryFee"] as num));
        break;
      default:
        filtered.sort((a, b) {
          if ((a["promoted"] ?? false) && !(b["promoted"] ?? false)) return -1;
          if (!(a["promoted"] ?? false) && (b["promoted"] ?? false)) return 1;
          return (b["rating"] as num).compareTo(a["rating"] as num);
        });
    }

    setState(() {
      _searchResults = filtered;
    });
  }

  void _updateFilter(String key, dynamic value) {
    setState(() {
      _activeFilters[key] = value;
    });
    _updateSearchResults();
  }

  void _toggleCuisine(String cuisine) {
    setState(() {
      final cuisines = List<String>.from(_activeFilters["cuisine"] as List);
      if (cuisines.contains(cuisine)) {
        cuisines.remove(cuisine);
      } else {
        cuisines.add(cuisine);
      }
      _activeFilters["cuisine"] = cuisines;
    });
    _updateSearchResults();
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters = {
        "cuisine": <String>[],
        "priceRange": [1, 4],
        "rating": 0.0,
        "deliveryTime": 60,
        "sortBy": "relevance",
        "openNow": false,
        "freeDelivery": false,
      };
    });
    _updateSearchResults();
  }

  int _getActiveFilterCount() {
    int count = 0;
    if ((_activeFilters["cuisine"] as List).isNotEmpty) count++;
    if ((_activeFilters["priceRange"] as List)[0] > 1 || (_activeFilters["priceRange"] as List)[1] < 4) count++;
    if (_activeFilters["rating"] > 0) count++;
    if (_activeFilters["deliveryTime"] < 60) count++;
    if (_activeFilters["openNow"]) count++;
    if (_activeFilters["freeDelivery"]) count++;
    return count;
  }

  String _getPriceSymbol(int priceRange) {
    return "\$" * priceRange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 50.0, // Adjust for the status bar height
        ),
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[400]),
                              onPressed: () {
                                _searchController.clear();
                                _updateSearchResults();
                              },
                            )
                          : null,
                      hintText: "Search restaurants, cuisines, dishes...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                    ),
                    onChanged: (value) => _updateSearchResults(),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showFilters = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          side: BorderSide(color: Colors.grey[400]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.filter_list, color: Colors.grey[600]),
                            SizedBox(width: 8),
                            Text("Filters"),
                            if (_getActiveFilterCount() > 0)
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.grey[300],
                                  child: Text(
                                    _getActiveFilterCount().toString(),
                                    style: TextStyle(fontSize: 10, color: Colors.black),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Active Filter Chips (simplified)
                      if ((_activeFilters["cuisine"] as List).isNotEmpty)
                        Row(
                          children: (_activeFilters["cuisine"] as List).map<Widget>((cuisine) {
                            return Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Chip(
                                label: Text(cuisine),
                                onDeleted: () => _toggleCuisine(cuisine),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
        
            // Filter Sheet (Bottom Sheet instead of Sheet)
            if (_showFilters)
              DraggableScrollableSheet(
                initialChildSize: 0.8,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    color: Colors.white,
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.all(16.0),
                      children: [
                        Text(
                          "Filters",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
        
                        // Sort By
                        Text("Sort By", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          value: _activeFilters["sortBy"],
                          items: [
                            "relevance",
                            "rating",
                            "deliveryTime",
                            "distance",
                            "deliveryFee",
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value[0].toUpperCase() + value.substring(1)),
                            );
                          }).toList(),
                          onChanged: (value) => _updateFilter("sortBy", value),
                        ),
                        SizedBox(height: 16),
        
                        // Cuisine Types
                        Text("Cuisine", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: 8,
                          children: _cuisineTypes.map((cuisine) {
                            return FilterChip(
                              label: Text(cuisine),
                              selected: (_activeFilters["cuisine"] as List).contains(cuisine),
                              onSelected: (selected) => _toggleCuisine(cuisine),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16),
        
                        // Price Range
                        Text("Price Range", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Slider(
                          value: (_activeFilters["priceRange"] as List)[0].toDouble(),
                          min: 1,
                          max: 4,
                          divisions: 3,
                          label: _getPriceSymbol((_activeFilters["priceRange"] as List)[0]).toString(),
                          onChanged: (value) {
                            _updateFilter("priceRange", [value.toInt(), (_activeFilters["priceRange"] as List)[1]]);
                          },
                        ),
                        SizedBox(height: 16),
        
                        // Rating
                        Text("Minimum Rating", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Column(
                          children: [4.5, 4.0, 3.5, 3.0, 0.0].map((rating) {
                            return RadioListTile<double>(
                              title: Row(
                                children: [
                                  if (rating > 0) Icon(Icons.star, color: Colors.yellow[700], size: 16),
                                  Text(rating > 0 ? "$rating+" : "Any rating"),
                                ],
                              ),
                              value: rating,
                              groupValue: _activeFilters["rating"],
                              onChanged: (value) => _updateFilter("rating", value),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16),
        
                        // Quick Filters
                        Text("Quick Filters", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        CheckboxListTile(
                          title: Text("Open now"),
                          value: _activeFilters["openNow"],
                          onChanged: (value) => _updateFilter("openNow", value),
                        ),
                        CheckboxListTile(
                          title: Text("Free delivery"),
                          value: _activeFilters["freeDelivery"],
                          onChanged: (value) => _updateFilter("freeDelivery", value),
                        ),
                        SizedBox(height: 16),
        
                        // Filter Actions
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _clearAllFilters,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                                child: Text("Clear All"),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _showFilters = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[600]),
                                child: Text("Apply Filters"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
        
            // Search Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: _searchController.text.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Recent Searches", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Wrap(
                            spacing: 8,
                            children: _recentSearches.map((search) {
                              return OutlinedButton(
                                onPressed: () {
                                  _searchController.text = search;
                                  _updateSearchResults();
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.access_time, size: 16),
                                    SizedBox(width: 4),
                                    Text(search),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                          Text("Popular Searches", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Wrap(
                            spacing: 8,
                            children: _popularSearches.map((search) {
                              return OutlinedButton(
                                onPressed: () {
                                  _searchController.text = search;
                                  _updateSearchResults();
                                },
                                child: Text(search),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${_searchResults.length} results for \"${_searchController.text}\"",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final restaurant = _searchResults[index];
                              return Card(
                                child: InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          Image.network(
                                            restaurant["image"],
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                          if (restaurant["promoted"] == true)
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              color: Colors.orange[500],
                                              child: Text(
                                                "Promoted",
                                                style: TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                            ),
                                          if (!restaurant["isOpen"])
                                            Container(
                                              width: 120,
                                              height: 120,
                                              color: Colors.black45,
                                              child: Center(
                                                child: Text(
                                                  "Closed",
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0),
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
                                                        (restaurant["cuisine"] as List).join(", "),
                                                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.star, color: Colors.yellow[700], size: 16),
                                                      Text("${restaurant["rating"]}", style: TextStyle(fontSize: 12)),
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
                                                      Text("${restaurant["distance"]} km"),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: restaurant["deliveryFee"] == 0
                                                          ? Colors.teal[500]
                                                          : Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      restaurant["deliveryFee"] == 0
                                                          ? "Free delivery"
                                                          : "\$${restaurant["deliveryFee"].toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        color: restaurant["deliveryFee"] == 0
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
            ),
          ],
        ),
      ),
    );
  }
}