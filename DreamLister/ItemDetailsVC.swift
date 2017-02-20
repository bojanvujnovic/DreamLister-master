//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Mac on 2/19/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImage: UIImageView!
    
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.storePicker.dataSource = self
        self.storePicker.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        //Removes Text for BackBarButtonItem
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target:  nil, action: nil)
        }
        
//        let store = Store(context: context)
//        store.name = "Best Buy"
//        let store2 = Store(context: context)
//        store2.name = "Tesla Dealership "
//        let store3 = Store(context: context)
//        store3.name = "fries Electronics"
//        let store4 = Store(context: context)
//        store4.name = "Target"
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        let store6 = Store(context: context)
//        store6.name = "K Mart"
//        //Data saved to CoreData
//        appDelegate.saveContext()
        self.getStores()
        if itemToEdit != nil {
            self.loadItemData()
        }
    }
    
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
 
    func getStores() {
        //Fetching Item data from Database(SQLite)
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            //Fetch data from CoreData
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch let error {
            print(error.localizedDescription)
        }

    }
    //Saves to CoreData
    @IBAction func savedPressed(_ sender: UIButton) {
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImage.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        
        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        if let priceString = priceField.text, let price = Double(priceString) {
            item.price = price
        }
        if let details = detailsField.text {
            item.details = details
        }
        //Assigns a Store selected from storePicker
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        appDelegate.saveContext()
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            thumbImage.image = item.toImage?.image as! UIImage?
             
            if let store = item.toStore {
                //Gives an index for an element in Stores array equal to the store
                let index = stores.enumerated().filter({ $1.name == store.name  })[0].offset
                storePicker.selectRow(index, inComponent: 0, animated: false)
            }
        }        
    }
    
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if let item = itemToEdit {
            context.delete(item )
            appDelegate.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        //Presents ImagePickerController
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
             thumbImage.image = image
             imagePicker.dismiss(animated: true, completion: nil)
        } else {
             print("Something went wrong")
        }
        
    }
      
    
    
    
}
