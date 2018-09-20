//
//  BasicTableVC.swift
//  Vapes
//
//  Created by phanindra on 14/09/18.
//  Copyright © 2018 Aadhan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import FeedKit
import NVActivityIndicatorView

class BasicTableVC: UITableViewController, NVActivityIndicatorViewable {
    
    var feed: RSSFeed?
    var feedUrlStr: String? {
        didSet {
            
        }
    }
    var titleStr: String = ""
    var isHome: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getFeed(isRefresh: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = titleStr
        addMenuButtonItem()
    }
    
    func setupViews() {
        tableView.registerCellNibs([ImageWithTitleCell.self, FeaturedCell.self])
        tableView.separatorStyle = .none
        addRefreshControl()
        
        defer {
            setupLayout()
        }
    }
    
    func setupLayout() {
    }
}

//MARK: Data source and delegate
extension BasicTableVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = feed?.items?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImageWithTitleCell = tableView.dequeueReusableCell(withIdentifier: imageWithTitleCellId, for: indexPath) as! ImageWithTitleCell
        cell.selectionStyle = .none
        
        if let currentItem: RSSFeedItem = feed?.items![indexPath.row] {
            cell.item = currentItem
            cell.updateData()
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC: VapeDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VapeDetailVC") as! VapeDetailVC
        if let currentItem: RSSFeedItem = feed?.items![indexPath.row] {
            detailVC.item = currentItem
        }
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: Network related stuff
extension BasicTableVC {
    func getFeed(isRefresh: Bool) {
        guard let urlStr = feedUrlStr, let url = URL(string: urlStr) else {
            print("ERROR: Unable to construct url")
            return
        }
        
        let parser = FeedParser(URL: url)
        
        if isRefresh {
            if #available(iOS 10.0, *) {
                self.tableView.refreshControl?.beginRefreshing()
            } else {
                if let refreshView = self.tableView.backgroundView as? UIRefreshControl {
                    refreshView.beginRefreshing()
                }
            }
        } else {
            startAnimating(CGSize(width: 30, height: 30), message: "", type: .circleStrokeSpin,  color: UIColor.black, fadeInAnimation: nil)
        }
        parser.parseAsync {[weak self] (result) in
            guard let rssFeed = result.rssFeed, result.isSuccess else {
                print("ERROR: Unable to get RSS feed")
                self?.stopAnimating(nil)
                return
            }
            
            self?.feed = rssFeed
            
            DispatchQueue.main.async {
                if isRefresh {
                    if #available(iOS 10.0, *) {
                        self?.tableView.refreshControl?.endRefreshing()
                    } else {
                        if let refreshView = self?.tableView.backgroundView as? UIRefreshControl {
                            refreshView.endRefreshing()
                        }
                    }
                } else {
                    self?.stopAnimating(nil)
                }
                
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK: Refresh control
extension BasicTableVC {
    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.black
        
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        getFeed(isRefresh: true)
    }
}

