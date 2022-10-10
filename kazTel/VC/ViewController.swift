//
//  ViewController.swift
//  kazTel
//
//  Created by Нурлан on 01.06.2018.
//  Copyright © 2018 Нурлан. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup
import UserNotifications
import Locksmith
import BiometricAuthentication
import RAMAnimatedTabBarController
import NVActivityIndicatorView
import EasyPeasy



class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, UITabBarControllerDelegate {
//    @IBOutlet weak var tabBarItem: RAMAnimatedTabBarItem!
    var webView = WKWebView()
    var counter = 0
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var faceIDView: UIView!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var invalidLabel: UILabel!
    @IBOutlet weak var authView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var signButton: UIButton!
    var login  = ""
    var password = ""
    var myLogin = ""
    var myPassword = ""
    
    var isFaceIDChecked = false
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    let userDefaults = UserDefaults.standard
    var userAgent = ""
//    struct defaultsKeys {
//        static let keyOne = "deviceToken"
//        static let keyTwo = "n"
//    }
    //declare this property where it won't go out of scope relative to your listener
    
    override func viewDidAppear(_ animated: Bool) {
        if !isFaceIDChecked{
           faceIDChecking()
        }

    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
//        let dataStore = WKWebsiteDataStore.default()
//                    dataStore.httpCookieStore.getAllCookies({ (cookies) in
//                        print("!!!!!!!!!!!!!!!!!!!!! \(cookies)")
//                        Ims.cookie = cookies
//                    })
//    }
    override func viewWillAppear(_ animated: Bool) {
//        webView.evaluateJavaScript("document.getElementById('unsupported-browser-close').click();", completionHandler: nil)
        self.tabBarController?.delegate = self
        
                
    }
    
   
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        indicatorView.startAnimating()
    }
    
    private var progressKVOhandle: NSKeyValueObservation?
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
                userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/85.0.4183.92 Mobile/15E148 Safari/604.1"
        case .pad:
                userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko)"
        case .unspecified:
                userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko)"
        case .tv:
            userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko)"
        case .carPlay:
            userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko)"
        case .mac:
            userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko)"
        }
        
        
        let configuration1 = WKWebViewConfiguration()
        configuration1.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        webView = WKWebView(frame: CGRect.zero, configuration: configuration1)
        Ims.conf = configuration1

        indicatorView.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.tabBarController?.tabBar.layer.zPosition = -1
//        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isUserInteractionEnabled = false

        
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        invalidLabel.easy.layout(
            CenterX(),
            Top(10).to(signButton, .bottom)
        )
        invalidLabel.isHidden = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.customUserAgent = userAgent
        

        self.tabBarController?.delegate = self
        self.tabBarController?.tabBar.isHidden = true

       
        
    
        signButton.layer.cornerRadius = 5
        signButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        signButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        signButton.layer.shadowOpacity = 1.0
        signButton.layer.shadowRadius = 0.0
        signButton.layer.masksToBounds = false
        signButton.layer.cornerRadius = 4.0
        
        
        passwordText.layer.masksToBounds = true
        passwordText.layer.borderColor = UIColor.black.cgColor
        passwordText.layer.borderWidth = 1
        passwordText.layer.cornerRadius = 5
        passwordText.placeHolderColor = .gray
        passwordText.textColor = .black
        
        loginText.layer.masksToBounds = true
        loginText.layer.borderColor = UIColor.black.cgColor
        loginText.layer.borderWidth = 1
        loginText.layer.cornerRadius = 5
        loginText.placeHolderColor = .gray
        loginText.textColor = .black


        let sectionUrl = URL(string: UserDefaults.standard.string(forKey: "section")!)!
        var url = "\(sectionUrl)"
       
        print("Section is that \(url)")
        
        var request = URLRequest(url: URL(string: url)!)
        request.setValue(userAgent, forHTTPHeaderField:"user-agent")
        webView.isHidden = true
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        
        webView.frame = view.bounds
        
        progressKVOhandle = webView.observe(\.estimatedProgress) { [weak self] (object, _) in
           

            self?.progressView.setProgress(Float(object.estimatedProgress), animated: false)
            
        }
        if let dictionary = Locksmith.loadDataForUserAccount(userAccount: "loginLast"){
            authView.isHidden = true
//            myLogin = dictionary["login"] as! String
//            myPassword = (dictionary["password"])! as! String
//            print(myLogin)
//            print(myPassword)
//
           
        }else{
            print("no keys")
            authView.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: .UIApplicationDidBecomeActive, // UIApplication.didBecomeActiveNotification for swift 4.2+
            object: nil)
   
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.darkContent
        } else {
            // Fallback on earlier versions
        }

    }
    
    @IBAction func faceIDPressed(_ sender: Any) {
        self.showPasscodeAuthentication(message: "" )
    }
    func faceIDChecking() {
        self.showPasscodeAuthentication(message: "" )
        webView.isHidden = true
        isFaceIDChecked = true
        
           
        }
    // show passcode authentication
     func showPasscodeAuthentication(message: String) {
         
         BioMetricAuthenticator.authenticateWithPasscode(reason: message) { [weak self] (result) in
             switch result {
             case .success( _):
                self?.faceIDView.isHidden = true
                 self?.showLoginSucessAlert() // passcode authentication success
             case .failure(let error):
                print("Pass needed")
                 print(error.message())
             }
         }
     }
    func showLoginSucessAlert() {
        faceIDView.isHidden = true
        webView.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
        self.tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    func showErrorAlert(message: String) {
        showAlert(title: "Error", message: message)
    }

    
    @objc func applicationDidBecomeActive() {

    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started")
        progressView.isHidden = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webView.evaluateJavaScript("document.getElementById('unsupported-browser-close').click();", completionHandler: nil)
        print("Loaded \(webView.url)")
         print("auth View isHidden - \(authView.isHidden)")
        progressView.isHidden = true
        oneMore()
        loadPage()
//        print("This is IMS.POST \(Ims.post)")
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        print("tab bar selected \(tabBarController.selectedIndex) ")
        print("first tabbar")
        print(Ims.tabBarNumber)
        if Ims.tabBarNumber == String(tabBarController.selectedIndex) {
            if tabBarController.selectedIndex == 0{
                    
                let sectionUrl = URL(string: UserDefaults.standard.string(forKey: "section")!)!
                let url = "\(sectionUrl)"
                let request = URLRequest(url: URL(string: url)!)

                  
            //        authView.isHidden = true
                webView.load(request)
                
            }
        }
        Ims.tabBarNumber = String(tabBarController.selectedIndex)
        print(Ims.tabBarNumber)
        
      
        

    }
    
    @IBAction func signPressed(){
        print(counter)
        switch counter {
        case 0:
            
           loginOn()
        default:
            webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: { (innerHTML, error) in
                do {
                    let gmailResponse = try GmailResponse(innerHTML)
                    self.performSegue(withIdentifier: "showPost", sender: gmailResponse.emails)
                } catch {}
            })
   
        }
        
    }
    

    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            self.view.frame.origin.y = -150// Move view 150 points upward
        }
        
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    func loadPage(){
        if let dictionary = Locksmith.loadDataForUserAccount(userAccount: "loginLast"){
//            authView.isHidden = true
            myLogin = dictionary["login"] as! String
            myPassword = (dictionary["password"])! as! String
//            self.tabBarController?.tabBar.isHidden = false
            webView.evaluateJavaScript("document.getElementById('user-id').value='\(myLogin)'") { (login, error) in
                self.webView.evaluateJavaScript("document.getElementById('pw-id').value='\(self.myPassword)'") { (password, error) in
                    self.webView.evaluateJavaScript("document.getElementsByClassName('btn btn-lg btn-primary btn-block')[0].click();") { (result, error) in
                        
                        self.view.addSubview(self.webView)
                        self.webView.addSubview(self.progressView)
                        self.tabBarController?.tabBar.isHidden = false
                        self.tabBarController?.tabBar.layer.zPosition = 1
                        self.tabBarController?.tabBar.isUserInteractionEnabled = true
//                        self.indicatorView.stopAnimating()
                      
                        let dataStore = WKWebsiteDataStore.default()
                                    dataStore.httpCookieStore.getAllCookies({ (cookies) in
                                        print("!!!!!!!!!!!!!!!!!!!!! \(String(describing: cookies))")
                                        Ims.cookies = cookies
                                    })
                        self.webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                            for cookie in cookies {
                                if cookie.name == "authentication" {
                //                    self.webView.configuration.websiteDataStore.httpCookieStore.delete(cookie)
                                } else {
                                    print("\(cookie.name) is set to \(cookie.value)")
                                }
                            }
                            Ims.cook = cookies
                            Ims.cookie = cookies
                           

                            
                        }
                    }
                }
            }
            
                
                    
                   
                    if let stringTwo = self.userDefaults.string(forKey: AppDelegate.defaultsKeys.keyTwo) {
                        if stringTwo == "no"{
                            print("Let's start the push")
                            self.sendToServer(self.myLogin)
                            self.userDefaults.set("yes", forKey: AppDelegate.defaultsKeys.keyTwo)
                        }
                    }
                    
            
        }
    }
    
    

    // this handles target=_blank links by opening them in the same view
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    static func loadCookie(using data: Data?) -> HTTPCookie? {
            guard let data = data,
                let properties = loadCookieProperties(from: data) else {
                    return nil
            }
            return HTTPCookie(properties: properties)

        }
    static fileprivate func loadCookieProperties(from data: Data) -> [HTTPCookiePropertyKey : Any]? {
            let unarchivedDictionary = NSKeyedUnarchiver.unarchiveObject(with: data)
            return unarchivedDictionary as? [HTTPCookiePropertyKey : Any]
        }
    func oneMore(){
        webView.evaluateJavaScript("document.getElementsByTagName('html')[0].innerHTML", completionHandler: { (innerHTML, error) in
            do {
                guard let htmlString = innerHTML as? String else { throw HTMLError.badInnerHTML }
                let doc = try SwiftSoup.parse(htmlString)
                let htmlStringValue = "\(doc)"
                if !htmlStringValue.contains("Неверное имя пользователя"){
                    self.login = self.loginText.text!
                    self.password = self.passwordText.text!
                }
                if htmlStringValue.contains("Неверное имя пользователя"){
                    self.invalidLabel.isHidden = false
                }
                if self.login.count>1{
                        try Locksmith.saveData(data: ["login": self.login, "password": self.password], forUserAccount: "loginLast")
                        print("data is saved")
                        self.view.endEditing(true)
                        self.viewDidLoad()
                    self.webView.isHidden = false
                    }
                
                
            } catch {}
        })
    }
    func loginOn(){
        print("Login on Function Started")
        guard let login = loginText.text else { return }
        guard let pass = passwordText.text else { return }
//        webView.evaluateJavaScript("document.documentElement.innerHTML") { (html, error) in
//            print("Resul HTML",html )
//        }
        webView.evaluateJavaScript("document.getElementById('user-id').value='\(login)';document.getElementById('pw-id').value='\(pass)';document.getElementsByClassName('btn btn-lg btn-primary btn-block')[0].click();") { [self] (login, error) in
            print("This is error: ", error)
           
            if self.SYSTEM_VERSION_LESS_THAN(version: "13.0"){
                webView.evaluateJavaScript("document.getElementById('user-id').value='\(login)';document.getElementById('pw-id').value='\(pass)';document.getElementsByClassName('btn btn-lg btn-primary btn-block')[0].click();") { (login, error) in
                }
            }
        }
        
    }
    
    
    
    func SYSTEM_VERSION_LESS_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedAscending
    }
    
    func sendToServer(_ login: String){
        let defaults = UserDefaults.standard
        var token = ""
        if let stringOne = defaults.string(forKey: AppDelegate.defaultsKeys.keyOne) {
            token = stringOne // Some String Value
        }
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Basic UHVzaCBOb3RpZmljYXRpb25zOnF5MmlnMUgnNztxQkx0RFNRI082elM="
        ]
        let parameters = [
            [
                "login": login,
                "token": token
            ]
            ] as [[String : Any]]
        
        let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let url = URL(string: userDefaults.string(forKey: "section")!)!
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)/SKYDOCS/skydocs_connector.nsf/APPTools.xsp/LoadUserToken")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("Response:",response!)
            } else {
                _ = response as? HTTPURLResponse
                print("Response:",response!)
            }
        })
        print(dataTask.response)
        dataTask.resume()
    }
    
}


extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Alerts
extension ViewController {
    
    func showAlert(title: String, message: String) {
        
        let okAction = AlertAction(title: OKTitle)
        let alertController = getAlertViewController(type: .alert, with: title, message: message, actions: [okAction], showCancel: false) { (button) in
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoginSucessAlerts() {
        showAlert(title: "Success", message: "Login successful")
    }
    
    func showErrorAlerts(message: String) {
        showAlert(title: "Error", message: message)
    }
    
    func showGotoSettingsAlert(message: String) {
        let settingsAction = AlertAction(title: "Go to settings")
        
        let alertController = getAlertViewController(type: .alert, with: "Error", message: message, actions: [settingsAction], showCancel: true, actionHandler: { (buttonText) in
            if buttonText == CancelTitle { return }
            
            // open settings
            let url = URL(string: UIApplicationOpenSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:])
            }
            
        })
        present(alertController, animated: true, completion: nil)
    }
}

extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
extension WKWebView {

    private var httpCookieStore: WKHTTPCookieStore  { return WKWebsiteDataStore.default().httpCookieStore }

    func getCookies(for domain: String? = nil, completion: @escaping ([String : Any])->())  {
        var cookieDict = [String : AnyObject]()
        httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                    }
                } else {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }
    }
}

