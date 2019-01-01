//
//  InfinityGallery.swift
//  FA-NOC-iOS
//
//  Created by joowon on 24/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import Kingfisher

protocol InfinityGalleryDelegate: NSObjectProtocol {
    
    func infinityGallery(_ infinityGallery: InfinityGallery, didSelectItemAt item: GalleryItemModel)
    func preLoading(in infinityGallery: InfinityGallery, initialLoad flag: Bool)
}

class InfinityGallery: InfinityCollectionView {

    weak var infGalleryDelegate: InfinityGalleryDelegate?
    
    var numberOfColumns: Int = 3
    private var items = [GalleryItemModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        register(UINib(nibName: InfinityGalleryCell.className, bundle: nil), forCellWithReuseIdentifier: InfinityGalleryCell.className)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        infDataSource = self
        infDelegate = self
        infLayout = InfinityCollectionViewLayout(self, cellSpacing: cellSpacing(in: self), numberOfColumns: numberOfColumns)
    }
    
    open func add(items: [GalleryItemModel], isInit: Bool) {
        
        objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        
        if self.items.count == 0 {
            indicator.stopAnimating()
            isUserInteractionEnabled = true
        }
        
        if isInit {
            
            infLayout.refresh()
            self.items.removeAll()
            
            self.items.append(contentsOf: items)
            reloadData()
            
            refreshControl?.endRefreshing()
            isUserInteractionEnabled = true
        }else{
            
            possibledLoad = true
            
            let distinctedItems = distincted(items)
            
            if distinctedItems.count > 0 {
                self.items.append(contentsOf: distinctedItems)
                reloadData()
            }else{
                preLoading(in: self, initialLoad: false)
            }
        }
    }
    
    private func distincted(_ items: [GalleryItemModel]) -> [GalleryItemModel] {
        guard self.items.count > 0, items.count > 0 else { return items }
        
        var mutateItems = items
        
        let lastItemIndex = Int64(self.items.last!.id)!
        
        while true {
            
            if mutateItems.count == 0 {
                break
            }
            
            let nextItemIndex = Int64(mutateItems.first!.id)!
            if nextItemIndex < lastItemIndex {
                break
            }else{
                let removed = mutateItems.removeFirst()
                print("\nRemoved", removed)
            }
        }
        
        return mutateItems
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        isUserInteractionEnabled = false
        preLoading(in: self, initialLoad: true)
    }
}

extension InfinityGallery: InfinityCollectionViewDataSource {
    
    func cellSpacing(in infinityCollectionView: InfinityCollectionView) -> Double {
        return 2
    }
    
    func numberOfColomn(in infinityCollectionView: InfinityCollectionView) -> Int {
        return numberOfColumns
    }
    
    func preLoadingYOffset(in infinityCollectionView: InfinityCollectionView) -> CGFloat {
        return infinityCollectionView.bounds.height + CGFloat(Double(items.count*50)/pow(Double(numberOfColumns),2))
    }
    
    func minimumRatio(in infinityCollectionView: InfinityCollectionView) -> Double {
        return 0.615
    }
    
    func maximumRatio(in infinityCollectionView: InfinityCollectionView) -> Double {
        return 1.625
    }
    
    func infinityCollectionView(_ infinityCollectionView: InfinityCollectionView, heightRatioAt indexPath: IndexPath) -> Double {
        return items[indexPath.item].ratio
    }
    
    //----------------------------------------------------------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = items[indexPath.item]
        let cell: InfinityGalleryCell = collectionView.cell(InfinityGalleryCell.className, for: indexPath)
        cell.binding(model, numberOfColmns: numberOfColumns)
        
        return cell
    }
}

extension InfinityGallery: InfinityCollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = items[indexPath.item]
        infGalleryDelegate?.infinityGallery(self, didSelectItemAt: model)
    }
    
    func preLoading(in infinityCollectionView: InfinityCollectionView, initialLoad flag: Bool) {
        if items.count == 0 {
            isUserInteractionEnabled = false
            indicator.startAnimating()
        }
        infGalleryDelegate?.preLoading(in: self, initialLoad: flag)
    }
}
