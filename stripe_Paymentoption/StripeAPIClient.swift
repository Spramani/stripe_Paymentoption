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
        
   
        let headers: HTTPHeaders = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiODJkOWZiZGQzMjBhZjkwNWQzYTUyNTMwYTc2NjhiN2E2NmVkMDMzMjI0ZDkzYzYxOWQzOTVmYjI0MTFhY2RkOWQ3ODhkNTc5MmQzNTQwMTciLCJpYXQiOjE2MTQ5NDMwOTAsIm5iZiI6MTYxNDk0MzA5MCwiZXhwIjoxNjQ2NDc5MDkwLCJzdWIiOiI5MCIsInNjb3BlcyI6W119.bSHaGhmj01wZVHUXyv3eGutDYHj1woBYxndpq6Fro9HCLeiTeXug_q8SbbsC5YM2-6XninZxYRcndR3GXFXxmNdGKrJ9QwvmgxuS3Cym5_9UJCqcjup_1imeq-tdHrd517sLg7lQI6im5x8OcS2pM4quxGBGAwLQWRCBDvvVchEvU1H1muOuuK1a5uCAQv3FsBsEDB67i_JMNA3JrB3B0GpRCDIcNLCBSZkwkOl7jpaFdcDT3cYFCU_Bfc_8ypOxOkfmVUx_oa9Fel1zitVempKnoR3N7qiOZpvdqu8yb2LLhVYmQEvSSghIlOIveTyJeQPJt0SDMPtUB-gG9FfTkOW0iyGHg4HLIyFLePTGxN54nfYFEStkggslpm-FVBTjqRmsotURXSUm_TAmPXJbaJGMSin96UJJfKF1P_4L87EXzttH0YJdlA8tgitDlJezA6HDEGbahPnx8QzFxnZU6Ibf6qRW_kidIPc7hXy4--N6FnSFVgBNp_LsbDlpf7Ej86vy9_a0R1dYHiEamDmFbe9mQrggjoH31Pizpnvauisl2shcAjTd6DkOEtsQgdVCpLB6bzz0fVMqCpP1HTEnK6DDEAT7dGFqWqOJtRXhKYZUl6UbtFV2j9OifXDOLGlNCqO3ZYYk-Q8OCAW5vEhRIpeHczEg482eufF7rF1okGo", "Content-type": "application/json"]

        AF.request("https://adsumoriginator.com/seng/api/token/cus_J2uQ7gBy5yOnt0", method: .get, parameters: nil,encoding: JSONEncoding.default, headers: headers).responseJSON { [self]
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
              "customer_id": "cus_J2uQ7gBy5yOnt0",
              "pool_id": 92,
              "amount": "100",
              "currency": "eur",
              "description": "pools described",
              "payment_method": "card"
        ] as [String : Any]

        let headers: HTTPHeaders = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiODJkOWZiZGQzMjBhZjkwNWQzYTUyNTMwYTc2NjhiN2E2NmVkMDMzMjI0ZDkzYzYxOWQzOTVmYjI0MTFhY2RkOWQ3ODhkNTc5MmQzNTQwMTciLCJpYXQiOjE2MTQ5NDMwOTAsIm5iZiI6MTYxNDk0MzA5MCwiZXhwIjoxNjQ2NDc5MDkwLCJzdWIiOiI5MCIsInNjb3BlcyI6W119.bSHaGhmj01wZVHUXyv3eGutDYHj1woBYxndpq6Fro9HCLeiTeXug_q8SbbsC5YM2-6XninZxYRcndR3GXFXxmNdGKrJ9QwvmgxuS3Cym5_9UJCqcjup_1imeq-tdHrd517sLg7lQI6im5x8OcS2pM4quxGBGAwLQWRCBDvvVchEvU1H1muOuuK1a5uCAQv3FsBsEDB67i_JMNA3JrB3B0GpRCDIcNLCBSZkwkOl7jpaFdcDT3cYFCU_Bfc_8ypOxOkfmVUx_oa9Fel1zitVempKnoR3N7qiOZpvdqu8yb2LLhVYmQEvSSghIlOIveTyJeQPJt0SDMPtUB-gG9FfTkOW0iyGHg4HLIyFLePTGxN54nfYFEStkggslpm-FVBTjqRmsotURXSUm_TAmPXJbaJGMSin96UJJfKF1P_4L87EXzttH0YJdlA8tgitDlJezA6HDEGbahPnx8QzFxnZU6Ibf6qRW_kidIPc7hXy4--N6FnSFVgBNp_LsbDlpf7Ej86vy9_a0R1dYHiEamDmFbe9mQrggjoH31Pizpnvauisl2shcAjTd6DkOEtsQgdVCpLB6bzz0fVMqCpP1HTEnK6DDEAT7dGFqWqOJtRXhKYZUl6UbtFV2j9OifXDOLGlNCqO3ZYYk-Q8OCAW5vEhRIpeHczEg482eufF7rF1okGo", "Content-type": "application/json"]

        print(params)
                AF.request("https://adsumoriginator.com/seng/api/paymentIntentToken", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                    print(response.value)
                    print(response.error)
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
