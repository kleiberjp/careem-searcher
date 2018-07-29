//
//  ServiceRequest.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/15/18.
//

import IGListKit
import RxSwift

//MARK: - Persistense Handler Interface

/// PersistenceHandler
///
/// This protocol is the interface for the persistence
/// layer implementation, provides the generic methods for request
/// data persisted above the app
///
protocol PersistenceHandler {
    init(named: String)
    
    func getData<T: Serializable & ListDiffable>(_ model: T.Type) throws -> T
    func getData<T: Serializable & ListDiffable>(_ model: T.Type) -> [T]
    func updateOrCreate<T: Serializable & ListDiffable>(item: T) throws
    func updateOrCreate<T: Serializable & ListDiffable>(item: [T]) throws
}

//MARK: Rx Persistence Handler Implementations

extension Reactive where Base: PersistenceHandler {
    
    func getData<T: Serializable & ListDiffable>(_ model: T.Type) -> Observable<T> {
        return .create { observable in
            let info: T
            do {
                info = try self.base.getData(model)
                observable.onNext(info)
                observable.onCompleted()

            } catch  {
                observable.onError(error)
            }

            return Disposables.create()
        }
    }
    
    func getData<T: Serializable & ListDiffable>(_ model: T.Type) -> Observable<[T]> {
        return .create { observable in
            let info: [T] = self.base.getData(model)
            observable.onNext(info)
            observable.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func updateOrCreate<T: Serializable & ListDiffable>(item: T) -> Completable {
        return .create { completable in
            do {
                try self.base.updateOrCreate(item: item)
                completable(.completed)
                
            } catch  {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    func updateOrCreate<T: Serializable & ListDiffable>(item: [T]) -> Completable {
        return .create { completable in
            do {
                try self.base.updateOrCreate(item: item)
                completable(.completed)
                
            } catch  {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
}

//MARK: - Services Requests Handler Interface

/// ServiceRequestsHandler
///
/// This protocol is the interface for the layer service request
/// implementation, provides the generic methods for request
/// data
///
protocol ServiceRequestsHandler {
    func execute<T: Serializable>(request infoRequest: RequestType, for model: T.Type, onComplete complete:((_ data: T?, _ error: RequestErrorType?) -> Void)?)
    func execute(request infoRequest: RequestType,  onComplete complete:((_ error: RequestErrorType?) -> Void)?)
}


//MARK: Rx Services Requests Handler Implementations

extension Reactive where Base: ServiceRequestsHandler {
    
    func execute<T: Serializable>(request infoRequest: RequestType, for model: T.Type) -> Single<T> {
        return .create { single in
            self.base.execute(request: infoRequest, for: model, onComplete: { (info, error) in
                guard let data = info, error.isNull else {
                    let errorResponse: Error = error ?? CustomErrors.invalidData
                    single(.error(errorResponse))
                    return
                }
                
                single(.success(data))
                
            })
            
            return Disposables.create()
        }
    }

    func execute(request infoRequest: RequestType) -> Completable {
        return .create { completable in
            self.base.execute(request: infoRequest, onComplete: { error in
                guard let errorResponse = error else {
                    completable(.completed)
                    return
                }
                
                completable(.error(errorResponse))
            })
            
            return Disposables.create()
        }
    }
}



