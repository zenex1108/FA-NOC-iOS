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
                .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            let favUrl = try document.select("a[href^=/fav/\(galleryModel.id!)]").first()?.attr("href")
            
            let keywords = try document.select("a[href^=/search/@keywords]").map{$0.ownText()}
            
            submission.contentOriginalUrl = URL(string: "https:\(originalImageUrl!)")!
            submission.favUrl = FaUrl.makeURL(strRef: favUrl!)
            submission.keywords = Array(OrderedSet(sequence: keywords))
            
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
                
                let tempDescription = try document.select(".maintable").select(".alt1").get(4)
                
                let descriptionHtml = try tempDescription.outerHtml()
                let avatar = try tempDescription.select("a").get(0).outerHtml()
                let description = descriptionHtml.replacingOccurrences(of: avatar, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                submission.description = try SwiftSoup.parse(description).body()?.attributedString()
                
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
                
                let tempDescription = try document.select(".submission-description-container").get(0)
                
                let descriptionHtml = try tempDescription.outerHtml()
                let description = descriptionHtml.trimmingCharacters(in: .whitespacesAndNewlines)
                submission.description = try SwiftSoup.parse(description).body()?.attributedString()
                
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


extension String {
    
    var avatarAlt: String {
        return replacingOccurrences(of:"_", with:"").lowercased()
    }
    
    var smilieToEmoji: String? {
        
        switch self {
        case "tongue"     : return "😛"
        case "cool"       : return "😎"
        case "wink"       : return "😉"
        case "oooh"       : return "😮"
        case "smile"      : return "🙂"
        case "evil"       : return "😈"
        case "huh"        : return "🤔"
        case "whatever"   : return "🥴"
        case "angel"      : return "😇"
        case "badhairday" : return "😕"
        case "lmao"       : return "😂"
        case "cd"         : return "💿"
        case "crying"     : return "😭"
        case "dunno"      : return "🤨"
        case "embarrassed": return "😳"
        case "gift"       : return "🎁"
        case "coffee"     : return "☕️"
        case "love"       : return "❤️"
        case "nerd"       : return "🤓"
        case "note"       : return "🎶"
        case "derp"       : return "🤪"
        case "sarcastic"  : return "😒"
        case "serious"    : return "😟"
        case "sad"        : return "☹️"
        case "sleepy"     : return "😴"
        case "teeth"      : return "😬"
        case "veryhappy"  : return "😁"
        case "yelling"    : return "🤬"
        case "zipped"     : return "🤐"
        default           : return nil
        }
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

extension Node {
    
    func attributedString(_ prevLength: Int=0) throws -> NSAttributedString {
        
        let mutableAttributedString = NSMutableAttributedString()
        
        func currentLength() -> Int {
            return prevLength + mutableAttributedString.length
        }
        
        
        if let element = self as? Element {
            
            if element.tagName() == "div" {
                if try element.className() == "submission-title" {
                    
                    return mutableAttributedString
                }
            }
        }
        
        
        let childNodes = self.getChildNodes()
        
        for childNode in childNodes {
            let childAttributedString = try childNode.attributedString(currentLength())
            mutableAttributedString.append(childAttributedString)
        }
        

        if let textNode = self as? TextNode {
            
            let text = textNode.text()
            if text.trimmingCharacters(in: .whitespaces).count > 0 {
                mutableAttributedString.append(NSAttributedString(string: text))
            }
            
        }else if let element = self as? Element {
            
            switch element.tagName() {
            case "body":
                
                mutableAttributedString.append(NSAttributedString(string: "\n"))
                
            case "img":
                
                let strUrl = try element.attr("src")
                let addingPercent = "https:\(strUrl)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                let imageUrl = URL(string: addingPercent!)!
                
                let imageAttachment = NSTextAttachment()
                
                do{
                    let data = try Data(contentsOf: imageUrl)
                    if let image = UIImage(data: data)?.kf.scaled(to: UIScreen.main.scale)
                        .kf.image(withRoundRadius: 20.0, fit: .init(width: 40, height: 40)) {
                        imageAttachment.image = image
                    }
                }catch{
                    imageAttachment.image = #imageLiteral(resourceName: "ic_placeholder").kf.image(withRoundRadius: 20.0, fit: .init(width: 40, height: 40))
                }
                
                let imageString = NSAttributedString(attachment: imageAttachment)
                mutableAttributedString.append(imageString)
                
                let stringRange = NSRange(location: 0, length: mutableAttributedString.length)
                mutableAttributedString.addAttribute(.baselineOffset, value: (16.0-40.0)/2.0, range: stringRange)
                
            case "a":
                
                let strUrl = try element.attr("href")
                var addingPercent: String!
                
                let isAbsolute = strUrl.hasPrefix("//")
                if isAbsolute {
                    addingPercent = "https:\(strUrl)"
                }else{
                    addingPercent = FaUrl.makeStrURL(strRef: strUrl)
                }
                addingPercent = addingPercent.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                
                let url = URL(string: addingPercent!)!
                
                let stringRange = NSRange(location: 0, length: mutableAttributedString.length)
                mutableAttributedString.addAttributes([.link: url,
                                                       .font: UIFont.boldSystemFont(ofSize: 16.0),
                                                       .underlineColor: UIColor.clear],
                                                      range: stringRange)
                
            case "i":
                
                let classNames = try element.classNames()
                
                if classNames.first == "smilie",
                    let emoji = classNames.last?.smilieToEmoji {
                    
                    let attributed = NSAttributedString(string: emoji)
                    mutableAttributedString.append(attributed)
                }
                
            case "br":
                
                if currentLength() > 0 {
                    mutableAttributedString.append(NSAttributedString(string: "\n"))
                }
                
            case "div":
                
                let className = try element.className()
                
                if className == "message-text" {
                    break
                }else{
                    fallthrough
                }
                
            case "span":
                
                break
                
            default:
                
                let outerHtml = try element.outerHtml()
                mutableAttributedString.append(NSAttributedString(string: outerHtml))
            }
        }
        
        return mutableAttributedString
    }
}
