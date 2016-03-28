//
//  MusicVideoCell.swift
//  MusicVideo
//
//  Created by Ayon Chowdhury on 3/28/16.
//  Copyright © 2016 Ayon Chowdhury. All rights reserved.
//

import UIKit

class MusicVideoCell: UITableViewCell {

    var videos: Videos? {
        didSet {
            updateCell()
        }
    }
    
    
    
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var rank: UILabel!
    
    func updateCell() {
        
        musicTitle.text = videos?.vName
        rank.text = ("\(videos!.vRank)")
//        musicImage.image = UIImage(named: "imageNotAvailable")
        
        if videos!.vImageData != nil {
            print("Get data from array ...")
            musicImage.image = UIImage(data: videos!.vImageData!)
        } else {
            GetVideoImage(videos!, imageView: musicImage)
        }
        
    }
    
    func GetVideoImage(video: Videos, imageView: UIImageView) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let data = NSData(contentsOfURL: NSURL(string: video.vImageUrl)!)
            
            var image : UIImage?
            if data != nil {
                video.vImageData = data
                image = UIImage(data: data!)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
