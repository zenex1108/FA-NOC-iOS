//
//  SubmissionViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 13/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx
import TagListView
import Kingfisher
import ActiveLabel
import SnapKit

class SubmissionViewController: BaseViewContorller {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var readView: UIView!
    @IBOutlet private weak var readViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var audioView: UIView!
    @IBOutlet private weak var audioViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    
    @IBOutlet private weak var contentLabel: ActiveLabel!
    
    @IBOutlet private weak var keywordsView: TagListView!
    
    @IBOutlet private weak var replyView: UIView!
    
    
    var galleryModel: GalleryItemModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
}

extension SubmissionViewController {
    
    func bind(){
        
        Service.view(galleryModel)
            .subscribe(onNext: weakify{ strongSelf, model in
                
                print(model)
                
                let galleryModel = model.galleryModel!
                let screenWidth = Double(UIScreen.main.bounds.width)
                let height = CGFloat(screenWidth * galleryModel.ratio)
                
                //title
                strongSelf.title = galleryModel.title
                
                //image
                let placeholder = GalleryPlaceholder(width: screenWidth,
                                                     heightRatio: galleryModel.ratio,
                                                     tip: 0.615)
                strongSelf.imageView.kf
                    .setImage(with: model.contentOriginalUrl,
                                      placeholder: placeholder,
                                      options: [.transition(.fade(0.25))])
                strongSelf.imageViewHeightConstraint.constant = height
                
                //media
                
                
                //profile
                strongSelf.profileImageView.kf
                    .setImage(with: model.userThumbnail,
                              placeholder: placeholder,
                              options: [.transition(.fade(0.25))])
                strongSelf.userNameLabel.text = galleryModel.userName
                
                //content
                strongSelf.contentLabel.text = model.description
                
                //keywords
                strongSelf.keywordsView.addTags(model.keywords)
                
                //comments
                let commentStackView = CommentsStackView(model.commentsSet)
                strongSelf.replyView.addSubview(commentStackView)
                
                commentStackView.snp.makeConstraints { make in
                    make.top.right.bottom.left.equalTo(strongSelf.replyView)
                }
            }).disposed(by: rx.disposeBag)
    }
}
