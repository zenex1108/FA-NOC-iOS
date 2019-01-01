//
//  InfinityCollectionView.swift
//  FA-NOC-iOS
//
//  Created by joowon on 18/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

protocol InfinityCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    func preLoading(in infinityCollectionView: InfinityCollectionView, initialLoad flag: Bool)
}

protocol InfinityCollectionViewDataSource: UICollectionViewDataSource {
    
    func numberOfColomn(in infinityCollectionView: InfinityCollectionView) -> Int
    func preLoadingYOffset(in infinityCollectionView: InfinityCollectionView) -> CGFloat
    func minimumRatio(in infinityCollectionView: InfinityCollectionView) -> Double
    func maximumRatio(in infinityCollectionView: InfinityCollectionView) -> Double
    func cellSpacing(in infinityCollectionView: InfinityCollectionView) -> Double
    
    func infinityCollectionView(_ infinityCollectionView: InfinityCollectionView, heightRatioAt indexPath: IndexPath) -> Double
}

class InfinityCollectionView: UICollectionView {
    
    open weak var infDelegate: InfinityCollectionViewDelegate! {
        willSet{
            delegate = newValue
        }
    }
    open weak var infDataSource: InfinityCollectionViewDataSource! {
        willSet{
            dataSource = newValue
        }
    }
    open var infLayout: InfinityCollectionViewLayout! {
        willSet{
            collectionViewLayout = newValue
        }
    }
    
    open var possibledLoad = true
    open var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicator = UIActivityIndicatorView(style: .gray)
        backgroundView = indicator
    }
}

extension InfinityCollectionView: UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard possibledLoad else { return }
        
        let preLoadingOffset = infDataSource.preLoadingYOffset(in: self)
        let bottomOffset = scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.bounds.height + scrollView.contentInset.top
        
        if bottomOffset < preLoadingOffset {
            possibledLoad = false
            infDelegate?.preLoading(in: self, initialLoad: false)
        }
    }
}

extension InfinityCollectionView: InfinityCollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView:UICollectionView, heightAtIndexPath indexPath:IndexPath) -> Double {
        
        let numberOfColomn = infDataSource.numberOfColomn(in: self)
        let cellSpacing = infDataSource.cellSpacing(in: self)
        
        let minRatio = infDataSource.minimumRatio(in: self)
        let maxRatio = infDataSource.maximumRatio(in: self)
        let ratio = infDataSource.infinityCollectionView(self, heightRatioAt: indexPath)
        
        let viewWidth = Double(collectionView.bounds.width)
        let emptyWidth = Double(contentInset.left+contentInset.right) + Double(numberOfColomn-1)*cellSpacing
        
        let cellWidth = (viewWidth-emptyWidth)/Double(numberOfColomn)
        let cellHeight = cellWidth*max(minRatio,min(ratio, maxRatio))
        
        return cellHeight
    }
}
