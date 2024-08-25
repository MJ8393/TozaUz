//
//  Login_API.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 29/06/24.
//

import Foundation
import Alamofire

class TozaAPI {
    static let shared = TozaAPI()
    
    private init() {}
    
    func registerUser(firstName: String, lastName: String, phoneNumber: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "https://api.tozauz.uz/api/v1/account/register-otp/"
        let parameters: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "phone_number": phoneNumber,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let otp = json["otp"] as? String {
                    completion(.success(otp))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func verifyRegister(phone: String, otp: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "https://api.tozauz.uz/api/v1/account/verify-registration-otp/"
        let parameters: [String: Any] = [
            "phone_number": phone,
            "otp": otp
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let message = json["message"] as? String {
                    completion(.success(message))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func forgotPassword(phone: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "https://api.tozauz.uz/api/v1/account/forgot-password/"
        let parameters: [String: Any] = [
            "phone_number": phone
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let otp = json["otp"] as? String {
                    completion(.success(otp))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func verifyForgotPassword(phone: String, otp: String, newPassword: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = "https://api.tozauz.uz/api/v1/account/verify-forgot-password-otp/"
        let parameters: [String: Any] = [
            "phone_number": phone,
            "otp": otp,
            "new_password": newPassword
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let message = json["message"] as? String {
                    completion(.success(message))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    func authenticateUser(phoneNumber: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let url = "https://api.tozauz.uz/api/v1/account/api-token-auth/"
        let parameters: [String: Any] = [
            "phone_number": phoneNumber,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseDecodable(of: AuthResponse.self) { response in
            switch response.result {
            case .success(let authResponse):
                completion(.success(authResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteUser(phoneNumber: String, password: String, completion: @escaping (Result<DeleteAuth, Error>) -> Void) {
        let url = "https://api.tozauz.uz/api/v1/account/user-delete/"
        let parameters: [String: Any] = [
            "phone_number": phoneNumber,
            "password": password
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Token \(UD.token ?? "")"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: DeleteAuth.self) { response in
            switch response.result {
            case .success(let authResponse):
                completion(.success(authResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateUserPassword(oldPassword: String, newPassword: String, completion: @escaping (Result<String, Error>) -> Void) {
            let url = "https://api.tozauz.uz/api/v1/account/user-update-password/"
            let parameters: [String: Any] = [
                "old_password": oldPassword,
                "new_password": newPassword
            ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Token \(UD.token ?? "")"
        ]
        
        
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
                if let error = response.error {
                    completion(.failure(error))
                    return
                }
                
                guard let statusCode = response.response?.statusCode else {
                    completion(.failure(AFError.responseValidationFailed(reason: .dataFileNil)))
                    return
                }
                
                switch statusCode {
                case 200...299:
                    completion(.success("Success"))
                default:
                    completion(.success("Failure"))
                }
            }
        }
    
    
    
    func getPayoutHistory(completion: @escaping (Result<PasswordUpdateInfoResponse, Error>) -> Void) {
        let url = "https://api.tozauz.uz/api/v1/bank/payout-list-user/"
        let headers: HTTPHeaders = [
            "Authorization": "Token \(UD.token ?? "")"
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                // Print JSON response
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("JSON Response: \(json)")
                }
                
                // Decode JSON response
                do {
                    let decoder = JSONDecoder()
                    let updateInfoResponse = try decoder.decode(PasswordUpdateInfoResponse.self, from: data)
                    completion(.success(updateInfoResponse))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                print("Error: \(error)")
                completion(.failure(error))
            }
        }

    }
    
    func getMobileEarningList(startDate: String, endDate: String, page: Int, completion: @escaping (Result<MobileEarningListResponse, Error>) -> Void) {
           let url = "https://api.tozauz.uz/api/v1/bank/mobile-earning-list/"
           let parameters: [String: Any] = [
               "start_date": startDate,
               "end_date": endDate,
               "page": page
           ]
           let headers: HTTPHeaders = [
               "Authorization": "Token \(UD.token ?? "")"
           ]
           
           AF.request(url, method: .get, parameters: parameters, headers: headers).responseDecodable(of: MobileEarningListResponse.self) { response in
               switch response.result {
               case .success(let mobileEarningResponse):
                   completion(.success(mobileEarningResponse))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    
    func getMeBank(completion: @escaping (Result<MeBankResponse, Error>) -> Void) {
        let url = "https://api.tozauz.uz/api/v1/bank/me-bank/"
        let headers: HTTPHeaders = [
            "Authorization": "Token \(UD.token ?? "")"
        ]
        
      
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: MeBankResponse.self) { response in
            switch response.result {
            case .success(let meBankResponse):
                completion(.success(meBankResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(firstName: String, lastName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "https://api.tozauz.uz/api/v1/account/profile/update/"
        let parameters: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Token \(UD.token ?? "")"
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result {
            case .success:
                if response.error == nil {
                    completion(.success(()))
                } else {
                    completion(.failure(response.error!))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    
    func createPayme(amount: Int64, card: String, cardName: String, completion: @escaping (Result<PaymeCreateResponse, Error>) -> Void) {
        let url = "https://api.tozauz.uz/api/v1/bank/payme-create/"
        let parameters: [String: Any] = [
            "amount": amount,
            "card": card,
            "card_name": cardName
        ]
        let headers: HTTPHeaders = [
            "Authorization": "Token \(UD.token ?? "")"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: PaymeCreateResponse.self) { response in
            switch response.result {
            case .success(let paymeCreateResponse):
                completion(.success(paymeCreateResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct MeBankResponse: Decodable {
    let id: Int?
    let user: UserInfo?
    let capital: Int?
}

struct UserInfo: Decodable {
    let id: Int?
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    let role: String?
    let isActive: Bool?
    let categories: [String]?
    let carNumber: String?
    let isAdmin: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case role
        case isActive = "is_active"
        case categories
        case carNumber = "car_number"
        case isAdmin = "is_admin"
    }
}


struct PaymeCreateResponse: Decodable {
    let id: Int
    let createdAt: String
    let amount: Int
    let card: String
    let cardName: String
    let payed: Bool
    let user: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case amount
        case card
        case cardName = "card_name"
        case payed
        case user
    }
}


struct BoxLocation: Decodable {
    let name: String
//    let lastLifecycleLocation: String

//    enum CodingKeys: String, CodingKey {
//        case name
//        case lastLifecycleLocation = "last_lifecycle_location"
//    }

//    func getCoordinates() -> (latitude: Double, longitude: Double)? {
//        let cleanedLocation = lastLifecycleLocation.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
//        let components = cleanedLocation.split(separator: ",")
//        if components.count == 2,
//           let latitude = Double(components[0].trimmingCharacters(in: .whitespaces)),
//           let longitude = Double(components[1].trimmingCharacters(in: .whitespaces)) {
//            return (latitude, longitude)
//        }
//        return nil
//    }
}
