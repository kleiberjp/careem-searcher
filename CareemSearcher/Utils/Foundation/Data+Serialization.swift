//
//  Data+Serialization.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/23/18.
//

import Foundation

extension Data {
    
    var dictInfo: [String: Any] {
        do {
            let dictonary = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
            return  dictonary ?? [:]
        } catch {
            return [:]
        }
    }
}
