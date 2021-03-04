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
        
        let headers: HTTPHeaders = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZjRlMjk0ZWIxZjY4OTJjNzQ3NDJkZTM1NjQyOTJkMmE3YmQ5ZGZmOTkwNzc0YWMwZjQ5ODVhMTY5MDJiMjE1MTJiMWMwY2RmOTA3NWNjZDUiLCJpYXQiOjE2MTQ4NTU0MDYsIm5iZiI6MTYxNDg1NTQwNiwiZXhwIjoxNjQ2MzkxNDA2LCJzdWIiOiIxMDQiLCJzY29wZXMiOltdfQ.YgAmiMP-6mWZVzE3BQsTqbxkwG6DcVjvG2rRD1utKGnd842zp_7PgnVaOVnXyPvaWbwGC6XIlCflt0tT1JCHq-ziKyP92Ofbq_dDYZPC1adefTrNYokykY8AgJEWWJz47B_bdc5YiJm1F4iSML2GjjtjQ9_AZS5BwTJctbCLPFzhlfSkUDLQbqbn9WW8gapWQ54gbwMx083igHQVQb0QBSW5H3sgPAnMvtHM0_ujUKbcTYRd_OyvxC78uMR0Cd4-7RU_4JliJ8hKurMUmpAL8JkYzTDD7WEdvcE6GL-GZDBlw-iBkGB__ltJQGvnljTF3L_k3-K-kGSeadyY73AObzGdZkxY_pP8p8Xyo9gts2BgG1r3e2SKi-jGVouNWs1qbNSh4IcXIoYcz_pi0F8Og63ojroVIX8iHMIzoryeaafvBE5K_O8pSvizjsBOcRTQLOysY6T4q1uzaC5QxxRF9dgqlTGUvCYt-zj_psCHPfMU7x2uShCJFQx6ZBYxwvR9r2kGKZ-kz2oODgcLq5YYXJ0Yij_xN0PVOUkMsNCKi6h64KjiB7wl4yYp9RzO050YrkeA1IVWxpOoQxndkeW2Xga61noAXk6gy6YaT2dZL3F8YWTo39PMRKVnJ62lqfC6UjRx64TNhn7PzWaKvrWL8r0gOqwDKXjS3dJY-Vy-eWA    ", "Content-type": "application/json"]
        
        AF.request("https://adsumoriginator.com/seng/api/token/cus_J3FUiPJVgAQ4AR", method: .get, parameters: nil,encoding: JSONEncoding.default, headers: headers).responseJSON { [self]
            response in
            
            if let data = response.data {
                do {
                    let userresponse = try JSONDecoder().decode(keydata.self, from: data)
                    print(userresponse.data.secret!)
                    UserDefaults.standard.set(userresponse.data.secret!, forKey: "secretkey")
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
            "pool_id": 81,
            "amount": "150",
            "currency": "Eur",
            "description": "archana.travel",
            "payment_method": "pm_card_us"
        ] as [String : Any]

        let headers: HTTPHeaders = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZjRlMjk0ZWIxZjY4OTJjNzQ3NDJkZTM1NjQyOTJkMmE3YmQ5ZGZmOTkwNzc0YWMwZjQ5ODVhMTY5MDJiMjE1MTJiMWMwY2RmOTA3NWNjZDUiLCJpYXQiOjE2MTQ4NTU0MDYsIm5iZiI6MTYxNDg1NTQwNiwiZXhwIjoxNjQ2MzkxNDA2LCJzdWIiOiIxMDQiLCJzY29wZXMiOltdfQ.YgAmiMP-6mWZVzE3BQsTqbxkwG6DcVjvG2rRD1utKGnd842zp_7PgnVaOVnXyPvaWbwGC6XIlCflt0tT1JCHq-ziKyP92Ofbq_dDYZPC1adefTrNYokykY8AgJEWWJz47B_bdc5YiJm1F4iSML2GjjtjQ9_AZS5BwTJctbCLPFzhlfSkUDLQbqbn9WW8gapWQ54gbwMx083igHQVQb0QBSW5H3sgPAnMvtHM0_ujUKbcTYRd_OyvxC78uMR0Cd4-7RU_4JliJ8hKurMUmpAL8JkYzTDD7WEdvcE6GL-GZDBlw-iBkGB__ltJQGvnljTF3L_k3-K-kGSeadyY73AObzGdZkxY_pP8p8Xyo9gts2BgG1r3e2SKi-jGVouNWs1qbNSh4IcXIoYcz_pi0F8Og63ojroVIX8iHMIzoryeaafvBE5K_O8pSvizjsBOcRTQLOysY6T4q1uzaC5QxxRF9dgqlTGUvCYt-zj_psCHPfMU7x2uShCJFQx6ZBYxwvR9r2kGKZ-kz2oODgcLq5YYXJ0Yij_xN0PVOUkMsNCKi6h64KjiB7wl4yYp9RzO050YrkeA1IVWxpOoQxndkeW2Xga61noAXk6gy6YaT2dZL3F8YWTo39PMRKVnJ62lqfC6UjRx64TNhn7PzWaKvrWL8r0gOqwDKXjS3dJY-Vy-eWA    ", "Content-type": "application/json"]

        print(params)
                AF.request("https://adsumoriginator.com/seng/api/paymentIntent", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    print(response.value)
                    print(response.error)
                    if response.error != nil {
                        completion(.failure(response.error ?? APIError.unknown))
                    }else{
                        let responseDict = response.value as! NSDictionary
                        let status = responseDict.value(forKey: "status") as! Bool
                        if status {
                            if let secret = responseDict.value(forKey: "data") as? String, !secret.isEmpty {
                                completion(.success(secret))
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
