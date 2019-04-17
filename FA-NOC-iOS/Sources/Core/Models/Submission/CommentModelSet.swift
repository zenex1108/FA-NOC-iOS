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
                
                let urls = try element.select("a[href]")
                
                let tempId = try element.select("table").attr("id").components(separatedBy: "cid:").last
                let timestamp = try element.attr("data-timestamp")
                let tempWidthScale = try element.select("table").attr("width").components(separatedBy: "%").first
                let tempStep = (100-Int(tempWidthScale!)!)/3
                
                let tempAvatar = try element.select("img").attr("src")
                let tempName = try element.select(".replyto-name").text()
                
                let tempUserPage = try urls.get(1).attr("href")
                let tempGallery = try urls.get(2).attr("href")
                let tempJounals = try urls.get(3).attr("href")
                let tempSendNote = try urls.get(4).attr("href")
                
                let tempCommentLink = try urls.get(5).attr("href")
                
                let tempComment = try element.select(".message-text").html()
                
                let tempReply = try urls.get(6).attr("href")
                
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
                
                let urls = try element.select("a[href]")
                
                let tempId = try element.select("div[id^=cid:]").attr("id").components(separatedBy: "cid:").last
                let timestamp = try element.attr("data-timestamp")
                let tempWidthScale = try element.select("div[style^=width:]").attr("style").components(separatedBy: ":")[1].components(separatedBy: "%").first!
                let tempStep = (100-Int(tempWidthScale)!)/3
                
                let tempAvatar = try element.select("img").attr("src")
                let tempName = try element.select(".comment_username").text()
                
                let tempUserPage = try urls.get(0).attr("href")
                let tempGallery = try urls.get(4).attr("href")
                let tempJounals = try urls.get(5).attr("href")
                let tempSendNote = try urls.get(6).attr("href")
                
                let tempCommentLink = try urls.get(3).attr("href")
                
                let tempComment = try element.select(".comment_text").html()
                
                let tempReply = try urls.get(7).attr("href")
                
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
