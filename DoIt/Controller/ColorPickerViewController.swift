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
    
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
}

class ColorPickerViewController: UITableViewController {

    var delegate: ColorPickerViewControllerDelegate!
    
    var listColors: Array = [Color(name: "white", color: UIColor.white), Color(name: "yellow", color: UIColor.yellow), Color(name: "blue", color: UIColor.blue), Color(name: "green", color: UIColor.green), Color(name: "red", color: UIColor.red), Color(name: "purple", color: UIColor.purple), Color(name: "magenta", color: UIColor.magenta)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listColors.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorPickerTableViewCell
        cell.name.text = listColors[indexPath.row].name
        cell.color.backgroundColor = listColors[indexPath.row].color
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.ColorPickerViewControllerDidChoose(color: listColors[indexPath.row])
    }

}

//MARK: Protocols
protocol ColorPickerViewControllerDelegate : class {
    func ColorPickerViewControllerDidChoose(color: Color)
}
