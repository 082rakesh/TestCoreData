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

    var placesRecords: [Place] = []

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
        
        let networkManager = CountryManager()
        networkManager.getCountryList { (countries, error) in
            
            guard let lMoview = countries else {
                return
            }
            
            DispatchQueue.main.async {
                for places in lMoview {
                    self.save(placeName: places)
                }
            }
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
        
        cell.name.text = places.title ?? " Not Title"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func save(placeName: Fact) {
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Place")
        fetchRequest.predicate = NSPredicate(format: "title == %@", placeName.title ??  "")
        
        var fetchResult:[Place] = []
        
        do {
             fetchResult = try managedContext.fetch(fetchRequest) as! [Place]
            
            if fetchResult.count == 0 {
                let place = Place.init(entity: NSEntityDescription.entity(forEntityName: "Place", in:managedContext)!, insertInto: managedContext)
                
                place.setValue(placeName.title, forKey: "title")
                place.setValue(placeName.imageHref, forKey: "imageurl")
                place.setValue(placeName.description, forKey: "discription")
                
                do {
                    try managedContext.save()
                    placesRecords.append(place)
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }else{
                for places in fetchResult {
                    if places.title != placeName.title{
                        
                        let place = Place.init(entity: NSEntityDescription.entity(forEntityName: "Place", in:managedContext)!, insertInto: managedContext)
                        
                        place.setValue(placeName.title, forKey: "title")
                        place.setValue(placeName.imageHref, forKey: "imageurl")
                        place.setValue(placeName.description, forKey: "discription")
                        
                        do {
                            try managedContext.save()
                            placesRecords.append(place)
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        
                    }
                }
            }
            
            self.recordTableView.reloadData()

           
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

