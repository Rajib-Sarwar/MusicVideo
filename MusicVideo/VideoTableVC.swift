//
//  VideoTableVC.swift
//  MusicVideo
//
//  Created by Ayon Chowdhury on 3/26/16.
//  Copyright © 2016 Ayon Chowdhury. All rights reserved.
//

import UIKit

class VideoTableVC: UITableViewController {

    var videos = [Videos]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChange", name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        reachabilityStatusChanged()
    }
    
    func preferredFontChange() {
        print("Preferred font has changed.")
    }
    
    func didLoadData(videos: [Videos]) {
        
        print(reachabilityStatus)
        
        self.videos = videos
        
        for item in videos {
            
            print("   name: \(item.vName)")
            print("   artist: \(item.vArtist)")
            print("   price: \(item.vPrice)")
            print("   Release: \(item.vReleaseDte)")
            print("\n")
        }
        
        tableView.reloadData()
    }
    
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NOACCESS :
//            view.backgroundColor = UIColor.redColor()
//            navigationController?.navigationBar.layer.backgroundColor = UIColor.redColor().CGColor
//            navigationController?.toolbar.barTintColor = UIColor.redColor()
            
            dispatch_async( dispatch_get_main_queue()) {
                let alert = UIAlertController(title: NOACCESS, message: "Please make sure you are connected to the internet", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { action -> Void in
                    print("Cancel")
                }
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { action -> Void in
                    print("Delete")
                }
                let okAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
                    print("OK")
                }
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        default:
            if(reachabilityStatus == WWAN) {
//                view.backgroundColor = UIColor.yellowColor()
//                navigationController?.navigationBar.layer.backgroundColor = UIColor.yellowColor().CGColor
//                navigationController?.toolbar.barTintColor = UIColor.yellowColor()
            } else {
//                view.backgroundColor = UIColor.greenColor()
//                navigationController?.navigationBar.layer.backgroundColor = UIColor.greenColor().CGColor
//                navigationController?.toolbar.barTintColor = UIColor.greenColor()
            }
            if videos.count > 0 {
                print("Do not refresh API")
            } else {
                runAPI()
            }
        }
    }
    
    func runAPI() {
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=200/json", completion: didLoadData)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count;
    }
    
    private struct storyboard {
        static let cellReuseableIdentifier = "cell"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseableIdentifier, forIndexPath: indexPath) as! MusicVideoCell
        
        cell.videos = videos[indexPath.row]
        
        return cell
    }
}
