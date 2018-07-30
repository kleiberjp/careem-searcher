//
//  ServiceRequestAdapter.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/23/18.
//

import Alamofire
import Foundation
import RxAlamofire
import RxSwift

//MARK: - Service Request Layer Default App

class ServiceRequest {
    
    private func process(request infoRequest: RequestType, onComplete complete: ((DataResponse<Any>)->Void)?) {
        let method = HTTPMethod(rawValue: infoRequest.method.rawValue) ?? .get
        let encoding = getEncoding(from: infoRequest)
        let queue: DispatchQueue? = infoRequest.responseInBackground ? DispatchQueue.global(qos: .background) : nil

        request(infoRequest.url, method: method, parameters: infoRequest.parameters, encoding: encoding, headers: infoRequest.headers)
            .validate(statusCode: 200..<300)
            .responseJSON(queue: queue) { (response) in
                complete?(response)
            }
    }
    
    private func handleResponse<T: Serializable>(_ response: DataResponse<Any>, for model: T.Type) -> (data: T?, error: RequestErrorType?) {
        switch response.result {
        case .success(let dataResponse):
            let data = handleSuccesResponse(with: dataResponse, for: model)
            return (data.model, data.error)
            
        default:
            let error = handleError(at: response)
            return (nil, error)
        }
    }
    
    private func handleSuccesResponse<T: Serializable>(with data: Any?, for model: T.Type) -> (model: T?, error: RequestErrorType?) {
        let info = T(with: data)
        return (info, nil)
    }
    
    private func handleError(at response: DataResponse<Any>) -> RequestErrorType? {
        guard case .failure(let errorResponse) = response.result else {
            return nil
        }
        
        let error = getError(from: errorResponse, with: response.data)
        return error
    }
    
    private func getError(from errorRequest: Error?, with dataReponse: Data?) -> RequestErrorType {
        guard let error = errorRequest as? AFError else {
            return RequestError(status: .undefined, info: errorRequest?.localizedDescription)
        }
        
        switch error {
        case .responseValidationFailed(let reason):
            guard  case .unacceptableStatusCode(let codeStatus) = reason else {
                return RequestError(status: .undefined, info: error.localizedDescription)
            }
            
            let status = RequestStatus(rawValue: codeStatus) ?? .undefined
            return RequestError(status: status, info: dataReponse)
            
        default:
            return RequestError(status: .undefined, info: error.localizedDescription)
        }
    }
    
    private func getEncoding(from requestModel: RequestType) -> ParameterEncoding {
        guard let request = requestModel as? Request else {
            return URLEncoding.default
        }
        
        return request.encondingType
    }
}

//MARK: - Service Requests Handler Implementations

extension ServiceRequest: ServiceRequestsHandler {
   
    func execute<T: Serializable>(request infoRequest: RequestType, for model: T.Type, onComplete complete: ((T?, RequestErrorType?) -> Void)?) {
        process(request: infoRequest) { [weak self] response in
            let result = self?.handleResponse(response, for: model)
            complete?(result?.data, result?.error)
        }
    }
    
    func execute(request infoRequest: RequestType,  onComplete complete:((_ error: RequestErrorType?) -> Void)?) {
        process(request: infoRequest) { [weak self] response in
            guard let error = self?.handleError(at: response) else {
                complete?(nil)
                return
            }
            
            complete?(error)
        }
    }
}




