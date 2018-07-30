//
//  SearchResult.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/30/18.
//

import UIKit

class SearchResult: Serializable {
    var currentPage: Int = 0
    var totalPages: Int = 0
    var movies: [Movie] = []
    
    required init?(with data: Any?) {
        guard let info = data as? [String: Any] else {
            return nil
        }
        
        self.currentPage = info["page"] as? Int ?? 0
        self.totalPages = info["total_pages"] as? Int ?? 0
        
        do {
            let dataMovies = info["results"] as? [[String: Any]] ?? []
            self.movies = try JSONDecoder.array(with: dataMovies)
        } catch {
            let errorInfo = error as NSError
            print("Unable to init class \(self).. \(errorInfo.localizedDescription)..\(errorInfo.userInfo)")
        }
        
    }
}
