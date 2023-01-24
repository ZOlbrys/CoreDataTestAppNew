//
//  CoreDataController.swift
//  CoreDataTestAppNew
//
//  Created by Zach Olbrys on 10/31/19.
//  Copyright © 2019 ZOlbrys. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, NSFetchedResultsControllerDelegate {
    
    var frc: NSFetchedResultsController<CoreDataItem>?

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataTestAppNew")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    override init() {
        super.init()
        setupFRC()
    }
    
    func setupFRC() {
        let fetchRequest = NSFetchRequest<CoreDataItem>(entityName: "CoreDataItem")
        let sectionSort = NSSortDescriptor(keyPath: \CoreDataItem.section, ascending: true)
        let idSort = NSSortDescriptor(keyPath: \CoreDataItem.identifier, ascending: true)
        
        fetchRequest.sortDescriptors = [sectionSort, idSort]
        
        let frcContext = persistentContainer.newBackgroundContext()
        frcContext.automaticallyMergesChangesFromParent = true
        frcContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        frc = NSFetchedResultsController.init(fetchRequest: fetchRequest,
                                              managedObjectContext: frcContext,
                                              sectionNameKeyPath: "section",
                                              cacheName: nil)
        frc?.delegate = self
    }
    
    func fetch() {
        frc?.managedObjectContext.perform { [weak self] in
            guard let strongSelf = self else { return }
            for index in 0..<10000 {
                do {
                    print("Fetching \(index)...")
                    try strongSelf.frc?.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to perform fetch")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
    }
    
    func insertItems(count: Int) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            let taskContext = strongSelf.persistentContainer.newBackgroundContext()
            taskContext.perform {
                for index in 0..<count {
                    let newItem = NSEntityDescription.insertNewObject(forEntityName: "CoreDataItem", into: taskContext) as! CoreDataItem
                    newItem.identifier = UUID().uuidString
                    newItem.section = "Section"
                    do {
                        print("Inserting Item \(index)")
                        try taskContext.save()
                    } catch (let error) {
                        print("Error Adding Item = \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    // If this is commented out, then no crash
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {

    }
}


