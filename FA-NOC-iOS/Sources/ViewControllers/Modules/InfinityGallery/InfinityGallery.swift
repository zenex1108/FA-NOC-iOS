//
//  InfinityGallery.swift
//  FA-NOC-iOS
//
//  Created by joowon on 24/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import NSObject_Rx

protocol InfinityGalleryDelegate: NSObjectProtocol {
    
    func infinityGallery(_ infinityGallery: InfinityGallery, didSelectItemAt item: GalleryItemModel)
    func preLoading(in infinityGallery: InfinityGallery, initialLoad flag: Bool)
}

protocol InfinityGalleryDatasource: NSObjectProtocol {
    
    func numberOfColomns(in infinityGallery: InfinityGallery) -> Int
}

class InfinityGallery: InfinityCollectionView {

    weak var infGalleryDelegate: InfinityGalleryDelegate?
    weak var infGalleryDataSource: InfinityGalleryDatasource!
    
    private var items = [GalleryItemModel]()
    
    var numberOfColumns = BehaviorRelay<Int>(value: 2)
    private var overlapCount: Int = 0
    
    override func awakeFromNib() {
        
        contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        register(UINib(nibName: InfinityGalleryCell.className, bundle: nil), forCellWithReuseIdentifier: InfinityGalleryCell.className)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        infDataSource = self
        infDelegate = self
        
        infLayout = InfinityCollectionViewLayout(self, cellSpacing: cellSpacing(in: self), numberOfColumns: numberOfColumns.value)
        
        super.awakeFromNib()
        
        numberOfColumns
            .distinctUntilChanged()
            .map{($0,self.items)}
            .subscribe(onNext: initReloadData)
            .disposed(by: rx.disposeBag)
    }
    
    private func initReloadData(_ numberOfColumns: Int, items: [GalleryItemModel]) {
        
        infLayout.refresh(numberOfColumns: numberOfColumns)
        
        let prevItemCount = self.items.count
        let visibles = indexPathsForVisibleItems
        let prevIndexPath = (prevItemCount<=items.count && visibles.count>0 ? indexPathsForVisibleItems[visibles.count/2] : nil)
        
        self.items = items
        reloadData()
        
        if let indexPath = prevIndexPath {
            scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }else{
            scrollRectToVisible(.zero, animated: true)
        }
    }
    
    private func updateUI(isInit: Bool = false) {
        
        isUserInteractionEnabled = !isInit
        
        if items.count == 0 {
            if isInit {
                indicator.startAnimating()
            }else{
                indicator.stopAnimating()
            }
        }else{
            if isInit {
            }else{
                if refreshControl!.isRefreshing {
                    refreshControl!.endRefreshing()
                }
            }
        }
    }
    
    open func add(items: [GalleryItemModel], isInit: Bool) {
        
        objc_sync_enter(self)
        defer{objc_sync_exit(self)}
        
        updateUI()
        
        if isInit {
            
            initReloadData(numberOfColumns.value, items: items)
            possibledLoad = true
        }else{
            
            possibledLoad = true
            
            let distinctedItems = distincted(items)
            if distinctedItems.count > 0 {
                
                self.items.append(contentsOf: distinctedItems)
                reloadData()
            }else{
                
                let needInitLoad = (overlapCount >= self.items.count)
                preLoading(in: self, initialLoad: needInitLoad)
                
                if needInitLoad {
                    scrollRectToVisible(.zero, animated: false)
                }
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
                
                overlapCount += 1
            }
        }
        
        if mutateItems.count > 0 {
            overlapCount = 0
        }
        
        return mutateItems
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        
        isUserInteractionEnabled = false
        ImageCache.default.clearMemoryCache()
        
        possibledLoad = true
        preLoading(in: self, initialLoad: true)
    }
    
    private func loadPlaceholder(_ indexPath: IndexPath) -> Placeholder {
        
        let width = infLayout.cellWidth
        let heightRatio = infinityCollectionView(self, heightRatioAt: indexPath)
        let tip = minimumRatio(in: self)
        
        return GalleryPlaceholder(width: width, heightRatio: heightRatio, tip: tip)
    }
    
    public func item(_ indexPath: IndexPath) -> GalleryItemModel? {
        let index = indexPath.item
        guard index >= 0 && index < items.count else { return nil }
        return items[index]
    }
}

extension InfinityGallery: InfinityCollectionViewDataSource {
    
    func cellSpacing(in infinityCollectionView: InfinityCollectionView) -> Double {
        return 2
    }
    
    func preLoadingYOffset(in infinityCollectionView: InfinityCollectionView) -> CGFloat {
        return infinityCollectionView.bounds.height + CGFloat(Double(items.count*50)/pow(Double(numberOfColumns.value),2))
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
        cell.binding(model, numberOfColumns: numberOfColumns.value, placeholder: loadPlaceholder(indexPath))
        
        return cell
    }
}

extension InfinityGallery: InfinityCollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = items[indexPath.item]
        infGalleryDelegate?.infinityGallery(self, didSelectItemAt: model)
    }
    
    func preLoading(in infinityCollectionView: InfinityCollectionView, initialLoad flag: Bool) {
        updateUI(isInit: flag)
        infGalleryDelegate?.preLoading(in: self, initialLoad: flag)
    }
}
