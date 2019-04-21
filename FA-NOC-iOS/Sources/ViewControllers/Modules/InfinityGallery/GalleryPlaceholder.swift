//
//  GalleryPlaceholder.swift
//  FA-NOC-iOS
//
//  Created by joowon on 04/01/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import Kingfisher
import Hue
import SnapKit

class GalleryPlaceholder: UIView, Placeholder {
    
    convenience init(width: Double, height: Double) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        contentMode = .topRight
        backgroundColor = UIColor(hex: "#C0C0C0")
        
        let imageView = UIImageView(image: UIImage(named: "ic_placeholder"))
        let unit = Double(frame.width)*0.615
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(unit)
            make.top.right.equalTo(self)
        }
    }
    
    convenience init(width: Double, heightRatio: Double = 1.0, tip: Double = 0.615) {
        self.init(width: width, height: width*heightRatio)
    }
    
    convenience init(size: CGSize) {
        self.init(width: Double(size.width), height: Double(size.height))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
