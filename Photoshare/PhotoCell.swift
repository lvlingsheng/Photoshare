//
//  PhotoCell.swift
//  Photoshare
//
//  Created by 吕凌晟 on 16/3/2.
//  Copyright © 2016年 Lingsheng Lyu. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var photoView: UIImageView!
    
    var media:UserMedia!{
        didSet{
            photoView.image = media.image
            captionLabel.text = media.caption
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
