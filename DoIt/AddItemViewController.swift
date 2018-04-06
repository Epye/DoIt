//
//  AddItemViewController.swift
//  DoIt
//
//  Created by iem on 06/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation
import UIKit

class AddItemViewController : UITableViewController {
    
    var delegate : AddItemViewControllerDelegate?
    
}

protocol AddItemViewControllerDelegate : class {
    func addItem()
}
