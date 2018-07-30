//
//  PersistenceModel.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/29/18.
//

import IGListKit
import CoreData
import RxCoreData

/// PersistenceBaseModel
///
/// This is the base model for use on the implementation
/// persistence app
///
class PersistenceBaseModel: NSObject, Persistable {
    var id: String = ""
    
    static var entityName: String {
        return getEntityModelName()
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    class func getEntityModelName() -> String {
        return ""
    }
    
    var identity: String {
        return id
    }
    
    override init() {}
    
    required init(entity: NSManagedObject) {
        id = entity.value(forKey: "id") as? String ?? ""
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(id, forKey: "id")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            print(error)
        }
    }
}

/// PersistenceModel
///
/// This model will be the default for extend on
/// the entities above the app
///
class PersistenceModel: PersistenceBaseModel, Serializable {
    
    required init?(with data: Any?) {
        if let entity = data as? NSManagedObject {
            super.init(entity: entity)
            return
        }
        
        if let json = data as? [String: Any] {
            super.init()
            self.id = json["id"] as? String ?? ""
            return
        }
        
        return nil
    }
    
    required init(entity: NSManagedObject) {
        super.init(entity: entity)
    }
    
}


//MARK: List Diffable Implementations
extension PersistenceModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.identity as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self.isEqual(object)
    }
}
