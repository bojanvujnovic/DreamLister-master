//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Mac on 2/19/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleFiled: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    var stores = [Store]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.storePicker.dataSource = self
        self.storePicker.delegate = self

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
    
}
