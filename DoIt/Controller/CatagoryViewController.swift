//
//  CatagoryViewController.swift
//  DoIt
//
//  Created by iem on 25/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit
import CoreData

class CatagoryViewController: UITableViewController {

    let dataManager : DataManager = DataManager<Categorie>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.getItems().count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showToDoList" {
            if let destVC = segue.destination as? ListViewController  {
                let cell = sender as! UITableViewCell
                destVC.category = dataManager.getItem(index: (self.tableView.indexPath(for: cell)?.row)!)
            }
        }
        else if segue.identifier == "addCategory" {
            if let navVC = segue.destination as? UINavigationController, let destVC = navVC.topViewController as? AddCategoryViewController {
                destVC.delegate = self
            }
        }
        else if segue.identifier == "editCategory" {
            if let navVC = segue.destination as? UINavigationController, let destVC = navVC.topViewController as? AddCategoryViewController {
                let cell = sender as! UITableViewCell
                destVC.delegate = self
                destVC.categoryToEdit = dataManager.getItem(index:(tableView.indexPath(for: cell)?.row)!)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for : indexPath)
        let item = dataManager.getItem(index: indexPath.row)
        cell.textLabel?.text = item.nom
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = self.dataManager.getItem(index: indexPath.row)
        dataManager.removeItem(item: item)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
}

extension CatagoryViewController : AddCategoryViewControllerDelegate {
    func addCategoryViewControllerDidCancel(_ controller: AddCategoryViewController){
        controller.dismiss(animated: true)
    }
    
    func addCategoryViewController(_ controller: AddCategoryViewController, didFinishAddingCategory category: String){
        controller.dismiss(animated: true)
        let categorie = Categorie(context: self.dataManager.persistentContainer.viewContext)
        categorie.nom = category
        self.dataManager.addItem(item: categorie)
        tableView.reloadData()
        
    }
    
    func addCategoryViewController(_ controller: AddCategoryViewController, didFinishEditingCategory category: Categorie){
        controller.dismiss(animated: true)
        let index = IndexPath(item : dataManager.cachedItems.index(where:{ $0 === category })!, section : 0)
        tableView.reloadRows(at: [index] , with: UITableViewRowAnimation.none)
        tableView.reloadData()
    }
}
