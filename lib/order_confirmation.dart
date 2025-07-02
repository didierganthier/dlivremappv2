import 'dart:async';

import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic>? orderData;
  final VoidCallback onBackToHome;

  OrderConfirmationScreen({this.orderData, required this.onBackToHome});

  @override
  _OrderConfirmationScreenState createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  double _trackingProgress = 25;
  int _currentStep = 1;

  final List<Map<String, dynamic>> _trackingSteps = [
    {"step": "Order confirmed", "completed": true, "time": null},
    {"step": "Preparing your food", "completed": false, "time": null},
    {"step": null, "completed": false, "time": null}, // Will be updated based on deliveryOption
    {"step": null, "completed": false, "time": null}, // Will be updated based on deliveryOption
  ];

  @override
  void initState() {
    super.initState();
    // Update tracking steps based on delivery option
    final deliveryOption = widget.orderData?["deliveryOption"] ?? "delivery";
    _trackingSteps[2]["step"] = deliveryOption == "delivery" ? "Out for delivery" : "Ready for pickup";
    _trackingSteps[3]["step"] = deliveryOption == "delivery" ? "Delivered" : "Picked up";
    _trackingSteps[1]["time"] = widget.orderData?["orderTime"] ?? "02:22 PM";

    // Simulate order progress
    _startProgressSimulation();
  }

  Timer? _timer;

  void _startProgressSimulation() {
    const interval = Duration(seconds: 2);
    _timer = Timer.periodic(interval, (timer) {
      setState(() {
        if (_trackingProgress >= 100) {
          _trackingProgress = 100;
          timer.cancel();
        } else {
          _trackingProgress += 5;
        }
      });
      _updateSteps();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateSteps() {
    if (_trackingProgress >= 50 && _currentStep == 1) {
      setState(() {
        _currentStep = 2;
        _trackingSteps[1]["completed"] = true;
      });
    } else if (_trackingProgress >= 75 && _currentStep == 2) {
      setState(() {
        _currentStep = 3;
        _trackingSteps[2]["completed"] = true;
      });
    } else if (_trackingProgress >= 100 && _currentStep == 3) {
      setState(() {
        _currentStep = 4;
        _trackingSteps[3]["completed"] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orderData == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "No order data found",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: widget.onBackToHome,
                child: Text("Back to Home"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 100.0
          ),
          child: Column(
            children: [
              // Success Header
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal[500]!, Colors.teal[600]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  border: Border.all(color: Colors.teal[700]!, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, size: 32, color: Colors.teal[600]),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Order Confirmed!",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Your order has been placed successfully",
                      style: TextStyle(color: Colors.teal[100]),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text("Order ID", style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                          Text(
                            widget.orderData?["id"] ?? "",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
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
                    // Order Tracking
                    Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order Status",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Chip(
                                  backgroundColor: Colors.teal[600],
                                  label: Text(
                                    (widget.orderData?["deliveryOption"] == "delivery") ? "Delivery" : "Pickup",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Estimated ${(widget.orderData?["deliveryOption"] == "delivery") ? "delivery" : "pickup"}",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.orderData?["estimatedDelivery"] ?? "",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: _trackingProgress / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[500]!),
                                ),
                                SizedBox(height: 16),
                                ...List.generate(_trackingSteps.length, (index) {
                                  final step = _trackingSteps[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 16,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: step["completed"]
                                                ? Colors.teal[500]
                                                : index == _currentStep
                                                    ? Colors.teal[300]
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
                                                  : index == _currentStep
                                                      ? Colors.teal[600]
                                                      : Colors.grey[500],
                                              fontWeight: step["completed"] || index == _currentStep
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        if (step["time"] != null)
                                          Text(
                                            step["time"],
                                            style: TextStyle(color: Colors.grey[500]),
                                          ),
                                        if (step["completed"]) Icon(Icons.check, color: Colors.teal[500]),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
          
                    // Restaurant Info
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.orderData?["restaurant"],
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.phone),
                                      label: Text("Call"),
                                    ),
                                    SizedBox(width: 8),
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.message),
                                      label: Text("Chat"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (widget.orderData?["deliveryOption"] == "delivery" &&
                                widget.orderData?["address"] != null)
                              Padding(
                                padding: EdgeInsets.only(top: 16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.location_on, color: Colors.teal[600]),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.orderData?["address"]["label"],
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(widget.orderData?["address"]["address"]),
                                          if (widget.orderData?["deliveryInstructions"] != null)
                                            Text(
                                              "Instructions: ${widget.orderData?["deliveryInstructions"]}",
                                              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
          
                    // Order Details
                    Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Order Details",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                ...List.generate(widget.orderData?["items"].length, (index) {
                                  final item = widget.orderData?["items"][index];
                                  return Padding(
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
                                  );
                                }),
                                Divider(),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Subtotal"),
                                    Text("\$${widget.orderData?["subtotal"].toStringAsFixed(2)}"),
                                  ],
                                ),
                                SizedBox(height: 8),
                                if (widget.orderData?["deliveryFee"] > 0)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Delivery Fee"),
                                      Text("\$${widget.orderData?["deliveryFee"].toStringAsFixed(2)}"),
                                    ],
                                  ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Service Fee"),
                                    Text("\$${widget.orderData?["serviceFee"].toStringAsFixed(2)}"),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Tax"),
                                    Text("\$${widget.orderData?["tax"].toStringAsFixed(2)}"),
                                  ],
                                ),
                                SizedBox(height: 8),
                                if (widget.orderData?["promoDiscount"] > 0)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Promo Discount", style: TextStyle(color: Colors.green[600])),
                                      Text(
                                        "-\$${widget.orderData?["promoDiscount"].toStringAsFixed(2)}",
                                        style: TextStyle(color: Colors.green[600]),
                                      ),
                                    ],
                                  ),
                                Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Paid", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text(
                                      "\$${widget.orderData?["total"].toStringAsFixed(2)}",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Paid with", style: TextStyle(color: Colors.grey[600])),
                                    Text(widget.orderData?["paymentMethod"]["name"],
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
          
                    // Quick Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Card(
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.star, color: Colors.yellow[700], size: 24),
                                    SizedBox(height: 8),
                                    Text("Rate Order", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Share your experience",
                                        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Card(
                            child: InkWell(
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.arrow_forward, color: Colors.teal[600], size: 24),
                                    SizedBox(height: 8),
                                    Text("Reorder", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Order again",
                                        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          
                    // Continue Shopping
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: widget.onBackToHome,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, side: BorderSide(color: Colors.grey)),
                        child: Text("Continue Shopping"),
                      ),
                    ),
          
                    // Help Section
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "Need Help?",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "If you have any issues with your order, our support team is here to help.",
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: () {},
                              child: Text("Contact Support"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}