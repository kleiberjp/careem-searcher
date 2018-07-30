//
//  SearchMoviesInteractor.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/30/18.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchMoviesInterface {
    func search(form text: Observable<String>) -> Driver<[Movie]>
    init(assembler: Assembler)
}

protocol SearchMovieDataManager {
    func getSuggestions() -> Observable<[Suggestion]>
    func save(suggestion text: String)
}

class SearchMoviesInteractor {
    private let network: ServiceRequestsHandler
    private let persistence: PersistenceHandler
    private var currentPage: Int = 0
    
    required init(assembler: Assembler) {
        self.network = assembler.resolve()
        
        do {
            self.persistence = try assembler.resolve(persistence: "CareemSearcher")
        } catch  {
            let errorInfo = error as NSError
            fatalError("Unable to handle error \(errorInfo.localizedDescription)..\(errorInfo.userInfo)")
        }
    }
}

extension SearchMoviesInteractor: SearchMoviesInterface {
    
    func search(form text: Observable<String>) -> Driver<[Movie]> {
        
    }
}
