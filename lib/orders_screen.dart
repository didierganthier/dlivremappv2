import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _activeTab = "active";

  final List<Map<String, dynamic>> _activeOrders = [
    {
      "id": "ORD-001",
      "restaurant": "Pizza Palace",
      "restaurantImage": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "items": ["Margherita Pizza", "Caesar Salad"],
      "total": 24.98,
      "status": "on-the-way",
      "orderTime": "2:30 PM",
      "deliveryTime": "3:15 PM",
      "trackingSteps": [
        {"step": "Order confirmed", "completed": true, "time": "2:30 PM"},
        {"step": "Preparing your food", "completed": true, "time": "2:35 PM"},
        {"step": "Out for delivery", "completed": true, "time": "3:00 PM"},
        {"step": "Delivered", "completed": false},
      ],
    },
    {
      "id": "ORD-002",
      "restaurant": "Burger House",
      "restaurantImage": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "items": ["Classic Burger", "Fries", "Coke"],
      "total": 18.5,
      "status": "preparing",
      "orderTime": "3:00 PM",
      "deliveryTime": "3:45 PM",
      "trackingSteps": [
        {"step": "Order confirmed", "completed": true, "time": "3:00 PM"},
        {"step": "Preparing your food", "completed": true, "time": "3:05 PM"},
        {"step": "Out for delivery", "completed": false},
        {"step": "Delivered", "completed": false},
      ],
    },
  ];

  final List<Map<String, dynamic>> _orderHistory = [
    {
      "id": "ORD-003",
      "restaurant": "Sushi Express",
      "restaurantImage": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "items": ["California Roll", "Salmon Sashimi", "Miso Soup"],
      "total": 32.75,
      "status": "delivered",
      "orderTime": "Yesterday, 7:30 PM",
      "deliveryTime": "8:15 PM",
      "rating": 5,
    },
    {
      "id": "ORD-004",
      "restaurant": "Taco Fiesta",
      "restaurantImage": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "items": ["Beef Tacos (3)", "Guacamole", "Nachos"],
      "total": 19.25,
      "status": "delivered",
      "orderTime": "2 days ago, 1:15 PM",
      "deliveryTime": "1:45 PM",
      "rating": 4,
    },
    {
      "id": "ORD-005",
      "restaurant": "Healthy Bowls",
      "restaurantImage": "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "items": ["Quinoa Bowl", "Green Smoothie"],
      "total": 16.5,
      "status": "delivered",
      "orderTime": "3 days ago, 12:30 PM",
      "deliveryTime": "1:00 PM",
      "rating": 5,
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "preparing":
        return Colors.yellow[500]!;
      case "on-the-way":
        return Colors.blue[500]!;
      case "delivered":
        return Colors.green[500]!;
      case "cancelled":
        return Colors.red[500]!;
      default:
        return Colors.grey[500]!;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case "preparing":
        return "Preparing";
      case "on-the-way":
        return "On the way";
      case "delivered":
        return "Delivered";
      case "cancelled":
        return "Cancelled";
      default:
        return "Unknown";
    }
  }

  double _getTrackingProgress(List<Map<String, dynamic>> steps) {
    final completedSteps = steps.where((step) => step["completed"]).length;
    return (completedSteps / steps.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Text(
              "My Orders",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // Tabs
          Expanded(
            child: DefaultTabController(
              length: 2,
              initialIndex: _activeTab == "active" ? 0 : 1,
              child: Column(
                children: [
                  TabBar(
                    onTap: (index) {
                      setState(() {
                        _activeTab = index == 0 ? "active" : "history";
                      });
                    },
                    tabs: [
                      Tab(text: "Active Orders"),
                      Tab(text: "Order History"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Active Orders
                        _activeOrders.isEmpty
                            ? Card(
                                margin: EdgeInsets.all(16.0),
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.access_time, size: 32, color: Colors.grey[400]),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "No active orders",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "When you place an order, it will appear here",
                                        style: TextStyle(color: Colors.grey[600]),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.all(16.0),
                                itemCount: _activeOrders.length,
                                itemBuilder: (context, index) {
                                  final order = _activeOrders[index];
                                  return Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Image.network(
                                            order["restaurantImage"],
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                          title: Text(order["restaurant"]),
                                          subtitle: Text("Order #${order["id"]}"),
                                          trailing: Chip(
                                            backgroundColor: _getStatusColor(order["status"]),
                                            label: Text(
                                              _getStatusText(order["status"]),
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Items: ${order["items"].join(", ")}",
                                                  style: TextStyle(fontWeight: FontWeight.bold)),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Order Time: ${order["orderTime"]}"),
                                                  Text("\$${order["total"].toStringAsFixed(2)}",
                                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                              if (order["deliveryTime"] != null)
                                                Text(
                                                    "Expected delivery: ${order["deliveryTime"]}",
                                                    style: TextStyle(color: Colors.grey[600])),
                                              if (order["trackingSteps"] != null)
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 16),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("Order Progress",
                                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                                        // Text(
                                                        //     "${order["trackingSteps"].where((Map<String, dynamic> s) => s["completed"]).length} of ${order["trackingSteps"].length}",
                                                        //     style: TextStyle(color: Colors.grey[600])),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    LinearProgressIndicator(
                                                      value: _getTrackingProgress(order["trackingSteps"]) / 100,
                                                      backgroundColor: Colors.grey[300],
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[500]!),
                                                    ),
                                                    ...List.generate(order["trackingSteps"].length, (index) {
                                                      final step = order["trackingSteps"][index];
                                                      return Padding(
                                                        padding: EdgeInsets.only(top: 8.0),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 12,
                                                              height: 12,
                                                              decoration: BoxDecoration(
                                                                color: step["completed"]
                                                                    ? Colors.teal[500]
                                                                    : Colors.grey[300],
                                                                shape: BoxShape.circle,
                                                              ),
                                                            ),
                                                            SizedBox(width: 8),
                                                            Expanded(
                                                              child: Text(
                                                                step["step"],
                                                                style: TextStyle(
                                                                  color: step["completed"]
                                                                      ? Colors.black
                                                                      : Colors.grey[500],
                                                                ),
                                                              ),
                                                            ),
                                                            if (step["time"] != null)
                                                              Text(
                                                                step["time"],
                                                                style: TextStyle(color: Colors.grey[500]),
                                                              ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  OutlinedButton.icon(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.phone),
                                                    label: Text("Call Restaurant"),
                                                  ),
                                                  OutlinedButton.icon(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.message),
                                                    label: Text("Chat"),
                                                  ),
                                                  OutlinedButton.icon(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.location_on),
                                                    label: Text(""),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                        // Order History
                        ListView.builder(
                          padding: EdgeInsets.all(16.0),
                          itemCount: _orderHistory.length,
                          itemBuilder: (context, index) {
                            final order = _orderHistory[index];
                            return Card(
                              child: InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.network(
                                            order["restaurantImage"],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  order["restaurant"],
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  order["orderTime"],
                                                  style: TextStyle(color: Colors.grey[600]),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "\$${order["total"].toStringAsFixed(2)}",
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              Chip(
                                                backgroundColor: Colors.green[100],
                                                label: Text(
                                                  _getStatusText(order["status"]),
                                                  style: TextStyle(color: Colors.green[800]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16),
                                      Text("Items: ${order["items"].join(", ")}",
                                          style: TextStyle(color: Colors.grey[600])),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (order["rating"] != null)
                                            Row(
                                              children: [
                                                Icon(Icons.star, color: Colors.yellow[700], size: 16),
                                                Text("${order["rating"]}",
                                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          Row(
                                            children: [
                                              OutlinedButton(
                                                onPressed: () {},
                                                child: Text("Reorder"),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.more_horiz),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
          ),
        ],
      ),
    );
  }
}