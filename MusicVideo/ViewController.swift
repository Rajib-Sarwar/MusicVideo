//
//  ViewController.swift
//  MusicVideo
//
//  Created by Ayon Chowdhury on 3/19/16.
//  Copyright © 2016 Ayon Chowdhury. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var videos = [Videos]()
    
    @IBOutlet weak var diaplayLabel: UILabel!
    
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
    }
    
    
    func reachabilityStatusChanged() {
        switch reachabilityStatus {
        case NOACCESS : view.backgroundColor = UIColor.redColor()
        diaplayLabel.text = NOACCESS
        case WIFI : view.backgroundColor = UIColor.greenColor()
        diaplayLabel.text = WIFI
        case WWAN : view.backgroundColor = UIColor.yellowColor()
        diaplayLabel.text = WWAN
        default: return
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }
    
}

