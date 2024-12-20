
package com.ia.india_sdk;

import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.util.Pair;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.ccavenue.indiasdk.AvenueOrder;
import com.ccavenue.indiasdk.AvenuesApplication;
import com.ccavenue.indiasdk.AvenuesTransactionCallback;

import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

import io.flutter.plugin.common.MethodChannel;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;

public class IndiaDelegate extends AppCompatActivity implements AvenuesTransactionCallback {



    private static final String TAG = "IndiaDelegate";
    private final OkHttpClient client = new OkHttpClient();
    private final Executor backgroundExecutor = Executors.newSingleThreadExecutor();
    private final Handler handler = new Handler(Looper.getMainLooper());

    private static final MediaType JSON = MediaType.parse("application/x-www-form-urlencoded");

    private MethodChannel.Result flutterResult;
    private Context context;
    private Activity activity;

    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        context = getApplicationContext();
        activity = this;
    }

    public IndiaDelegate(Context context, Activity activity) {
        this.context = context;
        this.activity = activity;
    }

    public void initiateSdk(Map<String, Object> arguments, MethodChannel.Result result  ) {

        if (context == null) {
            Log.e(TAG, "Context is null. Attempting to recover.");

        }

        if (activity != null) {
            context = activity.getApplicationContext();
        }

        if (context == null) {
            Log.e(TAG, "Unable to obtain valid context");
            sendErrorResult("Invalid context: Cannot proceed with SDK initialization");
            return;
        }

        Log.d(TAG, "Initiating SDK with arguments: " + arguments);
        flutterResult = result;



        if (context == null || activity == null || activity.isFinishing() || activity.isDestroyed()) {
            sendErrorResult("Context or Activity is null or not in a valid state");
            return;
        }

        try {
            backgroundExecutor.execute(() -> {
                try {
                    String paymentDetails = createOrder(
                            arguments.get("amount").toString(),
                            arguments.get("order_id").toString(),
                            arguments.get("access_code").toString()
                    );

                    JSONObject jsonResponse = new JSONObject(paymentDetails);
                    String requestHash = jsonResponse.getString("requestHash");
                    String trackingId = jsonResponse.getString("trackingId");
                    Log.d(TAG, "Payment Details: " + paymentDetails);
                    Log.d(TAG, "Tracking ID: " + trackingId);
                    Log.d(TAG, "Request Hash: " + requestHash);

                    AvenueOrder orderDetails = new AvenueOrder();
                    orderDetails.setTrackingId(trackingId);
                    orderDetails.setOrderId(arguments.get("order_id").toString());
                    orderDetails.setRequestHash(requestHash);
                    orderDetails.setAccessCode(arguments.get("access_code").toString());
                    orderDetails.setMerchantId(arguments.get("mId").toString());
                    orderDetails.setCurrency("INR");
//                    orderDetails.setCommand("");
                    orderDetails.setPromoCode(arguments.get("promo").toString());
                    orderDetails.setAmount(arguments.get("amount").toString());
                    orderDetails.setCustomerId(arguments.get("customer_id").toString());
                    orderDetails.setPaymentType("all");
                    orderDetails.setDisplayPromo(arguments.get("display_promo").toString());
                    orderDetails.setMerchantLogo(arguments.get("company_logo").toString());
                    orderDetails.setBillingName(arguments.get("billing_name").toString());
                    orderDetails.setBillingAddress(arguments.get("billing_address").toString());
                    orderDetails.setBillingCountry(arguments.get("billing_country").toString());
                    orderDetails.setBillingState(arguments.get("billing_state").toString());
                    orderDetails.setBillingCity(arguments.get("billing_city").toString());
                    orderDetails.setBillingZip(arguments.get("billing_zip").toString());
                    orderDetails.setBillingTel(arguments.get("billing_telephone").toString());
                    orderDetails.setBillingEmail(arguments.get("billing_email").toString());
                    orderDetails.setDeliveryName(arguments.get("delivery_name").toString());
                    orderDetails.setDeliveryAddress(arguments.get("delivery_address").toString());
                    orderDetails.setDeliveryCountry(arguments.get("delivery_country").toString());
                    orderDetails.setDeliveryState(arguments.get("delivery_state").toString());
                    orderDetails.setDeliveryCity(arguments.get("delivery_city").toString());
                    orderDetails.setDeliveryZip(arguments.get("delivery_zip").toString());
                    orderDetails.setDeliveryTel(arguments.get("delivery_telephone").toString());
                    orderDetails.setPromoSkuCode(arguments.get("promoSkuCode").toString());
                    orderDetails.setSettingFeeCharged("");
                    orderDetails.setPaymentEnviroment("app_local");
                    orderDetails.setColorPrimary("#164880");
                    orderDetails.setColorAccent("#EB2226");
                    orderDetails.setColorFont("#FFFFFF");
                    orderDetails.setRedirectUrl(arguments.get("redirect_url").toString());
                    orderDetails.setCancelUrl(arguments.get("cancel_url").toString());

                    activity.runOnUiThread(() -> {
                        try {
                            AvenuesApplication.startTransaction(this, orderDetails);
                            Log.d(TAG, "Transaction started successfully");
                        } catch (Exception e) {
                            Log.e(TAG, "Failed to start transaction", e);
                            sendErrorResult("Failed to start transaction: " + e.getMessage());
                        }
                    });

                } catch (Exception e) {
                    Log.e(TAG, "Error in transaction process", e);
                    sendErrorResult("Transaction process failed: " + e.getMessage());
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "Error creating payment details", e);
            sendErrorResult("Invalid payment details: " + e.getMessage());
        }
    }

    public String createOrder(String amount, String orderId, String accessCode) throws IOException {
        String baseUrl = "https://qasecure.ccavenue.com/TransCcAvenue/createMerchantOrder";

        List<Pair<String, String>> params = new ArrayList<>();
        params.add(new Pair<>("currency", "INR"));
        params.add(new Pair<>("amount", amount));
        params.add(new Pair<>("accessCode", accessCode));
        params.add(new Pair<>("env", "app_local"));
        params.add(new Pair<>("orderId", orderId));
        params.add(new Pair<>("regId", "61116"));
        params.add(new Pair<>("merchantParam1", ""));
        params.add(new Pair<>("merchantParam2", ""));
        params.add(new Pair<>("merchantParam3", ""));
        params.add(new Pair<>("merchantParam4", ""));
        params.add(new Pair<>("merchantParam5", ""));
        params.add(new Pair<>("redirectUrl", "http://122.182.6.212:8080/MobPHPKit/india/ccav_resp_122705.php"));
        params.add(new Pair<>("cancelUrl", "http://122.182.6.212:8080/MobPHPKit/india/ccav_resp_122705.php"));
        params.add(new Pair<>("customerIdentifier", "728728728"));

        StringBuilder urlBuilder = new StringBuilder(baseUrl).append("?");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            urlBuilder.append(params.stream()
                    .map(p -> p.first + "=" + p.second)
                    .reduce((a, b) -> a + "&" + b)
                    .orElse(""));
        }

        Log.d(TAG, "URL Builder: " + urlBuilder);

        // Create the request
        Request request = new Request.Builder()
                .url(urlBuilder.toString())
                .post(RequestBody.create(JSON, ""))
                .build();

        // Execute the request
        try {
            return client.newCall(request).execute().body().string();
        } catch (IOException e) {
            e.printStackTrace();
            return "Error: " + e.getMessage();
        }
    }

    private void sendErrorResult(String errorMessage) {
        Log.e(TAG, "Error: " + errorMessage);
        handler.post(() -> {
            if (flutterResult != null) {
                flutterResult.error(TAG, errorMessage, null);
                flutterResult = null;
            } else {
                Log.e(TAG, "flutterResult is null, cannot send error");
            }
        });
    }



    @Override
    public void onTransactionResponse(Bundle bundle) {
        handler.post(() -> {
            try {
                JSONObject responseJson = new JSONObject();
                if (bundle != null) {
                    for (String key : bundle.keySet()) {
                        responseJson.put(key, bundle.get(key));
                    }
                }
                flutterResult.success(responseJson.toString());
                flutterResult = null;
            } catch (Exception e) {
                sendErrorResult("Transaction response processing failed: " + e.getMessage());
            }
        });
    }

    @Override
    public void onErrorOccurred(String errorMessage) {
        sendErrorResult(errorMessage != null ? errorMessage : "Unknown error occurred");
    }

    @Override
    public void onCancelTransaction(String cancelMessage) {
        sendErrorResult("Transaction cancelled: " + (cancelMessage != null ? cancelMessage : "User cancelled"));
    }
}

