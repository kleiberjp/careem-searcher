//
//  IGListKit+Rx.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/29/18.
//  source: yuzushioh on 2017/04/09. 'https://github.com/yuzushioh/RxIGListKit/blob/master/RxIGListKit/RxIGListAdapterDataSource.swift'
//

import IGListKit
import RxSwift
import RxCocoa

public protocol RxListAdapter {
    associatedtype Element
    func listAdapter(_ adapter: ListAdapter, observeredEvent event: Event<Element>)
}

public extension Reactive where Base: ListAdapter {
    
    func items<T: RxListAdapter & ListAdapterDataSource,
        O: ObservableType>(at dataSource: T) -> (_ source:O) -> Disposable where T.Element == O.E {
        
        return { source in
            let subscription = source
                .subscribe {
                    dataSource.listAdapter(self.base, observeredEvent: $0)
            }
            
            return Disposables.create {
                subscription.dispose()
            }
        }
        
    }
    
    func set<T: RxListAdapter & ListAdapterDataSource>(datasource item: T) -> Disposable {
        base.dataSource = item
        return Disposables.create()
    }
    
}
