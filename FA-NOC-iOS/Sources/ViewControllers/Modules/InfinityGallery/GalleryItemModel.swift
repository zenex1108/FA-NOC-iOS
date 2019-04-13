//
//  GalleryItemModel.swift
//  FA-NOC-iOS
//
//  Created by joowon on 24/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

class GalleryItemModel: NSObject {
    
    enum Rating {
        case general, mature, adult
        
        init(string:String) {
            switch string {
            case "mature": self = .mature
            case "adult": self = .adult
            default: self = .general
            }
        }
        
        var short: String {
            return String(String(describing: self).first!).uppercased()
        }
        
        var color: UIColor {
            switch self {
            case .general: return .gray
            case .mature: return .blue
            case .adult: return .red
            }
        }
    }
    
    var id: String!
    var rating: Rating!
    
    var thumbnailUrl: URL!
    var width: Double!
    var ratio: Double!
    
    var contentUrl: URL!
    var title: String!
    
    var userName: String!
    var userUrl: URL!
    
    var date: Date!
    
    override var description: String {
        return """
        
        Gallery Item [\(id!)]
        rating: \(rating!)
        thumbnail: \(thumbnailUrl!)
        width: \(width!)
        ratio: \(ratio!)
        content: \(contentUrl!)
        title: \(title!)
        name: \(userName!)
        user: \(userUrl!)
        date: \(date!)
        """
    }
    
    override init() {
        super.init()
    }
    
    convenience init(id: String,
                     rating: Rating,
                     thumbnailUrl: URL,
                     width: Double,
                     height: Double,
                     contentUrl: URL,
                     title: String,
                     userUrl: URL,
                     userName: String,
                     date: Date) {
        self.init()
        
        self.id = id
        self.rating = rating
        
        self.thumbnailUrl = thumbnailUrl
        self.width = width
        self.ratio = height/width
        
        self.contentUrl = contentUrl
        self.title = title
        
        self.userUrl = userUrl
        self.userName = userName
        
        self.date = date
    }
}
