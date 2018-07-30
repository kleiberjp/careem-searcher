//
//  PersistenceAdapter.swift
//  CareemSearcher
//
//  Created by Kleiber Perez on 7/29/18.
//

import CoreData
import IGListKit
import RxSwift
import RxCoreData
import RxCocoa

//MARK: - Persistence Adapter Default App

class PersistenceAdapter {
    
    //MARK: Properties
    private var nameDataBase: String = ""
    var context: NSManagedObjectContext!
    private var disposeBag = DisposeBag()
        
    private lazy var applicationDocumentsDirectory: URL? = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last
    }()
    
    required init(persistence name: String) throws {
        guard !name.isEmpty else {
            let errorInfo = getErrorInfo(failureReason: "The name of persistence shouldn't be empty")
            throw CustomErrors(error: .persistenceFailure, info: errorInfo)
        }
    
        self.nameDataBase = name
        try configurePersistence()
    }
    
    //MARK: Core Data Helpers
    private func getManagedContext() throws -> NSManagedObjectContext {
        let coordinator = try getPersistentCoordinator()
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }
    
    private func getPersistentCoordinator() throws -> NSPersistentStoreCoordinator {
        guard let managedModel = try getManagedObjectModel(),
            let url = self.applicationDocumentsDirectory?.appendingPathComponent("\(nameDataBase).sqlite") else {
                let reasonFailure = "Something went wrong trying get the persistence database"
                throw CustomErrors(error: .persistenceFailure, info: getErrorInfo(failureReason: reasonFailure))
        }
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            throw instancePersistenceError(with: error)
        }
        
        return coordinator
    }
    
    private func getManagedObjectModel() throws -> NSManagedObjectModel? {
        guard let modelURL = Bundle.main.url(forResource: "\(nameDataBase)", withExtension: "momd") else {
            let reasonFailure = "Doesn't Exist any model persistence named \(nameDataBase)"
            throw CustomErrors(error: .persistenceFailure, info: getErrorInfo(failureReason: reasonFailure))
        }
        
        return NSManagedObjectModel(contentsOf: modelURL)
    }
    
    private func instancePersistenceError(with underlyingError: Error) -> CustomErrorType {
        let failureReason = "There was an error creating or loading the application's saved data."
        var errorInfo = getErrorInfo(failureReason: failureReason)
        
        let descriptionError = "Failed to initialize the application's saved data"
        errorInfo[NSLocalizedDescriptionKey] = descriptionError
        errorInfo[NSUnderlyingErrorKey] = underlyingError as NSError
        
        return CustomErrors(error: .persistenceFailure, info: errorInfo)
    }
    
    private func getErrorInfo(failureReason reason: String) -> [String: Any] {
        var errorInfo = [String: Any]()
        errorInfo[NSLocalizedFailureReasonErrorKey] = reason
        
        return errorInfo
    }
    
    //MARK: Persistence Helpers
    private func configurePersistence() throws {
        context = try getManagedContext()

        let backgroundApp = NotificationCenter.default.rx
                                .notification(.UIApplicationDidEnterBackground)
                                .observeOn(MainScheduler.instance)
        
        let willTerminateApp = NotificationCenter.default.rx
                                    .notification(.UIApplicationWillTerminate)
                                    .observeOn(MainScheduler.instance)

        
        Observable.merge(backgroundApp, willTerminateApp)
            .map { _ in () }
            .subscribe(onNext: { [weak self] _ in
                self?.trySaveCurrentData()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func trySaveCurrentData() {
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            let customError = instancePersistenceError(with: error) as NSError
            print("Unresolved error \(customError.localizedDescription  ), \(customError.userInfo)")
        }
    }
    
    private func getRequest(to modelName: String) -> NSFetchRequest<NSManagedObject> {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: modelName)
        fetchRequest.returnsObjectsAsFaults = false
        
        return fetchRequest
    }
    
    private func fetchData<M: Serializable>(for model: M.Type) throws -> [M] {
        let fetchRequest = getRequest(to: String(describing: model))
        
        let fetchResults = try context.fetch(fetchRequest)
        return fetchResults.compactMap { M(with: $0) }
    }
}


//MARK: - Persistence Handler Implementations

extension PersistenceAdapter: PersistenceHandler {
    func getItem<T: Serializable>(_ model: T.Type) throws -> T? {
        return try fetchData(for: model).first
    }
    
    func allData<T: Serializable>(_ model: T.Type) throws -> [T] {
        return try fetchData(for: model)
    }
    
    func updateOrCreate(item: Any?) throws {
        guard let object = item as? PersistenceModel else  {
            throw CustomErrors(error: .invalidData)
        }

        try context.rx.update(object)
    }
    
    func updateOrCreate(item: [Any]) throws {
        try item.forEach { try updateOrCreate(item: $0) }
    }
    
    func getItem<T: Serializable>(for model: T.Type) -> Observable<T?> {
        return allData(to: model)
                .flatMapFirst { items -> Observable<T?> in
                    .just(items.first)
                }
    }
    
    func allData<T: Serializable>(to model: T.Type) -> Observable<[T]> {
        let fetchRequest = getRequest(to: String(describing: model))

        return context.rx
            .entities(fetchRequest: fetchRequest)
            .map { data in
                data.compactMap { T(with: $0) }
            }
    }
}

