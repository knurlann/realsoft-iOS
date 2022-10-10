//
//  NewEmailViewController.swift
//  kazTel
//
//  Created by Нурлан on 03.07.2018.
//  Copyright © 2018 Нурлан. All rights reserved.
//

import UIKit
import Locksmith
import WebKit
import SwiftSoup
import NVActivityIndicatorView

import EasyPeasy

class NewEmailViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UITabBarControllerDelegate {
//    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    private var progressKVOhandle: NSKeyValueObservation?
    var userAgent = ""
    
    let userDefaults = UserDefaults.standard
    var webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
                userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/85.0.4183.92 Mobile/15E148 Safari/604.1"
        case .pad:
                userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15"
        case .unspecified:
                userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15"
        case .tv:
            userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15"
        case .carPlay:
            userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15"
        case .mac:
            userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15"
        }
        
        
        webView.customUserAgent = userAgent
        indicatorView.easy.layout(
            Center()
        )

        let sectionUrl = URL(string: UserDefaults.standard.string(forKey: "section")!)!
        let url = "\(sectionUrl)/verse"
        var request = URLRequest(url: URL(string: url)!)
//        request.addValue("SessionID=1187893A994A11D1921C807F7FE1DF28F9AFAFA4; user_pref=SVNfRU5BQkxFX0JJREk%3D%3AZmFsc2U%3D-QklESV9ESVJFQ1RJT04%3D%3AZGVmYXVsdA%3D%3D-; DomTimeZonePrfM=+:6:Central%20Asia:-6:0:0; DomAuthSessId=1E9DCA9477E6931802350745D133C5C9; ShimmerS=ET:20201210T232725%2c95Z&R:1&AT:S&N:EA07251FB149E8A76F1F467460FFF930", forHTTPHeaderField: "Cookie")
//        progressKVOhandle = webView.observe(\.estimatedProgress) { [weak self] (object, _) in
//            self?.progressView.setProgress(Float(object.estimatedProgress), animated: true)
//        }
//        request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: Ims.cookie)
        webView.load(request)
        webView.isHidden = true
        indicatorView.startAnimating()
        
        webView.frame = view.bounds

        
//        webView.bottomAnchor.constraint(equalTo: (self.tabBarController?.tabBar.topAnchor)!).isActive = true
        webView.allowsBackForwardNavigationGestures = true
    }
    override func viewWillAppear(_ animated: Bool) {

        self.tabBarController?.delegate = self
                
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        webView.addSubview(progressView)
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
//        }
        return nil
    }
    
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        let scheme = request.url!
        if (scheme).absoluteString.contains("notes"){
            print("contains notes")
        }
        return true
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        print(tabBarController.viewControllers?.index(of: viewController))
        print("Post tabbar")
        print( Ims.tabBarNumber)
        if Ims.tabBarNumber == String(tabBarController.selectedIndex) {
            if tabBarController.selectedIndex == 1{
                
                
                
            let sectionUrl = URL(string: UserDefaults.standard.string(forKey: "section")!)!
            let url = "\(sectionUrl)/verse"
            let request = URLRequest(url: URL(string: url)!)
              
        //        authView.isHidden = true
            webView.load(request)
//
//                let url = UserDefaults.standard.string(forKey: "section")!
//        //            url = "\(url)/SKYDOCS/SkyDocs.nsf/AppMenu.xsp"
//
//                let request = URLRequest(url: URL(string: url)!)
//
//
//                //        authView.isHidden = true
//                webView.load(request)
            }
        }
        Ims.tabBarNumber = String(tabBarController.selectedIndex)
        print(Ims.tabBarNumber)

            
        }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript("document.getElementById('unsupported-browser-close').click();", completionHandler: nil)
        print("Loaded Mail Page")
//        webView.addSubview(progressView)
        if let dictionary = Locksmith.loadDataForUserAccount(userAccount: "loginLast"){
            guard let myLogin = dictionary["login"] else { return }
            guard let myPassword  = dictionary["password"] else { return }
            
            webView.evaluateJavaScript("document.getElementById('user-id').value='\(myLogin)';document.getElementById('pw-id').value='\(myPassword)';document.getElementsByClassName('btn btn-lg btn-primary btn-block')[0].click();") { (login, error) in


                webView.evaluateJavaScript("document.getElementById('view:_id1:image1').src;") { (src, error) in
                    guard let scr = src else { return }
                    print(scr)
                    if scr as! String == "https://mail.realsoft.kz/SKYDOCS/skydocs.nsf/RealSoft.png" {

                    }
                }

                }
            self.webView.isHidden = false
            self.view.addSubview(webView)
            self.indicatorView.stopAnimating()
        }

        

        
        
    }

    
    func setupWebView() {
        
        let cookies = Ims.cookies
        for cookie in cookies {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }

        let cookiesss = Ims.cook
        for cookie in cookiesss {
            webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
        
                let webConfiguration = WKWebViewConfiguration()
//                webView = WKWebView(frame:.zero , configuration: webConfiguration)
                webView.uiDelegate = self
                webView.navigationDelegate = self
                //view = webView
                view.addSubview(webView)
                webView.translatesAutoresizingMaskIntoConstraints = false

                view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
                view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":webView]))
        }


}
