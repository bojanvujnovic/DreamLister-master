//
//  ViewController.swift
//  DreamLister
//
//  Created by Mac on 2/18/17.
//  Copyright © 2017 Boki. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var segment: UISegmentedControl!
    
    var fetchedResultsController: NSFetchedResultsController<Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        //generateTestData()
        self.attemptFetch()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: IndexPath)  {
        //Item from CoreData
        let item = fetchedResultsController.object(at: indexPath)
        cell.configureCell(item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objects = fetchedResultsController.fetchedObjects, objects.count > 0 {
            let item = objects[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC, let item = sender as? Item {
                destination.itemToEdit = item
            }
        }
    }
     //Fetches the Data from CoreData according to Sort descriptor key
    func attemptFetch()  {
        //Fetching Item data from Database(SQLite)
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        //Object will be sorted according to the key argument
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        switch segment.selectedSegmentIndex {
        case 0:   fetchRequest.sortDescriptors = [dateSort]
        case 1:   fetchRequest.sortDescriptors = [priceSort]
        case 2:   fetchRequest.sortDescriptors = [titleSort]
        default: break
        }
        
        //Controller for displaying fetched data from CoreData
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = controller
        self.fetchedResultsController.delegate = self
        do {
            //Fetch data from CoreData
            try controller.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    //SegmentedControl
    @IBAction func segmentChange(_ sender: Any) {
         self.attemptFetch()
        tableView.reloadData()
    }
    
    
    //FetchController delegate method
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    //Listens if an Object is inserted, deleted, updated or moved from CoreData
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        case .update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRow(at: indexPath) as? ItemCell {
                    //Update Cell data
                    configureCell(cell: cell, indexPath: indexPath)
                }
            }
        }
    }
    
    //Generated data in NSManagedObjectContext and saved to Database
    func generateTestData()  {
        //Created Item in NSManagedObjectContext
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "I can't wait until the September event, I hope they will release new MBPs"
        
        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "I can't wait until the September event, I hope they will release new MBPs"
        
        let item3 = Item( context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "I can't wait until the September event, I hope they will release new MBPs"
        
        appDelegate.saveContext()
    }
    
    
    
    
    

}

