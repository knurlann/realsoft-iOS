import UIKit
// SharedCookieManager.swift


final class SharedCookieManager: NSObject {
    
    // Singleton manager
    static let `default` = SharedCookieManager()
    private override init() { super.init() }
    
    // All cookies taht we have on every WKWebView
    var cookies: Set<HTTPCookie> = []
    // Callback helping to observe changes in our set
    var cookieUpdateCallback: ((_ cookies: [HTTPCookie]) -> Void)?
    
    // Append method
    func appendCookies(_ cookies: [HTTPCookie]) {
        cookies.forEach({ [weak self] in
            self?.cookies.insert($0)
        })
    }
}
