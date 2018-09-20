//
//  ImageWithTitleCell.swift
//  Vapes
//
//  Created by phanindra on 14/09/18.
//  Copyright © 2018 Aadhan. All rights reserved.
//

import UIKit
import FeedKit
import SDWebImage

struct Item {
    
}

class ImageWithTitleCell: UITableViewCell {

    @IBOutlet weak var defaultImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var authorNameLbl: UILabel!
    @IBOutlet weak var authorSeperatorView: UIView!
    
    var item: RSSFeedItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func setupLayout() {
        // Button rounded rect
        categoryBtn.layer.cornerRadius = 2
        categoryBtn.layer.masksToBounds = true
        
        setupFonts()
    }
    
    func setupFonts() {
        titleLbl.font = UIFont.appRegularFontWithSize(size: 22)
        authorNameLbl.font = UIFont.appRegularFontWithSize(size: 16)
        categoryBtn.titleLabel?.font = UIFont.appRegularFontWithSize(size: 16)
    }
    
    func updateData() {
        guard let itemDict = item else { return }
//        print("Item Dict: \(itemDict)")
        
        let placeHolderImg = UIImage(named: "vapesDummy")!
        
        if let title = itemDict.title {
            titleLbl.text = title
        }
        
        if let author = itemDict.author {
            authorNameLbl.text = author
            authorSeperatorView.isHidden = false
        } else {
            authorNameLbl.text = ""
            authorSeperatorView.isHidden = true
        }
      
        if let category = itemDict.categories?.first?.value {
            categoryBtn.setTitle(category, for: .normal)
        } else {
            categoryBtn.setTitle("News", for: .normal)
        }
        
        defaultImg.image = placeHolderImg
    }
}
