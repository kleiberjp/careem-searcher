//
//  ScrollView+Rx.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/29/18.
//  source: yuzushioh on 2017/04/09. 'https://github.com/yuzushioh/RxIGListKit/blob/master/RxIGListKit/UIScrollView%2BExtension.swift'
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIScrollView {
    
    var didScrollToBottom: ControlEvent<Void> {
        let source = Observable.zip(contentOffset.skip(1), contentOffset)
            .flatMap { [weak base] current, previous -> Observable<Void> in
                guard let scrollView = base, current.y - previous.y > 0 && current.y > 0 else {
                    return .empty()
                }
                
                let y = current.y + scrollView.contentInset.top
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                
                return y > threshold ? .just(()) : .empty()

            }
            .throttle(1.0, latest: false, scheduler: MainScheduler.instance)
        
        return ControlEvent(events: source)
    }
}
