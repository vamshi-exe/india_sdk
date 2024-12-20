//  CCIndiaDelegate.swift
//  Pods
//
//  Created by Vamshi Vadnala on 19/12/24.
//

import Foundation
import UIKit
import CCAvenueSDK
import Flutter

class CCIndiaDelegate: NSObject, MainViewControllerDelegate {
    private let TAG = "CCIndiaDelegate"
    private var flutterResult: FlutterResult?
    private var paymentController: MainViewController?
    private var viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }
    
    func initiateSdk(_ arguments: [String: Any], result: @escaping FlutterResult) {
        NSLog("\(TAG) Initiating SDK with original arguments: \(arguments)")
        NSLog("\(TAG) Amount \(String(describing: arguments["amount"]))")
        self.flutterResult = result
        
        createMerchantOrder(arguments: arguments, amount:arguments["amount"] as! String ) { [weak self] responseData, error in
            guard let self = self else { return }
            
            if let error = error {
                self.handleError(message: "Error creating merchant order: \(error.localizedDescription)")
                return
            }
            
            guard let responseData = responseData,
                  let jsonResponse = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                  let trackingId = jsonResponse["trackingId"] as? String,
                  let requestHash = jsonResponse["requestHash"] as? String else {
                self.handleError(message: "Invalid response from merchant order API")
                return
            }
            
            // Create the complete request dictionary
            let requestDictionary = self.createRequestDictionary(
                arguments: arguments as NSDictionary,
                trackingId: trackingId,
                requestHash: requestHash
            )
            
            DispatchQueue.main.async {
                NSLog("\(self.TAG) Starting payment controller with request: \(requestDictionary)")
                
                // Initialize payment controller with request dictionary
                self.paymentController = MainViewController(ccRequestDictionary: requestDictionary)
                self.paymentController?.delegate = self
                self.paymentController?.modalPresentationStyle = .fullScreen
                
                // Present the payment controller
                self.viewController.present(self.paymentController!, animated: true, completion: nil)
            }
        }
    }
    
    private func createMerchantOrder(arguments: [String: Any], amount :String, completion: @escaping @Sendable (Data?, Error?) -> Void) {
        // Create URL components
        guard var components = URLComponents(string: "https://qasecure.ccavenue.com/TransCcAvenue/createMerchantOrder") else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        // Create query items from arguments
        let queryItems = [
            URLQueryItem(name: "currency", value: arguments["currency"] as? String ?? "INR"),
            URLQueryItem(name: "amount", value: amount),
//                            arguments["amount"] as? String ?? ""),
//                            ,
            URLQueryItem(name: "accessCode", value: arguments["access_code"] as? String ?? ""),
            URLQueryItem(name: "env", value: "app_local"),
            URLQueryItem(name: "orderId", value: arguments["order_id"] as? String ?? ""),
            URLQueryItem(name: "merchantParam1", value: arguments["merchantParam1"] as? String ?? ""),
            URLQueryItem(name: "merchantParam2", value: arguments["merchantParam2"] as? String ?? ""),
            URLQueryItem(name: "merchantParam3", value: arguments["merchantParam3"] as? String ?? ""),
            URLQueryItem(name: "merchantParam4", value: arguments["merchantParam4"] as? String ?? ""),
            URLQueryItem(name: "merchantParam5", value: arguments["merchantParam5"] as? String ?? ""),
            URLQueryItem(name: "redirectUrl", value: arguments["redirect_url"] as? String ?? ""),
            URLQueryItem(name: "customerIdentifier", value: arguments["customer_id"] as? String ?? ""),
            URLQueryItem(name: "regId", value: arguments["mId"] as? String ?? ""),
//            URLQueryItem(name: "subAccountId", value: arguments["subAccountId"] as? String ?? ""),
//            URLQueryItem(name: "tId", value: arguments["tId"] as? String ?? "")
        ]
        
        components.queryItems = queryItems.filter { $0.value != nil && !$0.value!.isEmpty }
        
        guard let url = components.url else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"  // Keep it as POST request
        
        let tagCopy = TAG
        let completionCopy = completion
        
        NSLog("\(TAG) Creating merchant order with URL: \(url.absoluteString)")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("\(tagCopy) Merchant Order API failed: \(error.localizedDescription)")
                completionCopy(nil, error)
                return
            }
            
            guard let data = data else {
                completionCopy(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response"]))
                return
            }
            
            NSLog("\(tagCopy) Merchant Order API Response: \(String(data: data, encoding: .utf8) ?? "")")
            completionCopy(data, nil)
        }
        task.resume()
    }
    
    private func createRequestDictionary(arguments: NSDictionary?, trackingId: String, requestHash: String) -> [String: Any] {
        NSLog("\(TAG) TrackingId \(trackingId)")
        NSLog("\(TAG) RequestHash \(requestHash)")
        return [
            "order_id": arguments?["order_id"] as? String ?? "",
            "access_code": arguments?["access_code"] as? String ?? "",
            "merchant_id":"61116",
//                arguments?["mId"] as? String ?? "",
//                Int(arguments?["mId"] as? String ?? "") ?? 0,
            "amount":
                arguments?["amount"] as? String ?? "",
            "currency": arguments?["currency"] as? String ?? "INR",
            "customer_id": arguments?["customer_id"] as? String ?? "",
            "billing_name": arguments?["billing_name"] as? String ?? "",
            "billing_address": arguments?["billing_address"] as? String ?? "",
            "billing_country": arguments?["billing_country"] as? String ?? "",
            "billing_State": arguments?["billing_state"] as? String ?? "",
            "billing_city": arguments?["billing_city"] as? String ?? "",
            "billing_zipCode": arguments?["billing_zip"] as? String ?? "",
            "billing_tel":arguments?["billing_telephone"] as? String ?? "",

//                "7620237601",
//                arguments?["billing_tel"] as? String ?? "",
            "billing_email": arguments?["billing_email"] as? String ?? "",
            "delivery_name": arguments?["delivery_name"] as? String ?? "",
            "delivery_address": arguments?["delivery_address"] as? String ?? "",
            "delivery_country": arguments?["delivery_country"] as? String ?? "",
            "delivery_state": arguments?["delivery_state"] as? String ?? "",
            "delivery_city": arguments?["delivery_city"] as? String ?? "",
            "delivery_zipCode": arguments?["delivery_zip"] as? String ?? "",
            "delivery_tel":"7620237601",
//                arguments?["delivery_tel"] as? String ?? "",
            "redirectUrl": arguments?["redirect_url"] as? String ?? "",
            "cancelUrl": arguments?["cancel_url"] as? String ?? "",
        
            "merchant_param1": arguments?["merchantParam1"] as? String ?? "",
            "merchant_param2": arguments?["merchantParam2"] as? String ?? "",
            "merchant_param3": arguments?["merchantParam3"] as? String ?? "",
            "merchant_param4": arguments?["merchantParam4"] as? String ?? "",
            "merchant_param5": arguments?["merchantParam5"] as? String ?? "",
            "payment_enviroment": "app_local",
            "payment_type": arguments?["payment_type"] as? String ?? "All",
            "promo_code": arguments?["promo"] as? String ?? "",
            "display_promo": arguments?["display_promo"] as? String ?? "Y",
//            "trackingId":"2130000001692617",
            "trackingId": trackingId as String,
            "requestHash":requestHash
//                "6341404cc0bea7b3d6a895d4a682aedc3d1e4e82e69d67affd606beaa6addb4e9255e981735f3d37b823107b798f4c5ce55952fd0fa4d998b2946676ed0fce64"
//                requestHash
        ]
    }
    
    private func handleError(message: String) {
        DispatchQueue.main.async {
            self.flutterResult?(FlutterError(code: "PAYMENT_ERROR",
                                           message: message,
                                           details: nil))
        }
    }
    
    // MARK: - MainViewControllerDelegate
    func getResponse(_ jsonResponse: [AnyHashable: Any]?) {
        NSLog("\(TAG) Payment Response Received: \(String(describing: jsonResponse))")
        
        paymentController?.dismiss(animated: true) {
            self.paymentController = nil
            
            guard let jsonResponse = jsonResponse else {
                self.flutterResult?(FlutterError(code: "PAYMENT_ERROR",
                                               message: "Empty response",
                                               details: nil))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: jsonResponse,
                                                        options: [])
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    self.flutterResult?(jsonString)
                } else {
                    self.flutterResult?(FlutterError(code: "PAYMENT_ERROR",
                                                   message: "Failed to encode response",
                                                   details: nil))
                }
            } catch {
                self.flutterResult?(FlutterError(code: "PAYMENT_ERROR",
                                               message: "JSON serialization failed: \(error.localizedDescription)",
                                               details: nil))
            }
        }
    }
}
