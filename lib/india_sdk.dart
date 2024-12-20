import 'package:flutter/services.dart';

class IndiaSdk {
  static const MethodChannel _channel = MethodChannel('plugin_ccavenue');

  void pay({
    required Map<String, dynamic> options,
  }) async {
    try {
      final response = await _channel.invokeMethod("pay", options);
    } catch (e) {
      print(e);
    }
  }
}
