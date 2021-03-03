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
    
    static let sharedClient = StripeAPIClient()
    var emphemeralKey = [AnyHashable : Any]()
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
  
        let headers: HTTPHeaders = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMmI1NmVlMjA0MWExY2M3OGY0NDk0N2E2MjJkYTdhYmVkYjgxYmZlOGU5N2FmMjM1YTNhMzExMDljNTE3OTM5NDVhNDJiMDk2Y2FmNDI3MTUiLCJpYXQiOjE2MTQ3NjM1MTQsIm5iZiI6MTYxNDc2MzUxNCwiZXhwIjoxNjQ2Mjk5NTE0LCJzdWIiOiI5MiIsInNjb3BlcyI6W119.GNX0mDs5b4LmEffeDUtwFWCfG0h9JEe-LarHPeMY_x217LROsVBL4yYB4DExHsRYhYFE_gTT0eixG89rz9P3G68d7KImcaHNTqvX-mM94HcKiUPk0jcSTJwG918tvTGB_5r2Yn9EOGPvGPCRHpKtZRHjALFngMIY-WFdpDRJFMt1rNsmErnxXwc-qmvgpoOeeuzf7UCsnFWQOVxVQoRBxRwT9CMO4bTny8XPnPw7vfOhjoVR3o4ecQn8XxGnFJ4AOyZWIqPwn1ai-Hv7K4htvGGK9c9uHL9Kd8qCEo5UQ5h4WG1nyQiDnCSVadUzDOHheTTeNZdkqbMDKKSv41CDvjG2-N09JfvGZ-w2pDimcvhrq1K0qpk2u_alg3uN61usdn2qAkTrCcbRnC4kVmhlqxHZLbuUIDtPy2orGlCpMWX9FIUYJBnbkEi4eqYJbjlqi4aT-C4m0f_dwA6Ir_fOmWOfXh0Q6F8W4i8MF6lv4-BbhTfG8QThxg0xBRu0siEXTc1--47GsEyoJS0SrG-_OyWchfpTyiGqqnHNcB__K4qrzHqJ5_VlMDKsHJLq2KPcOJdEXBJNrt0StbCP5YMsOL5Jbm9EU58GgmdnjIjI8-Ffz0rR2k4zlL65YbLTOCvhP3X_sa8TqR3JlQ8sOJF2xIXRksKc5eynZZKKv53NAHY", "Content-type": "application/json"]
        
        AF.request("https://adsumoriginator.com/seng/api/token/cus_J2uQ7gBy5yOnt0", method: .get, parameters: nil,encoding: JSONEncoding.default, headers: headers).responseJSON { [self]
            response in
            
            
            
            let value = response.value as! NSDictionary
           
            let datas = value["data"]!
            print(datas)
          
            
            self.emphemeralKey = datas as! [AnyHashable : Any]
            completion(self.emphemeralKey, nil)
        }
        
    }
    
    
    func createPaymentIntent(_ completion: @escaping ((Result<String, Error>) -> Void)) {
        
//        let itemAry = NSMutableArray()
//        for c in cart.data {
//            let dict = NSMutableDictionary()
//            dict.setValue("\(c.count)", forKey: "count")
//            dict.setValue("\(c.id)", forKey: "itemRef")
//            if c.itemType == 0 {
//                dict.setValue("BAR", forKey: "itemType")
//            }else{
//                dict.setValue("KITCHEN", forKey: "itemType")
//            }
//            dict.setValue("\(c.name)", forKey: "itemName")
//            dict.setValue("\(c.price)", forKey: "itemPrice")
//            itemAry.add(dict)
//        }
//        var id = ""
//        if let associatedAry = emphemeralKey["associated_objects"] as? NSArray, associatedAry.count > 0 {
//            id = "\((associatedAry.object(at: 0) as AnyObject).value(forKey: "id")!)"
//        }
//        let params = [
//            "country":"GB",
//            "customer_ref":id,
//            "tip":"\(cart.tip)",
//            "customerOrderMenu":itemAry
//            ] as [String : Any]
//        print(params)
//        AF.request("\(BASE_URL)clientSecretKey?access_token=\(accessToken)", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
//            print(response.value)
//            print(response.error)
//            if response.error != nil {
//                completion(.failure(response.error ?? APIError.unknown))
//            }else{
//                let responseDict = response.value as! NSDictionary
//                let status = responseDict.value(forKey: "status") as! Bool
//                if status {
//                    if let secret = responseDict.value(forKey: "data") as? String, !secret.isEmpty {
//                        completion(.success(secret))
//                    }else{
//                        completion(.failure(APIError.unknown))
//                    }
//                }else{
//                    completion(.failure(APIError.unknown))
//                }
//            }
//        }
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
