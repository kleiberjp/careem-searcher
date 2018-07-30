//
//  AppAssembler.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/29/18.
//

// AppAssembler
//
// Class contains the DI of the app for this
// use case
//
//

class AppAssembler: Assembler {
    func resolve() -> ServiceRequestsHandler {
        return ServiceRequest()
    }
    
    func resolve(persistence named: String) throws -> PersistenceHandler {
        return try PersistenceAdapter(persistence: named)
    }
}
