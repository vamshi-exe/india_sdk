import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:india_sdk/india_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IndiaSdk();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _indiaSdkPlugin = IndiaSdk();

  Map<String, dynamic> _paymentStatus = {};
  int? orderId;
  TextEditingController amountController = TextEditingController();
  TextEditingController regIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  String generateRandomCode() {
    final random = Random();
    orderId = 10000000 + random.nextInt(90000000);
    print(orderId);
    return orderId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('India sdk Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: amountController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: regIdController,
                  ),
                ),
                // amountController.text.isNotEmpty
                //     ? Text("${double.parse(amountController.text)}")
                //     : Container(),
                ElevatedButton(
                  onPressed: () async {
                    generateRandomCode();
                    _indiaSdkPlugin.pay(
                      options: {
                        "mId": "61116",
                        'access_code': "AVYL41KJ55CA24LYAC",
                        'currency': "INR",
                        'amount':
                            double.parse(amountController.text).toString(),
                        'redirect_url': "",
                        //  "https://www.google.com",
                        // "http://122.182.6.212:8080/MobPHPKit/india/ccav_resp_122705.php",
                        'cancel_url': "",
                        // "https://www.google.com",
                        // "http://122.182.6.212:8080/MobPHPKit/india/ccav_resp_122705.php",
                        'order_id': "${orderId}",
                        //  "1234567",
                        'customer_id': "728728728",
                        "mobile_no": "7620237601",
                        'promo': "",
                        'display_promo': "Y",
                        'promoSkuCode': "",
                        'billing_name': "john",
                        'billing_address': "santacruz",
                        'billing_country': "india",
                        'billing_state': "maharashtra",
                        'billing_city': "mumbai",
                        'billing_telephone': "7620237601",
                        'billing_email': "mymail@gmail.com",
                        "billing_zip": "400054",
                        'company_logo': "",
                        'delivery_name': "john",
                        'delivery_address': "santacruz",
                        'delivery_country': "india",
                        'delivery_state': "maharashtra",
                        'delivery_city': "mumbai",
                        'delivery_zip': "400054",
                        'delivery_telephone': "7620237601",
                        'merchantParam1': "",
                        'merchantParam2': "",
                        'merchantParam3': "",
                        'merchantParam4': "",
                        'merchantParam5': "",
                        'siType': "",
                        'siRef': "",
                        'siSetupAmount': "",
                        'siAmount': "",
                        'siStartDate': "",
                        'siFreqType': "",
                        'siFreq': "",
                        'siBillCycle': "",
                        'display_address': "Y",
                      },
                    );
                  },
                  child: Text('Pay now'),
                ),
                // Text("${double.parse(amountController.text)}")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
