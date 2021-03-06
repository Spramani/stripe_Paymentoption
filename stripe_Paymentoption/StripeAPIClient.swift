//
//  StripeAPIClient.swift
//  stripe_Paymentoption
//
//  Created by MAC on 03/03/21.
//

import Foundation
import Stripe
import Alamofire




class StripeAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
    
    
   
    enum APIError: Error {
        case unknown
        
        var localizedDescription: String {
            switch self {
            case .unknown:
                return "Unknown error"
            }
        }
    }
    
    static let sharedClient = StripeAPIClient()
    var emphemeralKey = [AnyHashable : Any]()
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
   
        let headers: HTTPHeaders = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYzBiMjliYWI2M2EyYjViOTE2NDU0ZTRhNTk2ZGM1YTA3ZTRmZWE2ZWVmNjYzZmM4MzRkYjQ2MDM0YjEwOWQzNTM4YzQxNWI4NTEyOWM1MzQiLCJpYXQiOjE2MTUwMDQ5MDUsIm5iZiI6MTYxNTAwNDkwNSwiZXhwIjoxNjQ2NTQwOTA1LCJzdWIiOiIxMTYiLCJzY29wZXMiOltdfQ.MDDS1ExOf_u_WYrMXmRYeMGPk6ov1gO-f_5f9wvla8ziYvO7EQ-6nWcNj0sgVmd7aKx0hy5WR9X6n7Ji7v_F8JiSCw9v6q53h4pwfQSBKdtwlqDWPGmFKJLlxOM5spPcWyFiNa5udveRMUl5S-j-p9v7sD9D4reBwxyeZ0r-CNNQDuCyHrCRlHryhnbLYzj70MaNPqhOEARrEnd99uXwGcwp9sFGK3AqiY2Rw_yW9cY5H3EM-ik-2LwxFGKX_gDxdrqqrm9XuPO-eIAMSXEJi3kPfMwBIegcxJpJf8sVdKsBn4p1v7JsWPsuEvDHgMaU3DulPdXQhG0rHYBDtYvaaLGm6WH_lwTdLGEbxWQ8ShgcAA52-ckCWy-nJFCp3pnstcyKdF57sqveddqHEThy6zBSFxrlgUvOGNQVBIQc9qKHMUUrHNB0Tg--wcyzbHgEdfjilyvIWGJPNDcIDGPlt5vWQfPPkoSoBNXkoOwcb-l0vgDONhfz3aknIA9AdbDQjGEl-tsJwC0aPpA3tNP7SBwo5fwnUHJhtcCc9HhOMwfbIOWCnHmO4ItY_DEYiLuwTIa54vyaSnPx-P8tFqWfhtN1AfueV5GpU52H6Q2iw2bCuK8a9LVJxeh0TTrf_DACEVx8MCisxGwRT9sN9ufc0ZGAo5OypJbzC4tL1N70DrA", "Content-type": "application/json"]

        AF.request("https://adsumoriginator.com/seng/api/token/cus_J3zJuyYg2GbqnZ", method: .get, parameters: nil,encoding: JSONEncoding.default, headers: headers).responseJSON { [self]
            response in
            
            if let data = response.data {
                do {
                    let userresponse = try JSONDecoder().decode(keydata.self, from: data)
                    print(userresponse.data.secret!)
                
                } catch _ {
                    print("Error")
                }
            }
            
            
            
            if let value = response.value as? NSDictionary {
                
                let datas = value["data"]!
                print(datas)
                self.emphemeralKey = datas as! [AnyHashable : Any]
                completion(self.emphemeralKey, nil)
            }
            else {
                print("Value nill")
            }
            
            
        }
        
    }
    

    func createPaymentIntent(_ completion: @escaping ((Result<String, Error>) -> Void)) {

        var id = ""
        if let associatedAry = emphemeralKey["associated_objects"] as? NSArray, associatedAry.count > 0 {
            id = "\((associatedAry.object(at: 0) as AnyObject).value(forKey: "id")!)"
        }
        let params = [
              "customer_id": id,
              "pool_id": 93,
              "amount": "100",
              "currency": "eur",
              "description": "describe",
              "payment_method": "card"
        ] as [String : Any]

        let headers: HTTPHeaders = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYzBiMjliYWI2M2EyYjViOTE2NDU0ZTRhNTk2ZGM1YTA3ZTRmZWE2ZWVmNjYzZmM4MzRkYjQ2MDM0YjEwOWQzNTM4YzQxNWI4NTEyOWM1MzQiLCJpYXQiOjE2MTUwMDQ5MDUsIm5iZiI6MTYxNTAwNDkwNSwiZXhwIjoxNjQ2NTQwOTA1LCJzdWIiOiIxMTYiLCJzY29wZXMiOltdfQ.MDDS1ExOf_u_WYrMXmRYeMGPk6ov1gO-f_5f9wvla8ziYvO7EQ-6nWcNj0sgVmd7aKx0hy5WR9X6n7Ji7v_F8JiSCw9v6q53h4pwfQSBKdtwlqDWPGmFKJLlxOM5spPcWyFiNa5udveRMUl5S-j-p9v7sD9D4reBwxyeZ0r-CNNQDuCyHrCRlHryhnbLYzj70MaNPqhOEARrEnd99uXwGcwp9sFGK3AqiY2Rw_yW9cY5H3EM-ik-2LwxFGKX_gDxdrqqrm9XuPO-eIAMSXEJi3kPfMwBIegcxJpJf8sVdKsBn4p1v7JsWPsuEvDHgMaU3DulPdXQhG0rHYBDtYvaaLGm6WH_lwTdLGEbxWQ8ShgcAA52-ckCWy-nJFCp3pnstcyKdF57sqveddqHEThy6zBSFxrlgUvOGNQVBIQc9qKHMUUrHNB0Tg--wcyzbHgEdfjilyvIWGJPNDcIDGPlt5vWQfPPkoSoBNXkoOwcb-l0vgDONhfz3aknIA9AdbDQjGEl-tsJwC0aPpA3tNP7SBwo5fwnUHJhtcCc9HhOMwfbIOWCnHmO4ItY_DEYiLuwTIa54vyaSnPx-P8tFqWfhtN1AfueV5GpU52H6Q2iw2bCuK8a9LVJxeh0TTrf_DACEVx8MCisxGwRT9sN9ufc0ZGAo5OypJbzC4tL1N70DrA", "Content-type": "application/json"]

            print(params)
        
            AF.request("https://adsumoriginator.com/seng/api/paymentIntentToken", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in

                    if response.error != nil {
                        completion(.failure(response.error ?? APIError.unknown))
                    }else{
                        let responseDict = response.value as! NSDictionary
                        let status = responseDict.value(forKey: "status")
                        if (status != nil) == true {
                            if let secret = responseDict.value(forKey: "data") as? NSDictionary {
                                let Payment_secretkey = secret.value(forKey: "clientSecret")
                                
                                completion(.success(Payment_secretkey as! String))
                            }else{
                                completion(.failure(APIError.unknown))
                            }
                        }else{
                            completion(.failure(APIError.unknown))
                        }
                    }
                }
    }
}



//MARK: - model emphemeralKey
struct keydata : Codable {
    let status : String?
    let data : keydataData
    let messages : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case data = "data"
        case messages = "messages"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        data = try values.decodeIfPresent(keydataData.self, forKey: .data)!
        messages = try values.decodeIfPresent(String.self, forKey: .messages)
    }
    
}

struct keydataData : Codable {
    let id : String?
    let object : String?
    let associated_objects : [Associated_objects]?
    let created : Int?
    let expires : Int?
    let livemode : Bool?
    let secret : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case object = "object"
        case associated_objects = "associated_objects"
        case created = "created"
        case expires = "expires"
        case livemode = "livemode"
        case secret = "secret"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        object = try values.decodeIfPresent(String.self, forKey: .object)
        associated_objects = try values.decodeIfPresent([Associated_objects].self, forKey: .associated_objects)
        created = try values.decodeIfPresent(Int.self, forKey: .created)
        expires = try values.decodeIfPresent(Int.self, forKey: .expires)
        livemode = try values.decodeIfPresent(Bool.self, forKey: .livemode)
        secret = try values.decodeIfPresent(String.self, forKey: .secret)
    }
    
}
struct Associated_objects : Codable {
    let id : String?
    let type : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
}
