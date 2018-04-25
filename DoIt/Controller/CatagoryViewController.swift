//
//  CatagoryViewController.swift
//  DoIt
//
//  Created by iem on 25/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class CatagoryViewController: UITableViewController {

    let dataManager : DataManager = DataManager<Categorie>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showToDoList" {
            if let destVC = segue.destination as? ListViewController  {
                let cell = sender as! UITableViewCell
                destVC.category = dataManager.getItem(index: (self.tableView.indexPath(for: cell)?.row)!)
            }
        }
        else if segue.identifier == "addCategory" {

        }
        else if segue.identifier == "editCategory" {

        }
    }
}
