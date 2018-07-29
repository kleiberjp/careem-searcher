//
//  RequestEntities.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/15/18.
//

import Alamofire

//MARK: - Entities generic for app

/// Custom Error
///
/// Enums that contains all the posibles
/// generic error founded above the app
///

enum CustomErrors: CustomNSError, LocalizedError {
    case invalidData
}

// MARK: - Entities Request Service Layer

//MARK: Request Status

/// RequestStatus
///
///A enum representation of the possible status responses on the request
///
enum RequestStatus: Int, RawRepresentable {
    case undefined
    case ok
    case failServiceRequest
    case failAuthentication
    case serverError
    case serializationFailed
    case notFound
    
    init?(rawValue: Int) {
        switch rawValue {
        case 200...202:
            self = .ok
        case 401:
            self = .failAuthentication
        case 500,502:
            self = .serverError
        case 400,422:
            self = .failServiceRequest
        case 404:
            self = .notFound
        default:
            self = .undefined
        }
    }
    
    var rawValue: Int {
        switch self {
        case .notFound:
            return 404
        case .failServiceRequest:
            return 400
        case . serverError:
            return 500
        case .failAuthentication:
            return 401
        case .ok:
            return 200
        default:
            return 0
        }
    }
}

// MARK: Request Error

/// RequestErrorType
///
/// A generic protocol for parse all the possible error
/// response of a request
///
protocol RequestErrorType: CustomNSError, LocalizedError {
    var info: [String: Any] { get set }
    var message: String? { get set }
    var status: RequestStatus { get set }
    
    init()
    init(status: RequestStatus, info: Any?)
    init(status: RequestStatus, info: Any?, message: String?)
}

extension RequestErrorType {
    
    init(status: RequestStatus, info: Any?) {
        self.init(status: status, info: info, message: nil)
    }
    
    init(status: RequestStatus, info: Any?, message: String?) {
        self.init()
        self.status = status
        self.info = info as? [String: Any] ?? [:]
        self.message = message
    }

    static var errorDomain: String {
        return "careem.searcher.request.error.type"
    }
        
    var errorCode: Int {
        return status.rawValue
    }
    
    var errorUserInfo: [String : Any] {
        var errorInfo = [String: Any]()
        if let messageInfo = message {
            errorInfo[NSLocalizedDescriptionKey] = messageInfo
        }
        
        errorInfo[NSLocalizedFailureReasonErrorKey] = info
        return errorInfo
    }
    
    var errorDescription: String? {
        guard message.isNull else {
            return message
        }
        
        switch status {
        case .ok:
            return nil
        case .serverError, .failServiceRequest:
            return Localizable.requestError.localized
        default:
            return Localizable.serverErrors.localized
        }
    }
}


// MARK: Request Model

/// RequestType
///
/// This protocol contains the min properties
/// for execute a request
enum RequestMethod: String {
    case get
    case post
    case put
    case delete
}

protocol RequestType {
    var url: String { get }
    var method: RequestMethod { get }
    var parameters: [String: Any]? { get }
    var responseInBackground: Bool { get }
    var headers: [String: String]? { get }
}

/// Serializable
///
///Protocol for handle serialization model
protocol Serializable {
    associatedtype Model
    init(with data: Any?) throws
}

