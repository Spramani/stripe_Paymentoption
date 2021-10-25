//
//  ViewController.swift
//  stripe_Paymentoption
//
//  Created by MAC on 03/03/21.
//

import UIKit
import Stripe
import Alamofire

class ViewController: UIViewController, STPPaymentContextDelegate {
    
    
    var ideal = true
    
    
    var idealUserName:String?
    var idealBankName:String?
    
    @IBOutlet weak var payment_method_lbl: UILabel!
    
    var isPaymentMethodSelected = false
    let apiClient = StripeAPIClient.sharedClient
    var paymentContext: STPPaymentContext!
    
    var paymentIntentId = "", paymentMethodId = "", clientsecret = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //when page laod first call this methode in stripe
        initialisePayment()
    }
    
    
    
   
    
    @IBAction func addcart(_ sender: UIButton) {
      
        //pushPaymentOptionsViewController() methode use to add , and edit card in strip payment methode
        paymentContext.pushPaymentOptionsViewController()
        
    }
    
    @IBAction func payment(_ sender: UIButton) {
        
        if ideal{
            apiClient.createPaymentIntent {(result)  in
                switch result {
                case .success(let clientSecret):
                    let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
                    
                    let iDEALParams = STPPaymentMethodiDEALParams()
                    iDEALParams.bankName = self.idealBankName //RABONL2U

                    // Collect customer information
                    let billingDetails = STPPaymentMethodBillingDetails()
                    billingDetails.name = self.idealUserName
                    paymentIntentParams.paymentMethodParams = STPPaymentMethodParams(iDEAL: iDEALParams,
                                                                                     billingDetails: billingDetails,
                                                                                     metadata: nil)
                    paymentIntentParams.returnURL = "ideal-example://stripe-redirect"
                    self.clientsecret = clientSecret
                    
                    STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: self.paymentContext) { status, paymentIntent, error in
                        switch status {
                        case .succeeded:
                            if let methodId = paymentIntent?.paymentMethodId {
                                self.paymentMethodId = methodId
                            }
                            if let intentId = paymentIntent?.stripeId {
                                self.paymentIntentId = intentId
                              //  self.defaultPaymentCard()
                            }
                            self.Confirmpayment()
                        case .failed:
//                            PaymentMethodVC.showUniversalLoadingView(false)
                            print(error?.localizedDescription ?? "")
                        case .canceled:
//                            PaymentMethodVC.showUniversalLoadingView(false)
                           break
                        @unknown default:
                           break
                        }
                    }
                    
                    break
                    
                case .failure(let error):
                    print(error.localizedDescription)
                break
                
                }
                
            }

        }
        
        if isPaymentMethodSelected {
            
            if paymentMethodId.isEmpty {
                paymentContext.requestPayment()
            }else{
                Confirmpayment()
            }
        }else{
            paymentContext.pushPaymentOptionsViewController()
             showToast("Please select payment method")
        }
        
        
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        if let paymentOption = paymentContext.selectedPaymentOption {
            payment_method_lbl.text = paymentOption.label
        } else {
            payment_method_lbl.text = "Add Payment Method"
        }
        isPaymentMethodSelected = paymentContext.selectedPaymentOption != nil
      
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

                self.clientsecret = clientSecret
                let paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
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
               Confirmpayment()
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
        
        
        let theme = STPTheme()    // its set stripe methode theme
        theme.accentColor = UIColor(red: 245.0/255.0, green: 132.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        paymentContext = STPPaymentContext(customerContext: customerContext,configuration: config,theme: theme)
        paymentContext.delegate = self
        paymentContext.hostViewController = self       // hostviewcontroller its bydefault create controller in stripe use to add card method
        paymentContext.paymentAmount = Int(10000)
        
        //        paymentContext.paymentCurrency = "gbp"
        //        paymentContext.paymentCountry = ""
        
    }
    
    
    
    func Confirmpayment() {
        
        let params = [
            "customer_id": "cus_J3zJuyYg2GbqnZ",
              "pool_id": 92,
              "amount": "100",
              "currency": "eur",
              "description": "pools described",
//              "payment_method_types": "card",
              "payment_id": paymentIntentId,
            
        
                "clientSecret":clientsecret,
                "paymentIntentId":paymentIntentId,
                "paymentMethodId":paymentMethodId,
              
                
            ] as [String : Any]
        print(params)
        
        AF.request("https://adsumoriginator.com/seng/api/payments", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { [self] (response) in
//            print(String(data: response.data!, encoding: .utf8))
//            self.paymentInProgress = false
            if response.error != nil {
//                showToast(response.error?.localizedDescription ?? internetMsg)
                print("errr message show")
            }else{
//                print(response.value)
//                print(response.error)
                let responseDict = response.value as! NSDictionary
                let status = responseDict.value(forKey: "status")
                if (status != nil) == true {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "successViewController") as! successViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    showToast(responseDict.value(forKey: "message") as! String)
                }
            }
        }
    }
    func showToast(_ message: String) {
        let windows = UIApplication.shared.windows
       // windows.last?.makeToast(message)
    }

}
