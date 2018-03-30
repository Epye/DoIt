//
//  ViewController.swift
//  DoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items = ["Pain", "Lait", "Jambon", "Fromage"]
    
    var items2 = [Item]()
    
    var documentDirectory: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
    var dataFileUrl: URL = URL(fileURLWithPath: "")
    let fileName="data.json"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataFileUrl=documentDirectory.appendingPathComponent(fileName)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createItems()
    }
    
    func createItems(){
        for item in items {
            items2.append(Item(name: item))
        }
    }
    
    func saveData(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do{
            let data = try encoder.encode(items2)
            try data.write(to: dataFileUrl)
        } catch{
            
        }
    }
    
    func loadData(){
        let decoder=JSONDecoder()
        do{
            let data = try String(contentsOf: dataFileUrl, encoding: String.Encoding.utf8).data(using: String.Encoding.utf8)
            items2 = try decoder.decode([Item].self, from: data!)
        }catch {
            
        }
    }
    
    //MARK: Actions
    @IBAction func addAction(_ sender: Any) {
        let alertController = UIAlertController(title: "DoIt", message: "New item", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let text = alertController.textFields?.first?.text
            let item = Item(name: text!)
            self.items2.append(item)
            self.tableView.reloadData()
            self.saveData()
        })
        alertController.addTextField{(textField) in
            textField.placeholder = "Name"
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func editAction(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
}

extension ListViewController:  UITableViewDataSource, UITableViewDelegate {
   
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCellIdentifier")
        let item = items2[indexPath.row]
        cell?.textLabel?.text = item.name
        cell?.accessoryType = item.checked ? .checkmark : .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceItem = items2.remove(at: sourceIndexPath.row)
        items2.insert(sourceItem, at: destinationIndexPath.row)
        self.saveData()
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        items2[indexPath.row].checked = !items2[indexPath.row].checked
        tableView.reloadRows(at: [indexPath], with: .automatic)
        self.saveData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        items2.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        self.saveData()
    }
}

