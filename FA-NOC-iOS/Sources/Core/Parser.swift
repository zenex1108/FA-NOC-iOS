//
//  Parser.swift
//  FA-NOC-iOS
//
//  Created by joowon on 04/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import Foundation
import SwiftSoup

import RxSwift

class Parser: NSObject {
    
    static func checkTheme(_ document:Document) throws -> FATheme {
        
        if let theme = try document.body()?.attr("data-static-path"),
            theme.hasSuffix("beta") {
            return .beta
        }
        return .classic
    }
    
    static func checkOffline(_ document: Document) throws {
        
        if let imageName = try document.select("img").first()?.text().lowercased() {
            let title = try document.select("title").text().lowercased()
            
            if title.contains("offline"), imageName.contains("offline") {
                throw FAException.error(type: .siteOffline, Message: "Furaffinity site is offline.")
            }
        }
    }
    
    static func login(_ response:HTTPURLResponse, _ html:String, _ model:LoginModel) -> LoginModel {
        
        if let strUrl = response.url?.absoluteString,
            !strUrl.contains(FaStrRefUrl.login.rawValue) {
            
            model.setResult(isSuccess: true)
        }else{
            
            do {
                let document: Document = try SwiftSoup.parse(html)
                try checkOffline(document)
                
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

        var items = [GalleryItemModel]()
        
        do {
            let prev = Date().timeIntervalSince1970
            let document: Document = try SwiftSoup.parse(html)
            print(Date().timeIntervalSince1970-prev)
            try checkOffline(document)
            
            let elements: Elements = try document.select("#gallery-browse")
            
            if let element = elements.first() {
                
                let figures: Elements = try element.select("figure")
                for figure in figures {
                    
                    try autoreleasepool {
                        
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
            }
        } catch Exception.Error(let type, let message) {
            print("html parse error: \(type) - \(message)")
        } catch {
            print("html parse error: unkown")
        }
        
        return items
    }
    
    static func view(_ response:HTTPURLResponse, _ html:String, _ galleryModel:GalleryItemModel) -> SubmissionModel {
        
        let submission = SubmissionModel(galleryModel)
        
        do {
            let prev = Date().timeIntervalSince1970
            let document = try SwiftSoup.parse(html)
            print(Date().timeIntervalSince1970-prev)
            try checkOffline(document)
            
            let theme = try checkTheme(document)
            
            let originalImageUrl = try document.select("#submissionImg").first()?.attr("src")
            let favUrl = try document.select("a[href^=/fav/\(galleryModel.id!)]").first()?.attr("href")
            
            let keywords = try document.select("a[href^=/search/@keywords]").map{$0.ownText()}
            
            submission.contentOriginalUrl = URL(string: "https:\(originalImageUrl!)")!
            submission.favUrl = FaUrl.makeURL(strRef: favUrl!)
            submission.keywords = keywords
            
            if theme == .classic {
                
                let userThumbnail = try document.select("img[alt^=\(galleryModel.userName.avatarAlt)]").first()?.attr("src")
                
                submission.userThumbnail = URL(string: "https:\(userThumbnail!)")!
                
                let infos = try document.select(".stats-container").first()?.text()
                    .components(separatedBy: "  Image Specifications:").first?.components(separatedBy: "      ")
                let values = infos?.map{$0.components(separatedBy: ": ").last}
                
                let tempCategory = values?[2]
                let tempTheme = values?[3]
                let tempSpecies = values?[4]
                let tempGender = values?[5]
                
                let tempFavorite = values?[6]
                let tempComments = values?[7]
                let tempViews = values?[8]
                
                let category = "\(tempCategory!) > \(tempTheme!)"
                let species = tempSpecies!
                let gender = tempGender!
                
                let favorites = Int(tempFavorite!)!
                let comments = Int(tempComments!)!
                let views = Int(tempViews!)!
                
                submission.category = category
                submission.speciese = species
                submission.gender = gender
                submission.views = views
                submission.favorites = favorites
                submission.comments = comments
                
                
                /*
                 <td valign="top" align="left" width="70%" class="alt1" style="padding:8px">
                 <a href="/user/teebs13/"><img class="avatar" alt="teebs13" src="//a.facdn.net/1547707248/teebs13.gif"></a>
                 <br>
                 <br>/*start*/ A humorous commission I grabbed from weskers during a stream, I don’t think I’ve ever commissioned anything that large in the groin area though lmao. It just kinda happened and honestly whatever, the design itself looks amazing! I just wonder what would trigger such a transformation...
                 <br>
                 <br> Art by <a href="/user/weskers" class="iconusername"><img src="//a.facdn.net/20190120/weskers.gif" align="middle" title="Weskers" alt="Weskers"></a>
                 <br>
                 <br> Renamon version of my character is mine/*end*/
                 </td>
                 */
                let description = try document.select(".maintable").select(".alt1").get(4)
                
                submission.description = try description.html()
                
                let tempCommentList = try document.select(".container-comment")
                let commentListSet = try CommentModelSet(elements: tempCommentList, theme: theme, url: response.url!)
                
                submission.commentsSet = commentListSet
                
                print("")
            }else if theme == .beta {
                
                let userThumbnail = try document.select(".submission-user-icon").first()?.attr("src")
                
                submission.userThumbnail = URL(string: "https:\(userThumbnail!)")!
                
                let infos = try document.select(".sidebar-section-no-bottom").first()?.text()
                let counts = try document.select(".submission-artist-stats").first()?.text()
                
                let componentSpecies = infos?.components(separatedBy: " Species: ")
                let componentCategory = componentSpecies?.first?.components(separatedBy: "Category: ")
                let componentGender = componentSpecies?.last?.components(separatedBy: " Gender: ")
                let componentCounts = counts?.components(separatedBy: " | ")
                
                let tempCategory = componentCategory?.last
                let tempSpecies = componentGender?.first
                let tempGender = componentGender?.last
                
                let tempViews = componentCounts?[0]
                let tempFavorite = componentCounts?[1]
                let tempComments = componentCounts?[2]
                
                let category = tempCategory!
                let species = tempSpecies!
                let gender = tempGender!
                
                let views = Int(tempViews!)!
                let favorites = Int(tempFavorite!)!
                let comments = Int(tempComments!)!
                
                submission.category = category
                submission.speciese = species
                submission.gender = gender
                submission.views = views
                submission.favorites = favorites
                submission.comments = comments
                
                /*
                 <div class="submission-description-container link-override">
                 <div class="submission-title">
                 <h2 class="submission-title-header">Gryphon turned Renadad</h2> Posted
                 <strong><span title="4 hours ago" class="popup_date">Jan 20th, 2019 06:56 PM</span></strong>
                 </div>
                 /*start*/ A humorous commission I grabbed from weskers during a stream, I don’t think I’ve ever commissioned anything that large in the groin area though lmao. It just kinda happened and honestly whatever, the design itself looks amazing! I just wonder what would trigger such a transformation...
                 <br>
                 <br> Art by
                 <a href="/user/weskers" class="iconusername"><img src="//a.facdn.net/20190120/weskers.gif" align="middle" title="Weskers" alt="Weskers"></a>
                 <br>
                 <br> Renamon version of my character is mine/*end*/
                 </div>
                */
                let description = try document.select(".submission-description-container")
                
                let descriptionHtml = try description.html()
                let titleAndDate = try description.select(".submission-title").outerHtml()
                submission.description = descriptionHtml.replacingOccurrences(of: titleAndDate, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                
                let tempCommentList = try document.select("div[class^=comment_container]")
                let commentListSet = try CommentModelSet(elements: tempCommentList, theme: theme, url: response.url!)
                
                submission.commentsSet = commentListSet
                
                print("")
            }

        } catch Exception.Error(let type, let message) {
            print("html parse error: \(type) - \(message)")
        } catch {
            print("html parse error: unkown")
        }
        
        return submission
    }
}

extension Parser {
    
    static func browseObservable(_ response:HTTPURLResponse, _ html:String) -> Observable<[GalleryItemModel]> {
        return Observable.create{ observer -> Disposable in
            let items = browse(response, html)
            if items.count > 0 {
                observer.onNext(items)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    static func viewObservable(_ response:HTTPURLResponse, _ html:String, _ galleryModel:GalleryItemModel) -> Observable<SubmissionModel> {
        return Observable.create{ observer -> Disposable in
            observer.onNext(view(response, html, galleryModel))
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

extension String {
    
    var avatarAlt: String {
        return replacingOccurrences(of:"_", with:"").lowercased()
    }
}
