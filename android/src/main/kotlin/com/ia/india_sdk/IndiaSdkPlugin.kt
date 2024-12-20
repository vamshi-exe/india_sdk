//package com.ia.india_sdk
//
//import android.app.Activity
//import android.content.Context
//import io.flutter.embedding.engine.plugins.FlutterPlugin
//import io.flutter.embedding.engine.plugins.activity.ActivityAware
//import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
//import io.flutter.plugin.common.MethodCall
//import io.flutter.plugin.common.MethodChannel
//
//class IndiaSdkPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
//  private lateinit var channel: MethodChannel
//  private var activity: Activity? = null
//  private var context: Context? = null
//  private var ccIndiaDelegate: IndiaDelegate? = null
//
//  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//    channel = MethodChannel(binding.binaryMessenger, "plugin_ccavenue")
//    channel.setMethodCallHandler(this)
//  }
//
//  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
//    if (call.method == "pay") {
//      val arguments = call.arguments as? Map<String, Any>
//
//      if (arguments != null && activity != null && context != null) {
//        // Initialize delegate if not already initialized
//        if (ccIndiaDelegate == null) {
//          ccIndiaDelegate = IndiaDelegate(context!!, activity!!)
//        }
//
//        activity?.runOnUiThread {
//          ccIndiaDelegate?.initiateSdk(arguments, result)
//        }
//      } else {
//        result.error("INVALID_ARGUMENTS", "Activity or context is null", null)
//      }
//    } else {
//      result.notImplemented()
//    }
//  }
//
//  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
//    channel.setMethodCallHandler(null)
//  }
//
//  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
//    activity = binding.activity
//    context = binding.activity.applicationContext
//  }
//
//  override fun onDetachedFromActivity() {
//    activity = null
//    context = null
//  }
//
//  override fun onDetachedFromActivityForConfigChanges() {
//    activity = null
//  }
//
//  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
//    activity = binding.activity
//  }
//}

package com.ia.india_sdk

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class IndiaSdkPlugin : FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler {
  private lateinit var channel: MethodChannel
  private var activity: Activity? = null
  private var context: Context? = null
  private var indiaDelegate: IndiaDelegate? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "plugin_ccavenue")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "pay" -> {
        val arguments = call.arguments as? Map<String, Any>
        if (arguments != null && activity != null && context != null) {
          indiaDelegate = IndiaDelegate(
            context!!, activity!!
          )
          indiaDelegate?.initiateSdk(arguments, result)
        } else {
          result.error("INVALID_ARGUMENTS", "Activity or context is null", null)
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    context = binding.activity.applicationContext
  }

  override fun onDetachedFromActivity() {
    activity = null
    context = null
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    context = binding.activity.applicationContext
  }
}
