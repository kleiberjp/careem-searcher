//
//  RequestModel.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/23/18.
//

import Alamofire

/// Request
///
/// Struct with implementation protocol RequestType
struct Request: RequestType {
    var url: String = ""
    var method: RequestMethod = .get
    var data: [String : Any]?
    var dataArray: [Any]?
    var responseInBackground: Bool = false
    
    var headers: [String : String]? {
        var defaultHeaders = SessionManager.defaultHTTPHeaders
        defaultHeaders["Content-Type"] = "application/json"
        
        return defaultHeaders
    }
    
    var parameters: [String: Any]? {
        return dataArray.isNull ? data : dataArray?.asParameters()
    }

    var encondingType: ParameterEncoding {
        guard dataArray.isNull else {
            return ArrayEncoding()
        }
        
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

/// RequestError
///
/// Default error for request layer
struct RequestError: RequestErrorType {
    private var dataInfo: Data? {
        didSet {
            info = dataInfo?.dictInfo ?? [:]
        }
    }
    
    var info: [String : Any] = [:]
    var message: String?
    var status: RequestStatus = .undefined
    
    init() {}
    
    init(status: RequestStatus, info: Any? = nil, message: String? = nil) {
        self.init()
        self.status = status
        self.dataInfo = info as? Data
        self.message = message
    }
}
