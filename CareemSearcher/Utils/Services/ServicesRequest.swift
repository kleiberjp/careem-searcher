//
//  ServiceRequest.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/15/18.
//

import RxSwift

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
                    let errorResponse: Error = error ?? CustomErrors(error: .invalidData)
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



