//
//  ImageViewerViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 21/04/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class ImageViewerViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    private weak var imageView: UIImageView!
    
    var model: SubmissionModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setupGestureRecognizer()
        updateImageSize()
        updateContentInsets()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateImageSize()
    }
    
    func bind() {
        
        let navigationTitleLabel: UILabel = {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0))
            titleLabel.backgroundColor = .clear
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
            return titleLabel
        }()
        navigationTitleLabel.text = model.galleryModel.title
        navigationItem.titleView = navigationTitleLabel
        
        let imageView = UIImageView()
        self.imageView = imageView
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: model.contentOriginalUrl, options: [.transition(.fade(0.25))])
        
        scrollView.addSubview(imageView)
        
        scrollView.delegate = self
    }
    
    func updateImageSize() {
        
        let scrollViewSize = self.scrollViewSize()
        
        let scrollViewWidth = Double(scrollViewSize.width)
        let scrollViewHeight = Double(scrollViewSize.height)
        let scrollViewRatio = scrollViewHeight/scrollViewWidth
        
        let imageRatio: Double! = model.galleryModel.ratio
        
        var size = CGSize(width: scrollViewWidth, height: scrollViewWidth)
        if imageRatio > scrollViewRatio {
            size = CGSize(width: scrollViewHeight/imageRatio, height: scrollViewHeight)
        }else if imageRatio < scrollViewRatio {
            size = CGSize(width: scrollViewWidth, height: scrollViewWidth*imageRatio)
        }
        
        imageView.frame.size = size
    }
    
    func scrollViewSize() -> CGSize {
        
        if let window = UIApplication.shared.keyWindow {
            
            let safeAreaInsetBottom = window.safeAreaInsets.bottom
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            let naviHeight = navigationController?.navigationBar.frame.height ?? 0.0
            let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0.0
            
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (statusBarHeight + naviHeight + tabBarHeight + safeAreaInsetBottom))
        }
        
        return scrollView.frame.size
    }
    
    func updateContentInsets() {
        
        let imageViewSize = imageView.frame.size
        let scrollViewSize = self.scrollViewSize()
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        
        let currentZoom = scrollView.zoomScale
        let minimumZoom = scrollView.minimumZoomScale
        let maximumZoom = scrollView.maximumZoomScale
        
        if currentZoom == maximumZoom {
            scrollView.setZoomScale(minimumZoom, animated: true)
        }else if currentZoom == minimumZoom {
            scrollView.setZoomScale(1.0, animated: true)
        }else{
            scrollView.setZoomScale(maximumZoom, animated: true)
        }
    }
}

extension ImageViewerViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateContentInsets()
    }
}
