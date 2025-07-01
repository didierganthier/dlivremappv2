import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, bool> _notifications = {
    "orderUpdates": true,
    "promotions": false,
    "newRestaurants": true,
  };

  List<String> _splitCamelCase(String input) {
    return input.split(RegExp(r'(?=[A-Z])'));
  }

  final Map<String, dynamic> _userProfile = {
    "name": "John Doe",
    "email": "john.doe@email.com",
    "phone": "+1 (555) 123-4567",
    "avatar": "https://www.didierganthier.com/images/profile.jpg",
    "memberSince": "January 2023",
    "totalOrders": 47,
    "favoriteRestaurants": 12,
  };

  final List<Map<String, dynamic>> _savedAddresses = [
    {
      "id": 1,
      "label": "Home",
      "address": "123 Main St, Downtown, NY 10001",
      "isDefault": true,
    },
    {
      "id": 2,
      "label": "Work",
      "address": "456 Business Ave, Midtown, NY 10002",
      "isDefault": false,
    },
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      "id": 1,
      "type": "card",
      "last4": "1234",
      "brand": "Visa",
      "isDefault": true,
    },
    {
      "id": 2,
      "type": "card",
      "last4": "5678",
      "brand": "Mastercard",
      "isDefault": false,
    },
  ];

  final List<Map<String, dynamic>> _menuItems = [
    {
      "icon": Icons.star,
      "title": "Rate & Review",
      "subtitle": "Share your experience",
      "action": () {},
    },
    {
      "icon": Icons.favorite,
      "title": "Favorites",
      "subtitle": "Your saved restaurants",
      "action": () {},
    },
    {
      "icon": Icons.card_giftcard,
      "title": "Promotions",
      "subtitle": "Available offers & coupons",
      "badge": "3 new",
      "action": () {},
    },
    {
      "icon": Icons.notifications,
      "title": "Notifications",
      "subtitle": "Manage your preferences",
      "action": () {},
    },
    {
      "icon": Icons.shield,
      "title": "Privacy & Security",
      "subtitle": "Account security settings",
      "action": () {},
    },
    {
      "icon": Icons.help,
      "title": "Help & Support",
      "subtitle": "Get help or contact us",
      "action": () {},
    },
    {
      "icon": Icons.settings,
      "title": "App Settings",
      "subtitle": "Language, theme, and more",
      "action": () {},
    },
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
              padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0,),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Profile",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(Icons.settings, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // User Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundImage: NetworkImage(_userProfile["avatar"]),
                          child: _userProfile["avatar"] == null
                              ? Text(
                                  _userProfile["name"]
                                      .toString()
                                      .split(" ")
                                      .map((n) => n[0])
                                      .join("")
                                      .toUpperCase(),
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                )
                              : null,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _userProfile["name"].toString(),
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                _userProfile["email"].toString(),
                                style: TextStyle(color: Colors.teal[100], fontSize: 14),
                              ),
                              Text(
                                "Member since ${_userProfile["memberSince"]}",
                                style: TextStyle(color: Colors.teal[200], fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stats Cards
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            _userProfile["totalOrders"].toString(),
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal[600]),
                          ),
                          Text(
                            "Total Orders",
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            _userProfile["favoriteRestaurants"].toString(),
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal[600]),
                          ),
                          Text(
                            "Favorites",
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Saved Addresses
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text("Saved Addresses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    trailing: TextButton(
                      onPressed: () {},
                      child: Text("Add New", style: TextStyle(color: Colors.teal[600])),
                    ),
                  ),
                  ..._savedAddresses.map((address) => ListTile(
                        leading: Icon(Icons.location_on, color: Colors.grey[400]),
                        title: Row(
                          children: [
                            Text(address["label"].toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                            if (address["isDefault"]) ...[
                              SizedBox(width: 8),
                              Chip(label: Text("Default", style: TextStyle(fontSize: 12))),
                            ],
                          ],
                        ),
                        subtitle: Text(address["address"].toString()),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {},
                      )),
                ],
              ),
            ),

            // Payment Methods
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text("Payment Methods", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    trailing: TextButton(
                      onPressed: () {},
                      child: Text("Add New", style: TextStyle(color: Colors.teal[600])),
                    ),
                  ),
                  ..._paymentMethods.map((method) => ListTile(
                        leading: Icon(Icons.credit_card, color: Colors.grey[400]),
                        title: Row(
                          children: [
                            Text("${method["brand"]} •••• ${method["last4"]}",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            if (method["isDefault"]) ...[
                              SizedBox(width: 8),
                              Chip(label: Text("Default", style: TextStyle(fontSize: 12))),
                            ],
                          ],
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {},
                      )),
                ],
              ),
            ),

            // Notification Preferences
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text("Notification Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ..._notifications.keys.map((key) => SwitchListTile(
                        title: Text(
                          _splitCamelCase(key)
                              .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
                              .join(" "),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Get notified about your ${key.toLowerCase().replaceAll("updates", "status")}"),
                        value: _notifications[key]!,
                        onChanged: (value) {
                          setState(() {
                            _notifications[key] = value;
                          });
                        },
                      )),
                ],
              ),
            ),

            // Menu Items
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: _menuItems.map((item) => ListTile(
                      leading: Icon(item["icon"], color: Colors.grey[400]),
                      title: Text(item["title"], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(item["subtitle"]),
                      trailing: item["badge"] != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Chip(label: Text(item["badge"], style: TextStyle(fontSize: 12))),
                                Icon(Icons.chevron_right, color: Colors.grey[400]),
                              ],
                            )
                          : Icon(Icons.chevron_right, color: Colors.grey[400]),
                      onTap: item["action"],
                    )).toList(),
              ),
            ),

            // Sign Out
            Card(
              margin: EdgeInsets.all(16.0),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red[600]),
                title: Text("Sign Out", style: TextStyle(color: Colors.red[600])),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}