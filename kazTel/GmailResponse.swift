//
//  GmailResponse.swift
//  kazTel
//
//  Created by Нурлан on 01.06.2018.
//  Copyright © 2018 Нурлан. All rights reserved.
//

import Foundation
import SwiftSoup

enum HTMLError: Error {
    case badInnerHTML
}

struct GmailResponse {
    
    let emails: String
    
    init(_ innerHTML: Any?) throws {
        guard let htmlString = innerHTML as? String else { throw HTMLError.badInnerHTML }
        let doc = try SwiftSoup.parse(htmlString)
        let post = try doc.getElementById("view:_id1:_id2:_id6:repeat2:0:link6")
        let link: Element = try! doc.select("a").first()!
        let linkHref: String = try! link.attr("href");

//        let post = try doc.getElementsByClass("Mg Jl").array()
//        let titles = try doc.getElementsByClass(" Mg Kl").array()
//        
//        var emails = [Email]()
//        emails.append(post?.text())
//        for i in 0..<titles.count {
//            let author = try authors[i].text()
//            let title = try titles[i].text()
//            let email = Email(author: author, title: title)
//            emails.append(email)
//        }
        self.emails =  linkHref
    }
    
}
