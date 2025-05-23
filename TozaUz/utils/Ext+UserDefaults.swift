//
//  Ext+UserDefaults.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 30/06/24.
//


import Foundation

let UD = UserDefaults(suiteName: "uz.ertakchi.www")!

extension UserDefaults {
    
    var isLoginMode: String? {
        get { return self.string(forKey: "isLoginMode") }
        set { self.set(newValue, forKey: "isLoginMode") }
    }
    
    var token: String? {
        get { return self.string(forKey: "token") }
        set { self.set(newValue, forKey: "token") }
    }
    
    var pinCode: String? {
        get { return self.string(forKey: "pinCode") }
        set { self.set(newValue, forKey: "pinCode") }
    }
    
    var firstName: String? {
        get { return self.string(forKey: "firstName") }
        set { self.set(newValue, forKey: "firstName") }
    }
    
    var lastName: String? {
        get { return self.string(forKey: "lastName") }
        set { self.set(newValue, forKey: "lastName") }
    }
    
    var phoneNum: String? {
        get { return self.string(forKey: "phoneNum") }
        set { self.set(newValue, forKey: "phoneNum") }
    }
    var password: String? {
        get { return self.string(forKey: "password") }
        set { self.set(newValue, forKey: "password") }
    }
    
    
    public var language: String {
        get { return unarchiveObject(key: "appLanguage").notNullString }
        set { archivedData(key: "appLanguage", object: newValue )    }
    }

    var mode: String? {
        get { return self.string(forKey: "appMode") }
        set { self.set(newValue, forKey: "appMode") }
    }
    
    func unarchiveObject(key: String) -> Any? {
        if let data = value(forKey: key) as? Data {
                do {
                    if let result = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self, NSNumber.self], from: data) {
                        return (result as AnyObject).value(forKey: "Data")
                    }
                }
            return nil
        }
        return nil
    }
    
    func archivedData(key: String, object: Any) {
        let result = NSMutableDictionary()
        result.setValue(object, forKey: "Data")
            do {
                let encodedObject = try? NSKeyedArchiver.archivedData(withRootObject: result, requiringSecureCoding: false)
                set(encodedObject, forKey: key)
            }
    }
    
}

extension Optional {
    var notNullString: String {
        switch self {
        case .some(let value): return String(describing: value)
        case .none : return ""
        }
    }
}
