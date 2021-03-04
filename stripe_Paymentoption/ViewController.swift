//
//  ViewController.swift
//  stripe_Paymentoption
//
//  Created by MAC on 03/03/21.
//

import UIKit
import Stripe

class ViewController: UIViewController, STPPaymentContextDelegate {
    
    
    
    @IBOutlet weak var payment_method_lbl: UILabel!
    
    var isPaymentMethodSelected = false
    let apiClient = StripeAPIClient.sharedClient
    var paymentContext: STPPaymentContext!
    
    var paymentIntentId = "", paymentMethodId = "", clientsecret = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialisePayment()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @IBAction func addcart(_ sender: UIButton) {
        //        self.navigationController?.isNavigationBarHidden = false
        paymentContext.pushPaymentOptionsViewController()
    }
    
    @IBAction func payment(_ sender: UIButton) {
        
        if isPaymentMethodSelected {
            
            if paymentMethodId.isEmpty {
                paymentContext.requestPayment()
            }else{
                //  placeOrder()
            }
        }else{
            // showToast("Please select payment method")
        }
        
        
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        if let paymentOption = paymentContext.selectedPaymentOption {
            payment_method_lbl.text = paymentOption.label
        } else {
            payment_method_lbl.text = "Add Payment Method"
        }
        isPaymentMethodSelected = paymentContext.selectedPaymentOption != nil
        //        pay_btn.isEnabled = paymentContext.selectedPaymentOption != nil
        //        pay_back_view.backgroundColor = (pay_btn.isEnabled ? UIColor(red: 245.0/255.0, green: 132.0/255.0, blue: 28.0/255.0, alpha: 1.0) : UIColor.darkGray)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(title: "Error",message: error.localizedDescription,preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            //            self.loading = true
            self.paymentContext.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        apiClient.createPaymentIntent { (result) in
            switch result {
            case .success(let clientSecret):
//
                let clientSecret = UserDefaults.standard.string(forKey: "secretkey")
                self.clientsecret = clientSecret!
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret!)
                paymentIntentParams.configure(with: paymentResult)
                paymentIntentParams.returnURL = "payments-example://stripe-redirect"
                STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: paymentContext) { status, paymentIntent, error in
                    switch status {
                    case .succeeded:
                        if let methodId = paymentIntent?.paymentMethodId {
                            self.paymentMethodId = methodId
                        }
                        if let intentId = paymentIntent?.stripeId {
                            self.paymentIntentId = intentId
                        }
                        completion(.success, nil)
                    case .failed:
                        completion(.error, error)
                    case .canceled:
                        completion(.userCancellation, nil)
                    @unknown default:
                        completion(.error, nil)
                    }
//
                }
            case .failure(let error):
                print("Failed to create a Payment Intent: \(error)")
                completion(.error, error)
                break
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        let title: String
        let message: String
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            //            placeOrder()
            return()
        case .userCancellation:
            return()
        @unknown default:
            return()
        }
        //        self.paymentInProgress = false
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func initialisePayment() {
        //        apiClient.emphemeralKey = keyData
        let customerContext = STPCustomerContext(keyProvider: apiClient)
        let config = STPPaymentConfiguration.shared
        
        
        let theme = STPTheme()
        theme.accentColor = UIColor(red: 245.0/255.0, green: 132.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        paymentContext = STPPaymentContext(customerContext: customerContext,configuration: config,theme: theme)
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        paymentContext.paymentAmount = Int(3200)
        
        //        paymentContext.paymentCurrency = "gbp"
        //        paymentContext.paymentCountry = ""
        
    }

}
