//
//  MenuVC.swift
//  Vapes
//
//  Created by phanindra on 12/09/18.
//  Copyright © 2018 Aadhan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

enum LeftMenu: Int {
    case home = 0
    case news
    case types
    case guides
    case vapeReviews
    case coupons
    case freebies
}

class MenuVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var menuArr: [MenuItem] = [
        MenuItem(title: "Home", urlStr: HOME),
        MenuItem(title: "News", urlStr: NEWS),
        MenuItem(title: "Types", urlStr: TYPES, isExpandable: true),
        MenuItem(title: "Guides", urlStr: GUIDES),
        MenuItem(title: "Vape Reviews", urlStr: VAPES_REVIEWS),
        MenuItem(title: "Coupons", urlStr: COUPONS),
        MenuItem(title: "Freebies", urlStr: "")]
    
    var menuWithTypesArr: [MenuItem] = [
        MenuItem(title: "Home", urlStr: HOME),
        MenuItem(title: "News", urlStr: NEWS),
        MenuItem(title: "Types", urlStr: TYPES, isExpandable: true),
        MenuItem(title: "Accessories", urlStr: ACCESSORIES, isSubMenu: true),
        MenuItem(title: "Atomizers", urlStr: ATOMIZERS, isSubMenu: true),
        MenuItem(title: "Box Mods", urlStr: BOX_MODS, isSubMenu: true),
        MenuItem(title: "Cartomizers", urlStr: CARTOMIZERS, isSubMenu: true),
        MenuItem(title: "Battery/Chargers", urlStr: CHARGES, isSubMenu: true),
        MenuItem(title: "Clearomizers", urlStr: CLEAROMIZERS, isSubMenu: true),
        MenuItem(title: "E-Liquid", urlStr: E_LIQUID, isSubMenu: true),
        MenuItem(title: "Mechanical Mods", urlStr: MECHANICAL_MODS, isSubMenu: true),
        MenuItem(title: "Starter Kits", urlStr: STARTER_KITS, isSubMenu: true),
        MenuItem(title: "Guides", urlStr: GUIDES),
        MenuItem(title: "Vape Reviews", urlStr: VAPES_REVIEWS),
        MenuItem(title: "Coupons", urlStr: COUPONS),
        MenuItem(title: "Freebies", urlStr: FREEBIES)]
    
    var menuVCs: [String: UIViewController] = [:]
    
    var home: UIViewController! // Default
    
    // To show types in list
    var isShowingTypes: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register table view
        tableView.registerCellNib(MenuCell.self)
        tableView.removeBottomCells()
        createVCs()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func showTypes(_ sender: UIButton) {
        isShowingTypes = !isShowingTypes
        tableView.reloadData()
    }
    
    func createVCs() {
        createFreebiesVC()
        
        menuWithTypesArr.forEach { (menuItem) in
            if let _ = menuVCs[menuItem.title] {} else {
                menuVCs[menuItem.title] = UINavigationController(rootViewController: AppDelegate.createFeedTableVC(feedStr: menuItem.urlStr, title: menuItem.title, isHome: false))
            }
        }
    }
    
    func createFreebiesVC() {
        let freebiesVC: VapeDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VapeDetailVC") as! VapeDetailVC
        freebiesVC.urlStr = FREEBIES
        menuVCs["Freebies"] = UINavigationController(rootViewController: freebiesVC)
    }
}

// MARK: - Table view data source
extension MenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingTypes ? menuWithTypesArr.count : menuArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MenuCell = tableView.dequeueReusableCell(withIdentifier: menuCellId, for: indexPath) as? MenuCell else { return UITableViewCell() }
        cell.menuItem = isShowingTypes ? menuWithTypesArr[indexPath.row] : menuArr[indexPath.row]
        cell.updateData()
        
        if indexPath.row == 2 { // Types
            cell.collapseBtn.setTitle(isShowingTypes ? "-" : "+", for: .normal)
            cell.collapseBtn.addTarget(self, action: #selector(showTypes(_:)), for: .touchUpInside)
        }
        
        return cell
    }
}

// MARK: - Table view delegate
extension MenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedMenu: MenuItem!
        
        if isShowingTypes {
            selectedMenu = menuWithTypesArr[indexPath.row]
        } else {
            selectedMenu = menuArr[indexPath.row]
        }
        
        if let vc = menuVCs[selectedMenu.title] {
            self.slideMenuController()?.changeMainViewController(vc, close: true)
        }
    }
}





