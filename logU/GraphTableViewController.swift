//
//  GraphTableViewController.swift
//  logU
//
//  Created by Brett Alcox on 3/10/16.
//  Copyright © 2016 Brett Alcox. All rights reserved.
//

import UIKit

var liftName: [String]! = []

class GraphTableViewController: UITableViewController {
    
    var nameOfLift: String?
    let url_to_request:String = "https://loguapp.com/swift8.php"
    var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        if shouldUpdateMax {
            if Reachability.isConnectedToNetwork() {
                
                indicator = UIActivityIndicatorView()
                var frame = indicator.frame
                frame.origin.x = view.frame.size.width / 2
                frame.origin.y = (view.frame.size.height / 2) - 40
                indicator.frame = frame
                indicator.activityIndicatorViewStyle = .Gray
                indicator.startAnimating()
                view.addSubview(indicator)
                
                dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                    
                    GraphData().dataOfLifting(self.url_to_request, completion: { jsonString in
                        dataAfter = jsonString
                        dispatch_async(dispatch_get_main_queue()) {
                            self.loadAfter(dataAfter)
                        }
                    })
                }
            }
            shouldUpdateMax = false
        }
        self.tableView.reloadData()

    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func loadAfter(object: Array<Dictionary<String, String>>) {
        dataAfter = object
        
        liftName = []
        
        for i in 0..<dataAfter.count {
            liftName.append(dataAfter[i]["lift"]!)
            print(dataAfter[i]["lift"]!)
        }
        self.tableView.reloadData()
        indicator.stopAnimating()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int
    {
        return liftName.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
        self.tableView.dequeueReusableCellWithIdentifier("cell",
            forIndexPath: indexPath) as! GraphLiftNameCell
        // Sets the text of the Label in the Table View Cell
        
        let lift = liftName[indexPath.row]
        
        aCell.liftNameLabel.text = lift
        return aCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "showGraph") {
            let vc = segue.destinationViewController as! LiftGraphViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.liftName = liftName[indexPath.row]
                vc.navigationItem.title = liftName[indexPath.row]
            }
        }
    }

    
}
