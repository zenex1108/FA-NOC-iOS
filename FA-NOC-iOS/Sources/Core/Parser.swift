//
//  Parser.swift
//  FA-NOC-iOS
//
//  Created by joowon on 04/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import Foundation
import SwiftSoup

class Parser: NSObject {
    
    static func login(_ response:HTTPURLResponse, _ html:String, _ model:LoginModel) -> LoginModel {
        
        if let strUrl = response.url?.absoluteString,
            !strUrl.contains(FaStrRefUrl.login.rawValue) {
            
            model.setResult(isSuccess: true)
        }else{
            
            do {
                let document: Document = try SwiftSoup.parse(html)
                let elements: Elements = try document.select(".error-msg-box")
                
                if let element = elements.first() {
                    model.setResult(isSuccess: false, message: try element.text())
                }
            } catch {
                model.setResult(isSuccess: false, message: "error")
            }
        }
        
        return model
    }
    
    static func browse(_ response:HTTPURLResponse, _ html:String) -> [GalleryItemModel] {
        
        /*
         <figure id="sid-29923389" class="r-general t-image u-s6rr6">
         <b>
         <u>
         <a href="/view/29923389/">
         <img alt="" src="//t.facdn.net/29923389@300-1546242434.jpg" data-width="206.374" data-height="250" style="width:206.374px; height:250px"><i title="Click for description"></i></a></u></b>
         <figcaption>
         <p>
         <a href="/view/29923389/" title="Brown Dog">Brown Dog</a>
         </p>
         <p>
         <i>
         by
         </i>
         <a href="/user/s6rr6/" title="S6RR6">S6RR6</a>
         </p>
         </figcaption>
         </figure>
 */
        var items = [GalleryItemModel]()
        
        do {
            let document: Document = try SwiftSoup.parse(html)
            let elements: Elements = try document.select("#gallery-browse")
            
            if let element = elements.first() {
                
                let figures: Elements = try element.select("figure")
                for figure in figures {
                    
                    let id = figure.id().components(separatedBy: "-").last!
                    let rating = try figure.classNames().first!.components(separatedBy: "-").last!
                    
                    let image = try figure.select("img").first()!
                    
                    let thumbnail = try image.attr("src")
                    let thumbnailUrl = URL(string: "https:\(thumbnail)")!
                    let strTimestamp = thumbnail
                        .components(separatedBy: "/").last!
                        .components(separatedBy: "-").last!
                        .components(separatedBy: ".").first!
                    let timestamp = TimeInterval(strTimestamp)!
                    let date = Date(timeIntervalSince1970: timestamp)
                    
//                    let formatter = DateFormatter()
//                    formatter.locale = Locale(identifier: "ko_kr")
//                    formatter.timeZone = TimeZone(abbreviation: "EST")
                    
                    let strWidth = try image.attr("data-width")
                    let width = Double(strWidth) ?? 120
                    
                    let strHeight = try image.attr("data-height")
                    let height = Double(strHeight) ?? 120
                    
                    let contentInfos = try figure.select("a")
                    
                    let contentLink = try contentInfos.get(1).attr("href")
                    let contentUrl = FaUrl.makeURL(strRef: contentLink)
                    let title = try contentInfos.get(1).text()
                    
                    let userLink = try contentInfos.get(2).attr("href")
                    let userUrl = FaUrl.makeURL(strRef: userLink)
                    let userName = try contentInfos.get(2).text()
                    
                    let item = GalleryItemModel(id: id, rating: .init(string: rating), thumbnailUrl: thumbnailUrl, width: width, height: height, contentUrl: contentUrl, title: title, userUrl: userUrl, userName: userName, date: date)
                    
                    items.append(item)
                }
            }
        } catch {
            print("")
        }
        
        return items
    }
}
