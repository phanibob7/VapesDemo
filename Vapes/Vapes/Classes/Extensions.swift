//
//  Extensions.swift
//  Vapes
//
//  Created by phanindra on 12/09/18.
//  Copyright © 2018 Aadhan. All rights reserved.
//

import UIKit

extension UIViewController {

    // slide out menu
    func addMenuButtonItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.appBoldFontWithSize(size: 18)]

    }
}

extension UITableView {
    func removeBottomCells() {
        self.tableFooterView = UIView()
    }

    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String(describing: cellClass.self)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String(describing: cellClass.self)
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func registerCellNibs(_ cellClasses: [AnyClass]) {
        cellClasses.forEach({
            let identifier = String(describing: $0.self)
            self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        })
    }
    
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String(describing: viewClass.self)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String(describing: viewClass.self)
        self.register(UINib(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
    }
}

// UIView constraints
extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIFont {    
    class func appLightFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-Light", size: size)!
    }

    class func appRegularFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-Regular", size: size)!
    }
    
    class func appBoldFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-Bold", size: size)!
    }
}

