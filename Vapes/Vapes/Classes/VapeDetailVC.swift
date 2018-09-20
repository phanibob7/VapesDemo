//
//  VapeDetailV.swift
//  Vapes
//
//  Created by phanindra on 16/09/18.
//  Copyright © 2018 Aadhan. All rights reserved.
//

import UIKit
import WebKit
import FeedKit

var progressContext = 0
var estimatedProgressKey = "estimatedProgress"

class VapeDetailVC: UIViewController {

    @IBOutlet weak var webHolderView: UIView!
    var webView: WKWebView!
    var item: RSSFeedItem?
    
    var shareBtn: UIBarButtonItem!
    
    var urlStr: String = ""

    var progressView: UIProgressView! = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = .black
        progressView.isHidden = true
        return progressView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        webView.addObserver(self, forKeyPath: estimatedProgressKey, options: .new, context: &progressContext)
    }
    
    func setupViews() {
        shareBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBtnClicked(_:)))
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 45))
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        if urlStr != "" {
            webView.load(URLRequest(url: URL(string: urlStr)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10.0))
            self.navigationItem.rightBarButtonItem = nil
            self.progressView.isHidden = false
            self.addMenuButtonItem()
            self.title = "Freebies"
        } else {
            loadHTMLContent()
            self.navigationItem.rightBarButtonItem = shareBtn
            self.progressView.isHidden = true
            self.title = ""
        }
        
        webHolderView.addSubview(webView)
        constrainView(view: webView, toView: webHolderView)
        addProgressView()
    }
    
    func loadHTMLContent() {
        guard let title = item?.title else { return }
        guard let content = item?.content?.contentEncoded else { return }
        
        let imageModifiedStr = content.replacingOccurrences(of: "<img", with: "<img style='width:100%; height:auto;margin-bottom:20px;margin-top:20px;'")
        let removeClass = imageModifiedStr.replacingOccurrences(of: "aligncenter size-ful", with: "")
        
        let htmlString =  String(format: "<html><body><div style='font-family:HelveticaNeue;font-size:50px;'><h1>%@</h1>%@</div></body></html>", arguments: [title, removeClass])
        
        print("\n\nHTML STRING: \(htmlString) \n\n")
        
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
        self.progressView.isHidden = false
    }
    
    func constrainView(view:UIView, toView contentView:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func addProgressView() {
        navigationController?.navigationBar.addSubview(progressView)
        if let navigationBarBounds = self.navigationController?.navigationBar.bounds {
            progressView.frame = CGRect(x: 0, y: navigationBarBounds.size.height, width: navigationBarBounds.size.width, height: 2)
        }
    }
    
    func setupLayout() {
        webHolderView.addConstraintsWithFormat(format: "H:|[v0]|", views: webView)
        webHolderView.addConstraintsWithFormat(format: "V:|[v0]|", views: webView)
    }
    
    @IBAction func shareBtnClicked(_ sender: Any) {
        guard let shareLink = self.item?.link else {
            print("Unable to create share link")
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [shareLink], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact, .openInIBooks]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: estimatedProgressKey)
        progressView.removeFromSuperview()
    }
}

extension VapeDetailVC: WKUIDelegate, WKNavigationDelegate {
    
    //observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let change = change else { return }
        if context != &progressContext {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == estimatedProgressKey {
            if let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue {
                progressView.progress = progress;
            }
            return
        }
    }

    //MARK: Navigation delegate methods
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("request outside social: \(navigationAction.request.url)")
        
        webView.load(navigationAction.request)
        self.progressView.isHidden = false
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == WKNavigationType.linkActivated, let redirect = navigationAction.request.url {
            print("link: \(redirect)\n")
            webView.load(navigationAction.request)
            self.progressView.isHidden = false
        }
        
        decisionHandler(.allow)
    }
    
    // Gets called if webView cant handle URL
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard let failingUrlStr = (error as NSError).userInfo["NSErrorFailingURLStringKey"] as? String  else { return }
        print("Failing URL: \(failingUrlStr)")
    }
}
