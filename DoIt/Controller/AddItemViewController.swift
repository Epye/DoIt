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

class AddItemViewController : UITableViewController{
    
    var delegate : AddItemViewControllerDelegate?
    var state: ViewState!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldCategory: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
}

protocol AddItemViewControllerDelegate : class {
    func addItem()
}

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
