import 'package:dlivremappv2/checkout_screen.dart';
import 'package:dlivremappv2/order_confirmation.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "Margherita Pizza",
      "price": 14.99,
      "quantity": 2,
      "image":
          "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "restaurant": "Pizza Palace",
    },
    {
      "id": 2,
      "name": "Caesar Salad",
      "price": 9.99,
      "quantity": 1,
      "image":
          "http://www.pagespro.ht/resources/cms_local/multi_upload/pubs_succursales/LA-VILLA-2019_1553441473.jpg",
      "restaurant": "Pizza Palace",
    },
  ];

  void _updateQuantity(int id, int newQuantity) {
    setState(() {
      if (newQuantity == 0) {
        _cartItems.removeWhere((item) => item["id"] == id);
      } else {
        _cartItems = _cartItems.map((item) {
          if (item["id"] == id) {
            return {...item, "quantity": newQuantity};
          }
          return item;
        }).toList();
      }
    });
  }

  double get _subtotal => _cartItems.fold(
    0,
    (sum, item) => sum + (item["price"] as num) * (item["quantity"] as num),
  );
  double get _deliveryFee => 2.99;
  double get _tax => _subtotal * 0.08;
  double get _total => _subtotal + _deliveryFee + _tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              // Header
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Your Cart",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Cart Items
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pizza Palace",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        ..._cartItems.map(
                          (item) => Column(
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    item["image"],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item["name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "\$${item["price"].toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color: Colors.teal[600],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () => _updateQuantity(
                                          item["id"],
                                          item["quantity"] - 1,
                                        ),
                                      ),
                                      Text(
                                        "${item["quantity"]}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () => _updateQuantity(
                                          item["id"],
                                          item["quantity"] + 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red[500],
                                    ),
                                    onPressed: () =>
                                        _updateQuantity(item["id"], 0),
                                  ),
                                ],
                              ),
                              if (item != _cartItems.last) Divider(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Delivery Address
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.teal[600]),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Delivery Address",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "123 Main St, Downtown",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Change",
                            style: TextStyle(color: Colors.teal[600]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Payment Method
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.credit_card, color: Colors.teal[600]),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Payment Method",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "**** **** **** 1234",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Change",
                            style: TextStyle(color: Colors.teal[600]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Order Summary
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order Summary",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Subtotal"),
                            Text("\$${(_subtotal).toStringAsFixed(2)}"),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Delivery Fee"),
                            Text("\$${(_deliveryFee).toStringAsFixed(2)}"),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tax"),
                            Text("\$${(_tax).toStringAsFixed(2)}"),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${(_total).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Spacing for fixed button
              SizedBox(height: 80),
            ],
          ),
        ),
      ),

      // Checkout Button
      bottomNavigationBar: _cartItems.isNotEmpty
          ? BottomAppBar(
              height: 120,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                          cartItems: _cartItems,
                          onBack: () => Navigator.pop(context),
                          onOrderConfirmation: (orderData) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderConfirmationScreen(
                                  orderData: orderData,
                                  onBackToHome: () => Navigator.pop(context),
                                ),
                              ),
                            ),
                          },
                        ), // Replace with your checkout screen
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[600],
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    "Proceed to Checkout - \$${(_total).toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
