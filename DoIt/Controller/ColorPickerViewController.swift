//
//  ColorPickerViewController.swift
//  DoIt
//
//  Created by iem on 25/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit

class Color {
    var name: String
    var color: UIColor!
    
    init(name: String) {
        self.name = name
        self.color = UIColor(named: name)
    }
}

class ColorPickerViewController: UITableViewController {

    var listColors: Array = [Color(name: "white"), Color(name: "yellow"), Color(name: "blue"), Color(name: "green"), Color(name: "red"), Color(name: "purple"), Color(name: "pink")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listColors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = listColors[indexPath.row].name
        return cell
    }

}
