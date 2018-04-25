//
//  DataManager.swift
//  DoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation
import CoreData

class DataManager<T: NSManagedObject> : DataManagerProtocol{
    
    var cachedItems = [T]()
    
    required init() {
        loadData()
    }

    //MARK: File
    func saveData(){
        saveContext()
    }
    
    func loadData(){
        let entityName = String(describing: T.self)
        let request = NSFetchRequest<T>(entityName: entityName)
        if entityName == "Tache" {
            let sortDescriptorOrder = NSSortDescriptor(key: "order", ascending: true)
            request.sortDescriptors = [sortDescriptorOrder]
        }
        do {
            cachedItems = try persistentContainer.viewContext.fetch(request)
        } catch  {
            print("Impossible to load the BD")
        }
    }
    
    //MARK: T
    func addItem(item: T){
        cachedItems.append(item)
        saveData()
    }
    
    func getItems() -> [T] {
        return cachedItems
    }
    
    func getItem(index: Int) -> T {
        return cachedItems[index]
    }
    
    func moveItem(sourceIndex: Int, destinationIndex: Int){
        let itemSource = cachedItems[sourceIndex] as! Tache
        let itemDest = cachedItems[destinationIndex] as! Tache
        itemSource.order = Int64(destinationIndex)
        itemDest.order = Int64(sourceIndex)
        saveData()
    }
    
    func removeItem(item: T) {
        cachedItems.remove(at: (cachedItems.index(of: item))!)
        let context = persistentContainer.viewContext
        context.delete(item)
        saveData()
    }
    
    func filterItems(filter: String) {
        if filter.isEmpty {
            loadData()
        } else {
            let sortDescriptor = NSSortDescriptor(key: "nom", ascending: true)
            let sortDescriptorOrder = NSSortDescriptor(key: "order", ascending: true)
            let fetchedTaches: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
            fetchedTaches.sortDescriptors = [sortDescriptorOrder, sortDescriptor]
            fetchedTaches.predicate = NSPredicate(format: "nom contains[cd] %@", filter)
            do {
                cachedItems = try persistentContainer.viewContext.fetch(fetchedTaches)
            }
            catch {
                debugPrint("Could not load the items from CoreData : \(error.localizedDescription)")
            }
        }
    }
    
    func toggleCheckItem(item: Tache){
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
