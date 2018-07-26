//
//  ViewController.swift
//  TestCoreData
//
//  Created by r.f.kumar.mishra on 25/07/18.
//  Copyright © 2018 r.f.kumar.mishra. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var recordTableView: UITableView!
//    var records: [Fact] = []
//    var placeData: Place?
    var placesRecords: [Place] = []

    
    
   // fileprivate let coreDataManager = CoreDataManager(modelName: "TestCoreData")
    
//    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Place> = {
//        // Initialize Fetch Request
//        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
//
//        //            // Add Sort Descriptors
//        //            let sortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
//        //            fetchRequest.sortDescriptors = [sortDescriptor]
//
//        // Initialize Fetched Results Controller
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//
//        // Configure Fetched Results Controller
//        fetchedResultsController.delegate = self
//
//        return fetchedResultsController
//    }()

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Place")

        do {
            placesRecords = try managedContext.fetch(fetchRequest) as! [Place]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    
        if placesRecords.count == 0 {
            let networkManager = CountryManager()
            networkManager.getCountryList { (countries, error) in
                
                guard let lMoview = countries else {
                    return
                }
                                
                for places in lMoview {
                    
                    let place = Place.init(entity: NSEntityDescription.entity(forEntityName: "Place", in:managedContext)!, insertInto: managedContext)

                    place.title = places.title
                    place.discription = places.description
                    place.imageurl = places.imageHref
                    self.save(placeName: place)
                }
                
                DispatchQueue.main.async {
                    self.recordTableView.reloadData()
                }
                
            }
        }else{
            print("placesRecords count : ", placesRecords.count)

        }
    
        
        
        
        
    }

    
    // MARK: Table delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "reusecell"
        let cell:CustomReordsCell = (self.recordTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CustomReordsCell?)!
        
        let places = placesRecords[indexPath.row]
        
        if let image1 = places.imageurl{
            cell.placesView.downloadedFrom(link: image1)
        }
        cell.name.text = places.title
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
//    func saveRecords() {
//       let lplace =  records[0]
//        placeData?.title = lplace.title
//        placeData?.imageurl = lplace.imageHref
//        placeData?.discription = lplace.description
//    }
    
    
    func save(placeName: Place) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Place", in: managedContext)!
        let place = NSManagedObject(entity: entity, insertInto: managedContext)
        
        place.setValue(placeName.title, forKey: "title")
        place.setValue(placeName.imageurl, forKey: "imageurl")
        place.setValue(placeName.discription, forKey: "discription")

        
        do {
            try managedContext.save()
            placesRecords.append(place as! Place)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

