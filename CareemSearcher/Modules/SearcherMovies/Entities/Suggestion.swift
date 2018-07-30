//
//  Suggestion.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/30/18.
//

import CoreData
import IGListKit

final class Suggestion: PersistenceModel {
    var date: Date?
    var search: String = ""
    
    required init(entity: NSManagedObject) {
        date = entity.value(forKey: "date") as? Date
        search = entity.value(forKey: "text") as? String ?? ""
        super.init(entity: entity)
    }
    
    required init?(with data: Any?) {
        super.init(with: data)
    }
    
    override class func getEntityModelName() -> String {
        return String(describing: Suggestion.self)
    }
    
    override func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let rhs = object as? Suggestion else { return false }
        
        return self.id == rhs.id &&
               self.date == rhs.date &&
               self.search == rhs.search
    }
    
}
