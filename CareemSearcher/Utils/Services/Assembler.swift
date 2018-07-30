//
//  Assembler.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/29/18.
//

//MARK: -  Assembler app DI

protocol Assembler: SeriviceRequestsAssembler, PersistenceAssembler { }

//MARK: - Request Layer Assembler

/// SeriviceRequestsAssembler
///
/// This is the protocol for inject the layer
/// request service to the app
///

protocol SeriviceRequestsAssembler {
    func resolve() -> ServiceRequestsHandler
}

//MARK: - Persistence Layer Assembler

/// PersistenceAssembler
///
/// This is the protocol for inject the layer
/// persistence service to the app
///

protocol PersistenceAssembler {
    func resolve(persistence named: String) throws -> PersistenceHandler
}
