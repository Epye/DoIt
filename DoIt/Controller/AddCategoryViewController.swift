//
//  AddCategoryViewController.swift
//  DoIt
//
//  Created by iem on 25/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class AddCategoryViewController: UITableViewController, UITextFieldDelegate {

    var delegate : AddCategoryViewControllerDelegate!
    var categoryToEdit : Categorie!
    @IBOutlet weak var textFieldSaisieCategory: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let categoryEdit = categoryToEdit {
            self.navigationItem.title = "Edit Category"
            textFieldSaisieCategory.text = categoryEdit.nom
        }
        
        textFieldSaisieCategory.delegate = self
    }
    
    @IBAction func done() {
        if let category = textFieldSaisieCategory.text {
            if (categoryToEdit) != nil {
                categoryToEdit.nom = category
                delegate.addCategoryViewController(self, didFinishEditingCategory: categoryToEdit)
            } else {
                delegate.addCategoryViewController(self, didFinishAddingCategory: category)
            }
        }
    }
    
    
    @IBAction func cancel() {
        delegate.addCategoryViewControllerDidCancel(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        textFieldSaisieCategory.delegate = self
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        textFieldSaisieCategory.becomeFirstResponder()
        if !((textFieldSaisieCategory.text?.isEmpty)!){
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldString = textField.text {
            let newString = oldString.replacingCharacters(in: Range(range, in: oldString)!, with: string)
            if newString.isEmpty{
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
            else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
            return true
        }
        return false
    }
}

protocol AddCategoryViewControllerDelegate : class {
    func addCategoryViewControllerDidCancel(_ controller: AddCategoryViewController)
    func addCategoryViewController(_ controller: AddCategoryViewController, didFinishAddingCategory category: String)
    func addCategoryViewController(_ controller: AddCategoryViewController, didFinishEditingCategory category: Categorie)
    
}
