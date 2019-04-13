//
//  UIViewControllerLoadProtocol.swift
//  moigo_cs
//
//  Created by Twinny on 2018. 7. 9..
//  Copyright © 2018년 Twinny. All rights reserved.
//

import UIKit

enum StoryboardType : String {
    case Splash, Main, Setting, Notification, User, Submission, Note
}

protocol UIViewControllerLoadProtocol {
    associatedtype ViewController
    
    static var identifier:String { get }
    static func loadViewController(_ storyboard:StoryboardType) -> ViewController
}

extension UIViewControllerLoadProtocol {
    
    static func loadViewController(_ storyboard: StoryboardType) -> Self {
        return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier) as! Self
    }
}

extension UIViewController : UIViewControllerLoadProtocol {
    
    static var identifier: String {
        return fileName
    }
}

extension NSObject {

    static var fileName:String {
        return description().components(separatedBy: ".").last!
    }
}
