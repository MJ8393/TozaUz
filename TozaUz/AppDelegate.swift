//
//  AppDelegate.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 29/06/24.
//

import UIKit
import Alamofire

var mapLocations = [(name: String, latitude: Double, longitude: Double)]()

extension Notification.Name {
    static let myNotification = Notification.Name("myNotification")
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        fetchBoxLocations { result in
            switch result {
            case .success(let locations):
                mapLocations = locations
                print("Sucess", locations)
                NotificationCenter.default.post(name: .myNotification, object: nil)
            case .failure(let error):
                print("Error on map")
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    func fetchBoxLocations(completion: @escaping (Result<[(name: String, latitude: Double, longitude: Double)], Error>) -> Void) {
        let url = "https://api.tozauz.uz/api/v1/ecopacket/box-location/"
        
        var headers: HTTPHeaders = [
            "Authorization": "token \(UD.token ?? "")"
        ]
        
        if (UD.token ?? "").replacingOccurrences(of: " ", with: "") == "" {
            headers = [
                "Authorization": "token bff72e2a7fd58c962ed557b07c61e8b5c61e573b"
            ]
        } else {
            headers = [
                "Authorization": "token \(UD.token ?? "")"
            ]
        }
        
        print("RRR", headers)
        
        AF.request(url, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let jsonArray = value as? [[String: Any]] {
                    var locations: [(name: String, latitude: Double, longitude: Double)] = []
                    
                    for item in jsonArray {
                        if let name = item["name"] as? String,
                           let locationString = item["last_lifecycle_location"] as? String {
                            // Remove parentheses and split the string by comma
                            let coordinates = locationString
                                .trimmingCharacters(in: CharacterSet(charactersIn: "()"))
                                .split(separator: ",")
                            
                            if let lat = Double(coordinates.first?.trimmingCharacters(in: .whitespaces) ?? ""),
                               let lon = Double(coordinates.last?.trimmingCharacters(in: .whitespaces) ?? "") {
                                locations.append((name: name, latitude: lat, longitude: lon))
                            }
                        }
                    }
                    
                    completion(.success(locations))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

