//
//  CommentModelSet.swift
//  FA-NOC-iOS
//
//  Created by joowon on 14/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import SwiftSoup

class CommentModelSet {

    var comments = [CommentModel]()
    
    init(elements: Elements, theme: FATheme, url: URL) throws {
        
//        var parentComment: CommentModel?
//        var prevComment:CommentModel?
        
        if theme == .classic {
            
            for element in elements {
                
                let urls = try element.select("a[href]").map{try $0.attr("href")}
                
                guard urls.count > 0 else { continue }
                
                let tempId = try element.select("table").attr("id").components(separatedBy: "cid:").last
                let timestamp = try element.attr("data-timestamp")
                let tempWidthScale = try element.select("table").attr("width").components(separatedBy: "%").first
                let tempStep = (100-Int(tempWidthScale!)!)/3
                
                let tempAvatar = try element.select("img").attr("src")
                let tempName = try element.select(".replyto-name").text()
                
                let tempUserPage = urls[1]
                let tempGallery = urls[2]
                let tempJounals = urls[3]
                let tempSendNote = urls[4]
                
                let tempCommentLink = urls[5]
                
                let tempComment = try element.select(".message-text").submissionComment()
                
                let tempReply = urls[6]
                
                let commentModel = CommentModel(commentId: tempId!,
                                                postedAt: Date(timeIntervalSince1970: TimeInterval(timestamp)!),
                                                commentStep: tempStep,
                                                comment: tempComment,
                                                userNickName: tempName,
                                                userThumbnail: URL(string: "https:"+tempAvatar)!,
                                                userPageLink: FaUrl.makeURL(strRef: tempUserPage),
                                                userGalleryUrl: FaUrl.makeURL(strRef: tempGallery),
                                                userJounalUrl: FaUrl.makeURL(strRef: tempJounals),
                                                userSendNoteUrl: FaUrl.makeURL(strRef: tempSendNote),
                                                commentUrl: url.appendingPathComponent(tempCommentLink),
                                                replyLink: FaUrl.makeURL(strRef: tempReply))
                
                comments.append(commentModel)
            }
        }else if theme == .beta {
            
            for element in elements {
                
                let urls = try element.select("a[href]").map{try $0.attr("href")}
                
                guard urls.count > 0 else { continue }
                
                let tempId = try element.select("div[id^=cid:]").attr("id").components(separatedBy: "cid:").last
                let timestamp = try element.attr("data-timestamp")
                let tempWidthScale = try element.select("div[style^=width:]").attr("style").components(separatedBy: ":")[1].components(separatedBy: "%").first!
                let tempStep = (100-Int(tempWidthScale)!)/3
                
                let tempAvatar = try element.select("img").attr("src")
                let tempName = try element.select(".comment_username").text()
                
                let tempUserPage = urls[0]
                let tempGallery = urls[4]
                let tempJounals = urls[5]
                let tempSendNote = urls[6]
                
                let tempCommentLink = urls[3]
                
                let tempComment = try element.select(".comment_text").submissionComment()
                
                let tempReply = urls[7]
                
                let commentModel = CommentModel(commentId: tempId!,
                                                postedAt: Date(timeIntervalSince1970: TimeInterval(timestamp)!),
                                                commentStep: tempStep,
                                                comment: tempComment,
                                                userNickName: tempName,
                                                userThumbnail: URL(string: "https:"+tempAvatar)!,
                                                userPageLink: FaUrl.makeURL(strRef: tempUserPage),
                                                userGalleryUrl: FaUrl.makeURL(strRef: tempGallery),
                                                userJounalUrl: FaUrl.makeURL(strRef: tempJounals),
                                                userSendNoteUrl: FaUrl.makeURL(strRef: tempSendNote),
                                                commentUrl: url.appendingPathComponent(tempCommentLink),
                                                replyLink: FaUrl.makeURL(strRef: tempReply))
                
                comments.append(commentModel)
            }
        }
    }
}
