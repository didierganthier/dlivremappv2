import 'dart:async';

import 'package:dlivremappv2/order_confirmation.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final VoidCallback onBack;
  final Function(Map<String, dynamic>) onOrderConfirmation;

  CheckoutScreen({required this.cartItems, required this.onBack, required this.onOrderConfirmation});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedAddress = 1;
  int _selectedPayment = 1;
  String _deliveryOption = "delivery";
  String _deliveryInstructions = "";
  String _promoCode = "";
  bool _promoApplied = false;
  bool _isProcessing = false;
  bool _showAddAddress = false;
  bool _showAddPayment = false;

  Map<String, String> _newAddress = {
    "label": "",
    "street": "",
    "city": "",
    "state": "",
    "zipCode": "",
    "details": "",
  };

  Map<String, String> _newPayment = {
    "cardNumber": "",
    "expiryDate": "",
    "cvv": "",
    "cardholderName": "",
  };

  final List<Map<String, dynamic>> _addresses = [
    {
      "id": 1,
      "label": "Home",
      "address": "123 Main St, Downtown, NY 10001",
      "details": "Apartment 4B, Ring doorbell",
      "isDefault": true,
    },
    {
      "id": 2,
      "label": "Work",
      "address": "456 Business Ave, Midtown, NY 10002",
      "details": "Reception desk, ask for John",
      "isDefault": false,
    },
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      "id": 1,
      "type": "card",
      "name": "Visa •••• 1234",
      "details": "Expires 12/25",
      "isDefault": true,
    },
    {
      "id": 2,
      "type": "card",
      "name": "Mastercard •••• 5678",
      "details": "Expires 08/26",
      "isDefault": false,
    },
    {
      "id": 3,
      "type": "paypal",
      "name": "PayPal",
      "details": "john.doe@email.com",
      "isDefault": false,
    },
    {
      "id": 4,
      "type": "apple_pay",
      "name": "Apple Pay",
      "details": "Touch ID or Face ID",
      "isDefault": false,
    },
  ];

  String get _restaurant => widget.cartItems[0]["restaurant"] ?? "Restaurant";
  double get _subtotal => widget.cartItems.fold(0, (sum, item) => sum + (item["price"] as num) * (item["quantity"] as num));
  double get _deliveryFee => _deliveryOption == "delivery" ? 2.99 : 0;
  double get _serviceFee => _subtotal * 0.05;
  double get _tax => (_subtotal + _serviceFee) * 0.08;
  double get _promoDiscount => _promoApplied ? 5.0 : 0;
  double get _total => _subtotal + _deliveryFee + _serviceFee + _tax - _promoDiscount;

  void _handleApplyPromo() {
    if (_promoCode.toLowerCase() == "save5") {
      setState(() {
        _promoApplied = true;
      });
    }
  }

  Future<void> _handlePlaceOrder() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(Duration(seconds: 3));

    final orderData = {
      "id": "ORD-${DateTime.now().millisecondsSinceEpoch}",
      "restaurant": _restaurant,
      "items": widget.cartItems,
      "address": _addresses.firstWhere((a) => a["id"] == _selectedAddress),
      "paymentMethod": _paymentMethods.firstWhere((p) => p["id"] == _selectedPayment),
      "deliveryOption": _deliveryOption,
      "deliveryInstructions": _deliveryInstructions,
      "subtotal": _subtotal,
      "deliveryFee": _deliveryFee,
      "serviceFee": _serviceFee,
      "tax": _tax,
      "promoDiscount": _promoDiscount,
      "total": _total,
      "estimatedDelivery": _deliveryOption == "delivery" ? "25-30 min" : "15-20 min",
      "orderTime": DateTime.now().toLocal().toString().split(' ')[1],
    };

    widget.onOrderConfirmation(orderData);
    setState(() {
      _isProcessing = false;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OrderConfirmationScreen(orderData: orderData, onBackToHome: widget.onBack),
      ),
    );
  }

  Widget _getPaymentIcon(String type) {
    switch (type) {
      case "card":
        return Icon(Icons.credit_card, size: 20);
      case "paypal":
        return Icon(Icons.account_balance_wallet, size: 20);
      case "apple_pay":
      case "google_pay":
        return Icon(Icons.smartphone, size: 20);
      default:
        return Icon(Icons.credit_card, size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40.0,
          ),
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
                      onPressed: widget.onBack,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Checkout",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          
              // Content
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Options
                    Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Delivery Options",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            children: [
                              ListTile(
                                leading: Radio(
                                  value: "delivery",
                                  groupValue: _deliveryOption,
                                  onChanged: (value) {
                                    setState(() {
                                      _deliveryOption = value as String;
                                    });
                                  },
                                ),
                                title: Row(
                                  children: [
                                    Icon(Icons.local_shipping, color: Colors.teal[600]),
                                    SizedBox(width: 8),
                                    Text("Delivery"),
                                  ],
                                ),
                                subtitle: Text("25-30 min"),
                                trailing: Text("\$${_deliveryFee.toStringAsFixed(2)}"),
                                onTap: () {
                                  setState(() {
                                    _deliveryOption = "delivery";
                                  });
                                },
                              ),
                              ListTile(
                                leading: Radio(
                                  value: "pickup",
                                  groupValue: _deliveryOption,
                                  onChanged: (value) {
                                    setState(() {
                                      _deliveryOption = value as String;
                                    });
                                  },
                                ),
                                title: Row(
                                  children: [
                                    Icon(Icons.access_time, color: Colors.teal[600]),
                                    SizedBox(width: 8),
                                    Text("Pickup"),
                                  ],
                                ),
                                subtitle: Text("15-20 min"),
                                trailing: Text("Free", style: TextStyle(color: Colors.green[600])),
                                onTap: () {
                                  setState(() {
                                    _deliveryOption = "pickup";
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
          
                    // Delivery Address
                    if (_deliveryOption == "delivery")
                      Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delivery Address",
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showAddAddress = true;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.add),
                                        Text("Add New"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: _addresses.map((address) => ListTile(
                                      leading: Radio(
                                        value: address["id"],
                                        groupValue: _selectedAddress,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedAddress = value as int;
                                          });
                                        },
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(Icons.location_on, color: Colors.grey[400]),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(address["label"], style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                                    ),
                                                    if (address["isDefault"])
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 8.0),
                                                        child: Chip(
                                                          label: Text("Default", style: TextStyle(fontSize: 12)),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                Text(
                                                  address["address"],
                                                  style: TextStyle(color: Colors.grey[600]),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                if (address["details"] != null)
                                                  Text(
                                                    address["details"],
                                                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {},
                                      ),
                                    )).toList(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Delivery Instructions (Optional)",
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  TextField(
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      hintText: "Ring doorbell, leave at door, etc.",
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _deliveryInstructions = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
          
                    // Payment Method
                    Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Payment Method",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _showAddPayment = true;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.add),
                                      Text("Add New"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: _paymentMethods.map((method) => ListTile(
                                    leading: Radio(
                                      value: method["id"],
                                      groupValue: _selectedPayment,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedPayment = value as int;
                                        });
                                      },
                                    ),
                                    title: Row(
                                      children: [
                                        _getPaymentIcon(method["type"]),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(method["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                                                if (method["isDefault"])
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 8.0),
                                                    child: Chip(
                                                      label: Text("Default", style: TextStyle(fontSize: 12)),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Text(method["details"], style: TextStyle(color: Colors.grey[600])),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
          
                    // Order Summary
                    Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Order Summary",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                Text(
                                  _restaurant,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[900]),
                                ),
                                SizedBox(height: 16),
                                ...widget.cartItems.map((item) => Padding(
                                      padding: EdgeInsets.only(bottom: 16.0),
                                      child: Row(
                                        children: [
                                          Image.network(
                                            item["image"],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(item["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                                                if (item["customizations"] != null)
                                                  Text(
                                                    "${item["customizations"].values.join(", ")}",
                                                    style: TextStyle(color: Colors.grey[600]),
                                                  ),
                                                if (item["specialInstructions"] != null)
                                                  Text(
                                                    "Note: ${item["specialInstructions"]}",
                                                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "\$${(item["price"] * item["quantity"]).toStringAsFixed(2)}",
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              Text("Qty: ${item["quantity"]}",
                                                  style: TextStyle(color: Colors.grey[600])),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                                Divider(),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: "Enter promo code",
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _promoCode = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: _promoApplied ? null : _handleApplyPromo,
                                      child: Text("Apply"),
                                    ),
                                  ],
                                ),
                                if (_promoApplied)
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.check, color: Colors.green[600]),
                                        SizedBox(width: 8),
                                        Text("Promo code applied!", style: TextStyle(color: Colors.green[600])),
                                      ],
                                    ),
                                  ),
                                Divider(),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Subtotal"),
                                    Text("\$${_subtotal.toStringAsFixed(2)}"),
                                  ],
                                ),
                                if (_deliveryOption == "delivery")
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Delivery Fee"),
                                        Text("\$${_deliveryFee.toStringAsFixed(2)}"),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Service Fee"),
                                      Text("\$${_serviceFee.toStringAsFixed(2)}"),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Tax"),
                                      Text("\$${_tax.toStringAsFixed(2)}"),
                                    ],
                                  ),
                                ),
                                if (_promoApplied)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Promo Discount", style: TextStyle(color: Colors.green[600])),
                                        Text("\$-${_promoDiscount.toStringAsFixed(2)}",
                                            style: TextStyle(color: Colors.green[600])),
                                      ],
                                    ),
                                  ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text("\$${_total.toStringAsFixed(2)}",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
          
                    // Security Notice
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.grey[600]),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Your payment information is secure and encrypted",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Place Order Button
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isProcessing ? null : _handlePlaceOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[600],
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: _isProcessing
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text("Processing Payment...", style: TextStyle(color: Colors.white)),
                  ],
                )
              : Text("Place Order • \$${_total.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}