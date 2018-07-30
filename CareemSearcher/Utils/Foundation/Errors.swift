//
//  Errors.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/29/18.
//

import Foundation

//MARK: - Entities generic for app

/// Custom Error Type
///
/// Enums that contains all the posibles
/// generic error finded above the app
///

protocol CustomErrorType: CustomNSError, LocalizedError {
    var info: [String: Any] { get set }
    var message: String? { get set }

    init()
    init(info: Any?)
    init(info: Any?, message: String?)
}

extension CustomErrorType {
    init(info: Any?) {
        self.init(info: info, message: nil)
    }
    
    init(info: Any?, message: String?) {
        self.init()
        self.info = info as? [String: Any] ?? [:]
        self.message = message
    }
    
    static var errorDomain: String {
        return "careem.searcher.error.type"
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
            return message
    }
}

enum CustomErrorMode: Int {
    case undefined = -1
    case invalidData = -1000
    case persistenceFailure = -1001
    
    var errorDescription: String {
        switch self {
        case .invalidData:
            return "Exist some issue wiht the handle of the data proportionated"
            
        case .persistenceFailure:
            return "The persistence implementator fails on initalizate"
        default:
            return ""
        }
    }
}



struct CustomErrors: CustomErrorType {
    var info: [String : Any] = [:]
    private var customMessage: String?
    var message: String? {
        get { return customMessage ?? error.errorDescription }
        set { customMessage = newValue }
    }
    var error: CustomErrorMode = .undefined
    
    init() {}
    
    init(error: CustomErrorMode, info: [String:Any] = [:], message: String? = nil) {
        self.init(info: info, message: message)
        self.error = error
    }
    
    var errorCode: Int {
        return error.rawValue
    }
}
