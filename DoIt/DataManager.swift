//
//  DataManager.swift
//  DoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation

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
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do{
            let data = try encoder.encode(cachedItems)
            try data.write(to: dataFileUrl)
        } catch{
            
        }
    }
    
    func loadData(){
        let decoder=JSONDecoder()
        do{
            let data = try String(contentsOf: dataFileUrl, encoding: String.Encoding.utf8).data(using: String.Encoding.utf8)
            cachedItems = try decoder.decode([Item].self, from: data!)
            items = cachedItems
        }catch {
            
        }
    }
    
    func addItem(text: String){
        let item = Item(name: text)
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
            items = cachedItems.filter{ $0.name.range(of: filter, options: .caseInsensitive) != nil }
        }
    }
    
    func toggleCheckItem(index: Int){
        let item = items[index]
        cachedItems = cachedItems.map({ if $0.name == item.name { $0.checked = !$0.checked }; return $0 })
        items[index].checked = !items[index].checked
        saveData()
    }
}
