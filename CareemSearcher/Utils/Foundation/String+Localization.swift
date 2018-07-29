//
//  String+Localization.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/22/18.
//

import Foundation


extension String {
    var localized: String {
        return localize(text: self)
    }
    
    private var errorCopy: String {
        return "ERROR"
    }
    
    private func localize(text: String) -> String {
        let bundle = getBundleLanguage()
        let copy = NSLocalizedString(text, tableName: nil, bundle: bundle, value: errorCopy, comment: "")
        guard copy != errorCopy, !copy.isEmpty else {
            return text
        }
        return copy
    }
 
    private func getBundleLanguage() -> Bundle {
        let mainBundle = Bundle.main
        let locale = getSelectedLocale()
        
        if let languageBundlePath = mainBundle.path(forResource: locale, ofType: "lproj"),
            let languageBundle = Bundle(path: languageBundlePath) {
            return languageBundle
        }
        
        return mainBundle
    }
    
    private func getSelectedLocale() -> String {
        let lang = Locale.preferredLanguages
        let languageComponents: [String : String] = Locale.components(fromIdentifier: lang[0])
        
        guard let languageCode: String = languageComponents["kCFLocaleLanguageCodeKey"] else {
            return "en"
        }
        
        return languageCode
    }
    
}
