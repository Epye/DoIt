//
//  AddItemViewController.swift
//  DoIt
//
//  Created by iem on 06/04/2018.
//  Copyright © 2018 iem. All rights reserved.
//

import UIKit
import CoreData

enum ViewState: String{
    case isEdit = "edit"
    case isAdd = "add"
}

class AddItemViewController : UITableViewController, UITextFieldDelegate {
    
    var delegate : AddItemViewControllerDelegate?
    var state: ViewState!
    var tacheToEdit : Tache!
    var dataManager: DataManager = DataManager<Categorie>()
    var pickerData : [String] = [String]()
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var pickerCategories: UIPickerView!
    @IBOutlet weak var textFieldDescription: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: Actions
    @IBAction func done() {
        if let nomTache = textFieldName.text {
            if (tacheToEdit) != nil {
                tacheToEdit.nom = nomTache
                tacheToEdit.descriptio = textFieldDescription.text
                delegate?.addItem(self, didFinishEditingItem: tacheToEdit)
            } else {
                let item = Tache(context: context)
                item.nom = nomTache
                item.checked = false
                let order = self.dataManager.cachedItems.count + 1
                item.order = Int64(order)
                item.descriptio = textFieldDescription.text!
                let tag = Tag(context: context)
                tag.nom = "yellow"
                tag.couleur = UIColor.yellow
                item.tag = tag
                delegate?.addItem(self, didFinishAddingItem: item)
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
        if indexPath.row == 0 && indexPath.section == 3 {
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
        
        self.textFieldDescription.text = ""
        
        if state == .isEdit {
            self.navigationItem.title = "Edit Item"
            self.textFieldName.text = tacheToEdit.nom
            self.textFieldDescription.text = tacheToEdit.descriptio
        }

        textFieldName.delegate = self
        pickerCategories.delegate = self
        pickerCategories.dataSource = self
        for item in dataManager.getItems() {
            pickerData.append(item.nom!)
        }
        textFieldDescription.delegate = self
    }

    //MARK: User Experience
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == textFieldName){
            textField.resignFirstResponder()
            textFieldDescription.becomeFirstResponder()
        }else if (textField == textFieldDescription){
            textField.resignFirstResponder()
        }
        return true;
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickColor" {
            let dest = segue.destination as? ColorPickerViewController
            dest?.delegate = self
        }
    }
}

//MARK: Protocols
protocol AddItemViewControllerDelegate : class {
    func AddItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItem(_ controller: AddItemViewController, didFinishAddingItem item: Tache)
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
        self.tableView.reloadData()
        dismiss(animated:true, completion: nil)
    }
}

extension AddItemViewController: ColorPickerViewControllerDelegate {
    func ColorPickerViewControllerDidChoose(color: Color) {
        self.navigationController?.popViewController(animated: true)
        self.tableView.cellForRow(at: IndexPath(row: 0, section: 4))?.detailTextLabel?.text = color.name
    }
}


extension AddItemViewController :UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    

    
}
