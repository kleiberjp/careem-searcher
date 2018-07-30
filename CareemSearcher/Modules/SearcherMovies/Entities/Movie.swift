//
//  Movie.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/30/18.
//

import Foundation
import IGListKit

final class Movie: Codable {
    private var id: Int = 0
    var overview: String = ""
    var releaseDate: String = ""
    private var posterPath: String = ""
    var rating: Double = 0
    var popularity: Double = 0
    
    var urlPoster: URL? {
        return URL(string: "http://image.tmdb.org/t/p/w92\(self.posterPath)")
    }
    
    var date: String {
        return formatReleaseDate(releaseDate)
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        
        return formatter
    }()
    
    private enum CodingKeys: String, CodingKey {
        case id, overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
    }
    
    init() {}
    
    private func formatReleaseDate(_ date: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: date) else {
            return ""
        }
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}

extension Movie: ListDiffable {
    
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSNumber
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let rhs = object as? Movie else { return false }
        
        return self.id == rhs.id &&
               self.overview == rhs.overview &&
               self.releaseDate == rhs.releaseDate &&
               self.posterPath == rhs.posterPath &&
               self.rating == rhs.rating &&
               self.popularity == rhs.popularity
    }
    
}


