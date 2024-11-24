package com.ia.india_sdk_plugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.ccavenue.indiasdk.AvenueOrder
import com.ccavenue.indiasdk.AvenuesApplication
import com.ccavenue.indiasdk.AvenuesTransactionCallback
import com.example.india_sdk.CustomModel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import okhttp3.MediaType
import okhttp3.OkHttpClient
import org.json.JSONObject


class IndiaDelegate(private val context: Context,
                    private val activity: Activity
): AppCompatActivity(),AvenuesTransactionCallback, CustomModel.OnCustomStateListener {
    private val TAG = "IndiaDelegate"
    private val client = OkHttpClient()
//    private val  AvenueOrder = orderDetails()
companion object {
    var orderDetails: AvenueOrder? = null
}

    private val handler = Handler(Looper.getMainLooper())
    val JSON: MediaType = MediaType.parse("application/json; charset=utf-8")!!

    private var flutterResult: MethodChannel.Result? = null
    private val coroutineScope = CoroutineScope(Dispatchers.Main + Job())

    fun initiateSdk(arguments: Map<String?, Any>, result: MethodChannel.Result) {
        Log.d(TAG, "Initiating SDK with arguments: $arguments")
        flutterResult = result
        CustomModel.getInstance().setListener(this)

        try{
            orderDetails = AvenueOrder()
            orderDetails!!.trackingId = arguments["TrackingID"].toString()
            orderDetails!!.orderId = arguments["TrackingID"].toString()
            orderDetails!!.setRequestHash(arguments["RequestHash"].toString())
            orderDetails!!.accessCode = "AVYL41KJ55CA24LYAC"
            orderDetails!!.merchantId = "61116"


            //                orderDetails.setAccessCode("AVCW68EA99CK31WCKC"); // do not change
//                orderDetails.setMerchantId("122705"); // do not change
            orderDetails!!.currency = "INR"
            orderDetails!!.amount = arguments["Amount"].toString()


            // orderDetails.setAccessCode("AVST38JJ98AO27TSOA"); //do not change
            // orderDetails.setMerchantId("1305298"); // do not change
            orderDetails!!.customerId = ""
            orderDetails!!.paymentType = "all"
            orderDetails!!.merchantLogo = "company_logo"
            orderDetails!!.billingName = "billingname"
            orderDetails!!.billingAddress = "billingaddress,adddr"
            orderDetails!!.billingCountry = "billingcountry"
            orderDetails!!.billingState = "billingstate"
            orderDetails!!.billingCity = "billingcity"
            orderDetails!!.billingZip = "411021"
            orderDetails!!.billingTel = "8908976299"
            orderDetails!!.billingEmail = "manoranjan.nayak@avenues.info"
            orderDetails!!.deliveryName = "deliveryname"
            orderDetails!!.deliveryAddress = "deliveryaddress,yuyu"
            orderDetails!!.deliveryCountry = "deliverycountry"
            orderDetails!!.deliveryState = "deliverystate"
            orderDetails!!.deliveryCity = "deliverycity"
            orderDetails!!.deliveryZip = "411021"
            orderDetails!!.deliveryTel = "8908976299"
            orderDetails!!.paymentEnviroment = "app_local"
            orderDetails!!.colorPrimary = "#164880"
            orderDetails!!.colorAccent = "#EB2226"
            orderDetails!!.colorFont = "#FFFFFF"
            orderDetails!!.redirectUrl =
                "http://122.182.6.212:8080/MobPHPKit/india/ccav_resp_122705.php"
            orderDetails!!.cancelUrl =
                "http://122.182.6.212:8080/MobPHPKit/india/ccav_resp_122705.php"

//            Intent()

            AvenuesApplication.startTransaction(activity, orderDetails)
        } catch (e: Exception){
            Log.e(TAG, "Error creating payment details", e)
            sendErrorResult("Invalid payment details: ${e.message}")
        }

    }

    private fun sendErrorResult(errorMessage: String) {
        Log.e(TAG, "Payment Error: $errorMessage")
        handler.post {
            try {
                val errorResponse = JSONObject().apply {
                    put("status", "error")
                    put("message", errorMessage)

                }.toString()
                flutterResult?.error(TAG,errorMessage,errorResponse)
//                success(errorResponse)
            } catch (e: Exception) {
                flutterResult?.error(TAG, errorMessage, e)
            }
        }
    }

    override fun onTransactionResponse(p0: Bundle?) {
        TODO("Not yet implemented")
    }

    override fun onErrorOccurred(p0: String?) {
        TODO("Not yet implemented")
    }

    override fun onCancelTransaction(p0: String?) {
        TODO("Not yet implemented")
    }

    override fun stateChanged() {
        TODO("Not yet implemented")
    }
}