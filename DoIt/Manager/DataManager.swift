//
//  DataManager.swift
//  DoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation
import CoreData

class DataManager : DataManagerProtocol{
    
    var cachedItems = [Tache]()
    
    required init() {
        loadData()
    }

    //MARK: File
    func saveData(){
        saveContext()
    }
    
    func loadData(){
        let itemFetch: NSFetchRequest<Tache> = Tache.fetchRequest()
        
        do {
            cachedItems = try persistentContainer.viewContext.fetch(itemFetch)
        }
        catch {
            debugPrint("Could not load the items from CoreData")
        }
    }
    
    //MARK: Tache
    func addItem(text: String){
        let item = Tache(context: persistentContainer.viewContext)
        item.nom = text
        item.checked = false
        cachedItems.append(item)
        saveData()
    }
    
    func getItems() -> [Tache] {
        return cachedItems
    }
    
    func getItem(index: Int) -> Tache {
        return cachedItems[index]
    }
    
    func moveItem(sourceIndex: Int, destinationIndex: Int){
        let sourceItem = cachedItems.remove(at: sourceIndex)
        cachedItems.insert(sourceItem, at: destinationIndex)
        saveData()
    }
    
    func removeItem(index: Int) {
        let item = cachedItems[index]
        cachedItems.remove(at: index)
        let context = persistentContainer.viewContext
        context.delete(item)
        saveData()
    }
    
    func filterItems(filter: String) {
        if filter.isEmpty {
            loadData()
        } else {
            let sortDescriptor = NSSortDescriptor(key: "nom", ascending: true)
            let fetchedTaches: NSFetchRequest<Tache> = Tache.fetchRequest()
            fetchedTaches.sortDescriptors = [sortDescriptor]
            fetchedTaches.predicate = NSPredicate(format: "nom contains[cd] %@", filter)
            do {
                cachedItems = try persistentContainer.viewContext.fetch(fetchedTaches)
            }
            catch {
                debugPrint("Could not load the items from CoreData")
            }
        }
    }
    
    func toggleCheckItem(index: Int){
        let item = cachedItems[index]
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
