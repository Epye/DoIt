//
//  ViewController.swift
//  DoIt
//
//  Created by iem on 30/03/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let dataManager: DataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    //MARK: Actions
    @IBAction func addAction(_ sender: Any) {
        let alertController = UIAlertController(title: "DoIt", message: "New item", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            let text = alertController.textFields?.first?.text
            if !(text?.isEmpty)!{
                self.dataManager.addItem(text: text!)
                self.dataManager.filterItems(filter: self.searchBar.text!)
            }
            
            self.tableView.reloadData()
        })
        alertController.addTextField{(textField) in
            textField.placeholder = "Name"
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        
        let buttonType: UIBarButtonSystemItem = tableView.isEditing ? .done : .edit
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: buttonType, target: self, action: #selector(editAction(_:)))
        
        navigationItem.setLeftBarButton(leftButton, animated: true)
    }
    
    //MARK: User Experience
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
    }
}

extension ListViewController:  UITableViewDataSource, UITableViewDelegate {
   
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.getItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCellIdentifier") as! ListTableViewCell
        let item = dataManager.getItem(index: indexPath.row)
        cell.labelName?.text = item.nom
        cell.labelCheckmark.isHidden = item.checked ? false : true
        if let tag = item.tag {
            cell.backgroundColor = tag.couleur as? UIColor
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataManager.moveItem(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dataManager.toggleCheckItem(index: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataManager.removeItem(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            let navigationController = segue.destination as? UINavigationController,
            let destination = navigationController.topViewController as? AddItemViewController {
            
            if identifier == "addItem" {
                destination.delegate = self
                destination.state = ViewState.isAdd
            } else if identifier == "editItem" {
                destination.delegate = self
                destination.state = ViewState.isEdit
            }
        }
    }
}

extension ListViewController {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataManager.filterItems(filter: searchText)
        tableView.reloadData()
    }
}

extension ListViewController : AddItemViewControllerDelegate{
    func addItem(_ controller: AddItemViewController, didFinishAddingItem name: String) {
        controller.dismiss(animated: true)
        dataManager.addItem(text : name)
        tableView.reloadData()
    }
    
    
    func addItem(_ controller: AddItemViewController, didFinishEditingItem tache: Tache) {
        
    }
    
    
    func AddItemViewControllerDidCancel(_ controller: AddItemViewController) {
        controller.dismiss(animated: true)
    }
    
}
