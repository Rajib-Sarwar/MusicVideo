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
        
        reachabilityStatusChanged()
        
        //Call API
        let api = APIManager()
        api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=100/json", completion: didLoadData)
    }
    
    
    func didLoadData(videos: [Videos]) {
        
        print(reachabilityStatus)
        
        self.videos = videos
        
        for (index, item) in videos.enumerate() {
            print("\(index) : ")
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
        case NOACCESS : view.backgroundColor = UIColor.redColor()
        navigationController?.navigationBar.layer.backgroundColor = UIColor.redColor().CGColor
        navigationController?.toolbar.barTintColor = UIColor.redColor()
        case WIFI : view.backgroundColor = UIColor.greenColor()
        navigationController?.navigationBar.layer.backgroundColor = UIColor.greenColor().CGColor
        navigationController?.toolbar.barTintColor = UIColor.greenColor()
        case WWAN : view.backgroundColor = UIColor.yellowColor()
        navigationController?.navigationBar.layer.backgroundColor = UIColor.yellowColor().CGColor
        navigationController?.toolbar.barTintColor = UIColor.yellowColor()
        default: return
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row + 1)"
        cell.detailTextLabel?.text = videos[indexPath.row].vName
        
        return cell
    }
}
