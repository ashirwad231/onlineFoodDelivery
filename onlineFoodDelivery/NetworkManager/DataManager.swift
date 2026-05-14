//
//  DataManager.swift
//  onlineFoodDelivery
//
//  Created by Ashirwad on 08/05/26.
//
import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "onlineFoodDelivery")
        container.loadPersistentStores { description, error in
            if let error {
                print("Core Data Error: \(error.localizedDescription)")
                fatalError("Error in loading core data \(error)")
            }
            print("Core Data loaded successfully")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
