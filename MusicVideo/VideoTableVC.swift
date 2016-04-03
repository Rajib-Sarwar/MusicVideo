//
//  VideoTableVC.swift
//  MusicVideo
//
//  Created by Ayon Chowdhury on 3/26/16.
//  Copyright © 2016 Ayon Chowdhury. All rights reserved.
//

import UIKit

class VideoTableVC: UITableViewController, UISearchResultsUpdating {

    var videos = [Videos]()
    
    var filterSearch = [Videos]()
    
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    
    
    var limit = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
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
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        title = ("The iTunes Top \(limit) Music Videos")
        
        resultSearchController.searchResultsUpdater = self
        definesPresentationContext = true
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search for Artist"
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        
        tableView.tableHeaderView = resultSearchController.searchBar
        
        
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
    
    
    @IBAction func refresh(sender: UIRefreshControl) {
        refreshControl?.endRefreshing()
        
        if resultSearchController.active {
            refreshControl?.attributedTitle = NSAttributedString(string: "No refresh allowed in search")
        } else {
            runAPI()
        }
        
    }
    
    func getAPICount() {
        if (NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil) {
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            limit = theValue
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDte = formatter.stringFromDate(NSDate())
        
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDte)")
    }
    
    func runAPI() {
        
        getAPICount()
        
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
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
       
        if resultSearchController.active {
            return filterSearch.count
        }
        
        return videos.count;
    }
    
    private struct storyboard {
        static let cellReuseableIdentifier = "cell"
        static let segueIdentifier = "musicDetail"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboard.cellReuseableIdentifier, forIndexPath: indexPath) as! MusicVideoCell
        
        if resultSearchController.active {
            cell.videos = filterSearch[indexPath.row]
        } else {
            cell.videos = videos[indexPath.row]
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == storyboard.segueIdentifier {
            if let indexpath = tableView.indexPathForSelectedRow {
                let video : Videos
                
                if resultSearchController.active {
                    video = filterSearch[indexpath.row]
                } else {
                    video = videos[indexpath.row]
                }
                
                let dvc = segue.destinationViewController as! MusicDetailViewController
                dvc.videos = video
            }
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchController.searchBar.text!.lowercaseString
        filterSearch(searchController.searchBar.text!)
    }
    
    func filterSearch(searchText: String) {
        filterSearch = videos.filter { videos in
            return videos.vArtist.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
}
