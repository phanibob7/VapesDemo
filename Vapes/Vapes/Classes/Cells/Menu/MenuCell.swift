//
//  MenuCell.swift
//  Vapes
//
//  Created by phanindra on 12/09/18.
//  Copyright © 2018 Aadhan. All rights reserved.
//

import UIKit

struct MenuItem {
    var title: String
    var isSubMenu: Bool
    var isExpandable: Bool
    var urlStr: String
    
    init(title: String, urlStr: String) {
        self.title = title
        self.urlStr = urlStr
        self.isSubMenu = false
        self.isExpandable = false
    }
    
    init(title: String, urlStr: String, isSubMenu: Bool) {
        self.title = title
        self.urlStr = urlStr
        self.isSubMenu = isSubMenu
        self.isExpandable = false
    }
    
    init(title: String, urlStr: String, isExpandable: Bool) {
        self.title = title
        self.urlStr = urlStr
        self.isSubMenu = false
        self.isExpandable = isExpandable
    }
    
    init(title: String, urlStr: String, isSubMenu: Bool, isExpandable: Bool) {
        self.title = title
        self.urlStr = urlStr
        self.isSubMenu = isSubMenu
        self.isExpandable = isExpandable
    }
}

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var collapseView: UIView!
    @IBOutlet weak var collapseBtn: UIButton!
    
    // Constraints
    @IBOutlet weak var itemLblLeftSpace: NSLayoutConstraint!
    @IBOutlet weak var collapseViewWidth: NSLayoutConstraint!
    
    var menuItem: MenuItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        setFonts()
    }
    
    fileprivate func setFonts() {
        itemLbl.font = UIFont.appBoldFontWithSize(size: 18)
    }
    
    func updateData() {
        guard let menuItem = self.menuItem  else { return }
        
        itemLbl.text = menuItem.title.uppercased()
        collapseView.isHidden = !menuItem.isExpandable
        collapseViewWidth.constant = menuItem.isSubMenu ? 0 : 49
        itemLblLeftSpace.constant = menuItem.isSubMenu ? 40 : 20
    }
    
}
