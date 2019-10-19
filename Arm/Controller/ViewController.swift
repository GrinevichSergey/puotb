//
//  ViewController.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 28/02/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import Parse
import Firebase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FeedModelProtocol, UISearchBarDelegate, UISearchDisplayDelegate  {

   
    var feedItems = NSArray()
    var filteredItems = [String]()

//    var selectedStock : StockModel = StockModel()
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // get()
        tableview.dataSource = self
        tableview.delegate = self

        tableview.tableFooterView = UIView()
        tableview.setContentOffset(CGPoint.zero, animated: true)
        searchBar.delegate = self
        
       
     
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        let feedModel = FeedModel()
        feedModel.delegate = self
        feedModel.downloadItems()
    }
    
   

    func itemsDownloaded(items: NSArray) {
        
        switch segmentView.selectedSegmentIndex {
        case 0:
            feedItems = items
 
            self.tableview.reloadData()
            
        case 1:
            
            print("test")
        default:
            break
        }
       
        
    }
    
    @IBAction func segmentChange(_ sender: Any) {
    
        switch segmentView.selectedSegmentIndex {
        case 0:
             print("test")
   
        case 1:
            print("test")
        default:
            break
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
           return 1
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as UITableViewCell
        let item: StockModel = feedItems[indexPath.row] as! StockModel
   
        cell.textLabel?.text = item.name
        return cell
        
    }
    
   
    
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     //
    
  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        //        i = false
        //        let item: StockModel = feedItems[indexPath.row] as! StockModel
        //        id_ = item.name!
        //
        performSegue(withIdentifier: "armSegue", sender: self)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // получаем View Controller, который является конечным пунктом для segue
               if segue.identifier == "armSegue" {
                    if let VC = segue.destination as? ArmViewController, let selectedArm = tableview.indexPathForSelectedRow?.row {
                        VC.selectedStock = feedItems[selectedArm] as! StockModel
                    }

           }
        
    }
    @IBAction func showAuth(_ sender: Any) {
                do {
                    try Auth.auth().signOut()
                } catch {
                    print(error)
                }
    }
    
}




//
//    func get()  {
//        var jsonResult = NSArray()
//        let url = NSURL(string: "https://api.xpcom.ru/puotb/select3.php")
//        let data = NSData(contentsOf: url! as URL)
//        jsonResult = try! JSONSerialization.jsonObject(with: data! as Data, options:
//            JSONSerialization.ReadingOptions.mutableContainers)  as! NSArray
//
//        var jsonElement = NSDictionary()
//
//        for i in 0 ..< jsonResult.count
//        {
//            jsonElement = jsonResult[i] as! NSDictionary
//
//            if let name = jsonElement["arm_name"] as? String
//            {
//                myMass.append(name)
//
//            }
//        }
//    }
