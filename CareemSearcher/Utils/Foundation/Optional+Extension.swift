//
//  Optional+Extensions.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/23/18.
//

import Foundation
import RxSwift

/// OptionalType
///
///This protocol allows handle the optional swift type objects
///
protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

extension Optional where Wrapped: Any {
    
    var isNull: Bool {
        return self == nil
    }
    
    func value(or defaultValue: Wrapped) -> Wrapped {
        return self ?? defaultValue
    }
}

extension ObservableType where E: OptionalType {
    func ignoreNil() -> Observable<E.Wrapped> {
        return flatMap { value in
            value.optional.map { .just($0) } ?? Observable<E.Wrapped>.empty()
        }
    }
}
