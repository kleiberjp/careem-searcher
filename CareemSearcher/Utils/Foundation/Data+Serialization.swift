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


extension JSONDecoder {
    static func model<T: Decodable>(with jsonDictionary: [AnyHashable : Any]) throws -> T {
        let dataJson = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        return try JSONDecoder().decode(T.self, from: dataJson)
    }
    
    static func array<T: Decodable>(with jsonArray: [[AnyHashable : Any]]) throws -> [T] {
        return try jsonArray.map { try JSONDecoder.model(with: $0) }
    }
}
