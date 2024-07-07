//
//  LanguageManager.swift
//  TozaUz
//
//  Created by Mekhriddin Jumaev on 03/07/24.
//

import Foundation
import Localize_Swift

class LanguageManager {
    
    static func setApplLang(_ lang: AppLanguage) {
        Localize.setCurrentLanguage(lang.rawValue)
        UD.language = lang.rawValue
    }
    
    static func setAppLang(langStr: String) {
        let language = AppLanguage.language(for: langStr.lowercased())
        LanguageManager.setApplLang(language)
    }
    
    static func getAppLang() -> AppLanguage {
        return AppLanguage(rawValue: Localize.currentLanguage()) ?? .English
    }
    
    static func setDefaultLanguage () {
        setApplLang(AppLanguage(rawValue: UD.language) ?? .English)
    }
    
    static func checkLangSettings() -> Bool {
        return UD.language.isEmpty
    }
}


enum AppLanguage: String {
    case English = "ru"
    case Uzbek = "uz"
    case lanDesc = "Language"
    
    static func language(for str: String) -> AppLanguage {
        if str == "ru" {
            return .English
        } else if str == "uz" {
            return .Uzbek
        } else {
            return .lanDesc
        }
    }
}
