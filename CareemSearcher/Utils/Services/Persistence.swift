//
//  Persistence.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/29/18.
//

import RxSwift

//MARK: - Persistense Handler Interface

/// PersistenceHandler
///
/// This protocol is the interface for the persistence
/// layer implementation, provides the generic methods for request
/// data persisted above the app
///
protocol PersistenceHandler {
    init(persistence name: String) throws
    
    func getItem<T: Serializable>(_ model: T.Type) throws -> T?
    func allData<T: Serializable>(_ model: T.Type) throws -> [T]
    func updateOrCreate(item: Any?) throws
    func updateOrCreate(item: [Any]) throws
    
    //Rx Persistence Handler Implementations
    func getItem<T: Serializable>(for model: T.Type) -> Observable<T?>
    func allData<T: Serializable>(to model: T.Type) -> Observable<[T]>
}
