//
//  LocalizableKeys.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/22/18.
//

import Foundation

enum Localizable: String, RawRepresentable {
    case requestError
    case serverErrors
    
    var localized: String {
        return self.rawValue.localized
    }
    
}
