//
//  FeaturedCell.swift
//  Vapes
//
//  Created by phanindra on 14/09/18.
//  Copyright © 2018 Aadhan. All rights reserved.
//

import UIKit

class FeaturedCell: UITableViewCell {

    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var halfLeftImg: UIImageView!
    @IBOutlet weak var halfRightImg: UIImageView!
    
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var halfLeftBtn: UIButton!
    @IBOutlet weak var halfRightBtn: UIButton!
    
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var halfLeftLbl: UILabel!
    @IBOutlet weak var halfRightLbl: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
