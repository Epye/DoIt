//
//  AddItemViewController.swift
//  DoIt
//
//  Created by iem on 06/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import Foundation
import UIKit

enum ViewState: String{
    case isEdit = "edit"
    case isAdd = "add"
}

class AddItemViewController : UITableViewController, UITextFieldDelegate{
    
    var delegate : AddItemViewControllerDelegate?
    var state: ViewState!
    var tacheToEdit : Tache!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldCategory: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: Actions
    @IBAction func done() {
        if let nomTache = textFieldName.text {
            if (tacheToEdit) != nil {
                tacheToEdit.nom = nomTache
                delegate?.addItem(self, didFinishEditingItem: tacheToEdit)
            } else {
                delegate?.addItem(self, didFinishAddingItem: nomTache)
            }
        }
    }
    
    @IBAction func cancel() {
        delegate?.AddItemViewControllerDidCancel(self)
    }
    
    //MARK: TableView
    let picker = UIImagePickerController()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 && indexPath.section == 2 {
            let alertController = UIAlertController(title: "DoIt", message: "Add a photo from Library or take it?", preferredStyle: .alert)
            
            let libraryAction = UIAlertAction(title: "Library", style: .default, handler: { (action) in
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(self.picker, animated: true, completion: nil)
            })
            let photoAction = UIAlertAction(title: "Photo", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    self.picker.allowsEditing = false
                    self.picker.sourceType = .camera
                    self.picker.cameraCaptureMode = .photo
                    self.picker.modalPresentationStyle = .fullScreen
                    self.present(self.picker, animated: true, completion: nil)
                } else {
                    print("NO")
                }
            })
            alertController.addAction(libraryAction)
            alertController.addAction(photoAction)
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        textFieldName.delegate = self
        textFieldCategory.delegate = self
    }

    //MARK: User Experience
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField.returnKeyType == UIReturnKeyType.next){
            textField.resignFirstResponder()
            textFieldCategory.becomeFirstResponder()
        }else if (textField.returnKeyType == UIReturnKeyType.done){
            textField.resignFirstResponder()
        }
        return true;
    }
    
}

//MARK: Protocols
protocol AddItemViewControllerDelegate : class {
    func AddItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItem(_ controller: AddItemViewController, didFinishAddingItem name: String)
    func addItem(_ controller: AddItemViewController, didFinishEditingItem tache: Tache)
}

//MARK: Extensions
extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFit
        imageView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
}
