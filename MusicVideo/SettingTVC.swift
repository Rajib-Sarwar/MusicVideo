//
//  SettingTVC.swift
//  MusicVideo
//
//  Created by Ayon Chowdhury on 4/1/16.
//  Copyright © 2016 Ayon Chowdhury. All rights reserved.
//

import UIKit

class SettingTVC: UITableViewController {

    @IBOutlet weak var aboutDisplay: UILabel!
    
    @IBOutlet weak var feedbackDisplay: UILabel!
    
    @IBOutlet weak var securityDisplay: UILabel!
    
    @IBOutlet weak var touchID: UISwitch!
    
    @IBOutlet weak var bestImageDisplay: UILabel!
    
    @IBOutlet weak var APICnt: UILabel!
    
    @IBOutlet weak var sliderCnt: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChange", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    func preferredFontChange() {
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        APICnt.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
}
