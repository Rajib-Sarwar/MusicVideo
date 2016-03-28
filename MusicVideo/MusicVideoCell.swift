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
        musicImage.image = UIImage(named: "imageNotAvailable")
        
        
        
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
