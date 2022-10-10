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
import Locksmith

class HomeViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UITabBarControllerDelegate {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    private var progressKVOhandle: NSKeyValueObservation?
    let webView = WKWebView()
    let userDefaults = UserDefaults.standard
    
//    let btn1 = UIButton()
   

   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        progressView.layer.zPosition = 1
        indicatorView.layer.zPosition = 1
        self.webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.configuration.dataDetectorTypes = [.link, .phoneNumber]
        let sectionUrl = URL(string: UserDefaults.standard.string(forKey: "section")!)!
        let url = "\(sectionUrl)/SKYDOCS/SkyDocs.nsf/AppMenu.xsp"
        let request = URLRequest(url: URL(string: url)!)
        progressKVOhandle = webView.observe(\.estimatedProgress) { [weak self] (object, _) in
            self?.progressView.setProgress(Float(object.estimatedProgress), animated: true)
        }
        webView.load(request)
        webView.isHidden = true
        indicatorView.easy.layout(
            Center()
        )
        indicatorView.startAnimating()

        
        webView.frame = view.bounds
        webView.allowsBackForwardNavigationGestures = true
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Выйти", style: .done, target: self, action: #selector(logoutUser))
            self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }
    
    @objc func logoutUser(){
        let refreshAlert = UIAlertController(title: "Выйти", message: "Вы уверены?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action: UIAlertAction!) in
              print("Handle Cancel logic here")
        }))

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok Logic here")
//            if let dictionary = Locksmith.loadDataForUserAccount(userAccount: "loginLast")
            do{
                try Locksmith.deleteDataForUserAccount(userAccount: "loginLast")
                UserDefaults.standard.removeObject(forKey: "section")
                UserDefaults.standard.removeObject(forKey: "onboardingComplete")
                
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "Onboarding") as! WelcomePageController

                    let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate

                    appDel.window?.rootViewController = loginVC



                print("Pass deleted")


                
            }catch{
                print("Cannot delete User Data")
            }
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.tabBarController?.delegate = self
                
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.addSubview(progressView)
    }

    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        let url = navigationAction.request.url?.absoluteString
        let urlElements = url?.components(separatedBy: ":") ?? []

        switch urlElements[0] {

        case "callto":
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
        case "mailto":
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
        default:
            decisionHandler(.allow)
        }
    }
    
    //
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        let scheme = request.url!
        if (scheme).absoluteString.contains("notes"){
            print("contains notes")
        }
        return true
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        print("tab bar selected:  = \(tabBarController.selectedIndex) ")
        print(tabBarController.viewControllers?.index(of: viewController))
        print("Third tabbar")
        print(Ims.tabBarNumber)

        if Ims.tabBarNumber == String(tabBarController.selectedIndex) {
        if tabBarController.selectedIndex == 2{
            
            var url = UserDefaults.standard.string(forKey: "section")!
            url = "\(url)/SKYDOCS/SkyDocs.nsf/AppMenu.xsp"

            let request = URLRequest(url: URL(string: url)!)


            //        authView.isHidden = true
            webView.load(request)
        }
        }
        Ims.tabBarNumber = String(tabBarController.selectedIndex) 
        print(Ims.tabBarNumber)


        
    }

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.getElementById('unsupported-browser-close').click();", completionHandler: nil)
        print("Loaded Mail Page")
        webView.addSubview(progressView)
        if let dictionary = Locksmith.loadDataForUserAccount(userAccount: "loginLast"){
            guard let myLogin = dictionary["login"] else { return }
            guard let myPassword  = dictionary["password"] else { return }
            webView.evaluateJavaScript("document.getElementById('user-id').value='\(myLogin)';document.getElementById('pw-id').value='\(myPassword)';document.getElementsByClassName('btn btn-lg btn-primary btn-block')[0].click();") { (login, error) in
                self.webView.isHidden = false
                self.view.addSubview(webView)
                self.indicatorView.stopAnimating()
                }
            
     
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
