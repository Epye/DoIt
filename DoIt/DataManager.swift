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
    
    required init() {
        loadData()
    }

    //MARK: File
    func saveData(){
        saveContext()
    }
    
    func loadData(){
        let itemFetch = NSFetchRequest<Item>(entityName: "Item")
        
        do {
            cachedItems = try persistentContainer.viewContext.fetch(itemFetch)
            items = cachedItems
        }
        catch {
            
        }
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
        let context = persistentContainer.viewContext
        context.delete(item)
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
        let container = NSPersistentContainer(name: "DoIt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
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
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
