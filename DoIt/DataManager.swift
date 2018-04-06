//
//  DataManager.swift
//  DoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    var items = [Item]()
    var cachedItems = [Item]()

    var documentDirectory: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
    var dataFileUrl: URL = URL(fileURLWithPath: "")
    let fileName = "data.json"
    
    required init() {
        dataFileUrl = documentDirectory.appendingPathComponent(fileName)
        loadData()
    }

    //MARK: File
    func saveData(){
        saveContext()
    }
    
    func loadData(){
        
    }
    
    //MARK: Item
    func addItem(text: String){
        let item = Item(context: persistentContainer.viewContext)
        item.name = text
        item.checked = false
        cachedItems.append(item)
        saveData()
    }
    
    func getItems() -> [Item] {
        return items
    }
    
    func getItem(index: Int) -> Item {
        return items[index]
    }
    
    func moveItem(sourceIndex: Int, destinationIndex: Int){
        let sourceItem = cachedItems.remove(at: sourceIndex)
        cachedItems.insert(sourceItem, at: destinationIndex)
        items = cachedItems
        saveData()
    }
    
    func removeItem(index: Int) {
        let item = items.remove(at: index)
        cachedItems = cachedItems.filter{ $0.name != item.name }
        saveData()
    }
    
    func filterItems(filter: String) {
        if filter.isEmpty {
            items = cachedItems
        } else {
            items = cachedItems.filter{ $0.name?.range(of: filter, options: [.caseInsensitive, .diacriticInsensitive]) != nil }
        }
    }
    
    func toggleCheckItem(index: Int){
        let item = items[index]
        item.checked = !item.checked
        saveData()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DoIt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
