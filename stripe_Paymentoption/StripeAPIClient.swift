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
        
        let headers: HTTPHeaders = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYTBmNWM5MDg2YjY0YjU0Njc2M2EwNDVmMWMwOTIxNGI0ZWZmMmQ3MzM1N2UxMzhmZmRkYzI4MGM5OTJiYzJjZDg1YmRmZDQ4OGNhY2U0ZTYiLCJpYXQiOjE2MTk4NjMxODYsIm5iZiI6MTYxOTg2MzE4NiwiZXhwIjoxNjUxMzk5MTg2LCJzdWIiOiI5NSIsInNjb3BlcyI6W119.Anf5bGfq6UXuwo_S94Fd1S5IZFRWjTZ_-BmcuYoHYlJjUIWYKU8Y0dHYUhCZ4UAxHzyZS1CQxOrrK0SixjGZELqyQTnqhCxAc4OchG11bGF_w2Dms41fynbhwnk34LO806Bqs_4MTlYi9hajSUvcWBMdjjx5nSvKSIhhkGtSNIKokTm5BpMBYfgXlXUlFEgim485sFfbRbVWgE2IFLl-J9D9XfHj8uX8Zj1d4OwumbmrfbVRmSrit4jN_D79vqswzo-Ct25Y4AKWTpaBa08x8ZHiBrkYapKR7nhmmlkJMDQb82En_pjUKoFsWuaCLx0jv47dlGpkz9QOrwva_AjhG5-hatMlYS7IMy9-JlrowqvPlhDAT7w6vOylWJlnkYz9QXgKOw_ClSU_472sf8HWkix_vuPjDx0UqdASQz9Td8B9fgmFHV5UA5Wn56-bJiupaBsxlnM6uO4SiqM-s5d6sn2AozqmJexMgj2rcXQllAff_VhES8PuRvwIJv1KfjJMV0w70Mkz0L6lLlQhX2aIEMxtbeK1horOX0GHe0zY5SngU9MoRDFNo8CtwGKtk3Cp2HEMcq9bH5_VJfsvXhZ1qS4icb8aXsd6jFOlIrZc4xVKZSLrdK4l1rBk2y3Oj9m3q87aqNpz9ExMdxifMsWFr5JkXjQ8TloD3FD2iX7UZJU", "Content-type": "application/json"]

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

        let headers: HTTPHeaders = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYTBmNWM5MDg2YjY0YjU0Njc2M2EwNDVmMWMwOTIxNGI0ZWZmMmQ3MzM1N2UxMzhmZmRkYzI4MGM5OTJiYzJjZDg1YmRmZDQ4OGNhY2U0ZTYiLCJpYXQiOjE2MTk4NjMxODYsIm5iZiI6MTYxOTg2MzE4NiwiZXhwIjoxNjUxMzk5MTg2LCJzdWIiOiI5NSIsInNjb3BlcyI6W119.Anf5bGfq6UXuwo_S94Fd1S5IZFRWjTZ_-BmcuYoHYlJjUIWYKU8Y0dHYUhCZ4UAxHzyZS1CQxOrrK0SixjGZELqyQTnqhCxAc4OchG11bGF_w2Dms41fynbhwnk34LO806Bqs_4MTlYi9hajSUvcWBMdjjx5nSvKSIhhkGtSNIKokTm5BpMBYfgXlXUlFEgim485sFfbRbVWgE2IFLl-J9D9XfHj8uX8Zj1d4OwumbmrfbVRmSrit4jN_D79vqswzo-Ct25Y4AKWTpaBa08x8ZHiBrkYapKR7nhmmlkJMDQb82En_pjUKoFsWuaCLx0jv47dlGpkz9QOrwva_AjhG5-hatMlYS7IMy9-JlrowqvPlhDAT7w6vOylWJlnkYz9QXgKOw_ClSU_472sf8HWkix_vuPjDx0UqdASQz9Td8B9fgmFHV5UA5Wn56-bJiupaBsxlnM6uO4SiqM-s5d6sn2AozqmJexMgj2rcXQllAff_VhES8PuRvwIJv1KfjJMV0w70Mkz0L6lLlQhX2aIEMxtbeK1horOX0GHe0zY5SngU9MoRDFNo8CtwGKtk3Cp2HEMcq9bH5_VJfsvXhZ1qS4icb8aXsd6jFOlIrZc4xVKZSLrdK4l1rBk2y3Oj9m3q87aqNpz9ExMdxifMsWFr5JkXjQ8TloD3FD2iX7UZJU", "Content-type": "application/json"]

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
