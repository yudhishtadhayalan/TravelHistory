//
//  ViewController.swift
//  Location_Time_Interval
//
//  Created by Yudhishta Dhayalan on 07/09/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tblOutlet: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var models = [LocationListItem]()
    
    var customLocations  = [LocationListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOutlet.delegate = self
        tblOutlet.dataSource = self
        getAllItem()
        tblOutlet.reloadData()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllItem()
        tblOutlet.reloadData()
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellLocation = tblOutlet.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        let item = customLocations[indexPath.row]
        cellLocation.lblOutlet.text = "Location: \nLattitude:  \(item.lattitude ?? "") \nLongitude:  \(item.longitude ?? "")"
        return cellLocation
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected the row")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}


extension ViewController {
    
    //MARK: Get All Item --------------->
    
    func getAllItem() {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationListItem")
            let results  = try context.fetch(fetchRequest)
            let locations = results as! [LocationListItem]
            customLocations = locations
            DispatchQueue.main.async {
                self.tblOutlet.reloadData()
            }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
    }
    
}


//MARK: Checking when app goes background and again backs to Active state. --------------->
extension ViewController {
    
    @objc func appBecomeActive() {
        print("App become active")
        getAllItem()
        tblOutlet.reloadData()
    }
    
}
