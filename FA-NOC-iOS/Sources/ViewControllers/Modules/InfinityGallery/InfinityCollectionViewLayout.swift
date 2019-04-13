//
//  InfinityCollectionViewLayout.swift
//  FA-NOC-iOS
//
//  Created by joowon on 31/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit

protocol InfinityCollectionViewLayoutDelegate: NSObjectProtocol {
    func collectionView(_ collectionView:UICollectionView, heightRatioAtIndexPath indexPath:IndexPath) -> Double
}

class InfinityCollectionViewLayout: UICollectionViewLayout {
    
    weak private var delegate: InfinityCollectionViewLayoutDelegate!
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var numberOfColumns: Int = 1
    private var cellSpacing: Double = 0

    private var globalOffsets = [Double]()
    private var globalIndex: Int = 0
    
    private var nextColumnOffset: (Int,Double) {
        set{
            let colomnIndex = newValue.0
            let newOffsetY = newValue.1
            
            assert(colomnIndex < numberOfColumns, "colomnIndex should be smaller than numberOfColumns")
                
            let oldOffsetY = globalOffsets[colomnIndex]
            
            globalOffsets[colomnIndex] = max(oldOffsetY,newOffsetY)
        }
        get{
            return globalOffsets.enumerated().sorted{($0.1,$0.0)<($1.1,$1.0)}.first!
        }
    }
    
    func refresh(numberOfColumns: Int = 0) {
        
        cache.removeAll()
        
        if numberOfColumns > 0 {
            self.numberOfColumns = numberOfColumns
            globalOffsets = [Double](repeating: 0, count: numberOfColumns)
        }else{
            globalOffsets = [Double](repeating: 0, count: self.numberOfColumns)
        }
        globalIndex = 0
    }
    
    private override init() {
        super.init()
    }
    
    convenience init(_ delegate: InfinityCollectionViewLayoutDelegate, cellSpacing:Double, numberOfColumns:Int) {
        self.init()
        
        assert(numberOfColumns>0, "numberOfColumns must be greater than 0")
        
        self.delegate = delegate
        self.numberOfColumns = numberOfColumns
        self.cellSpacing = cellSpacing
        
        globalOffsets = [Double](repeating: 0, count: numberOfColumns)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let contentInset = collectionView.contentInset
        let height = CGFloat(globalOffsets.sorted(by:>).first!)
        return CGSize(width: collectionView.bounds.width-contentInset.left-contentInset.right, height: height)
    }
    
    var cellWidth: Double {
        
        guard let collectionView = collectionView else { return 0 }
        
        let viewWidth = Double(collectionView.bounds.width)
        let contentInset = collectionView.contentInset
        let emptyWidth = Double(contentInset.left+contentInset.right) + Double(numberOfColumns-1)*cellSpacing
        
        let cellWidth = (viewWidth-emptyWidth)/Double(numberOfColumns)
        
        return cellWidth
    }
    
    override func prepare() {
        
        guard let collectionView = collectionView else { return }
        
        let lastIndex = collectionView.numberOfItems(inSection: 0)-1
        guard lastIndex >= globalIndex else { return }
        
        let width = cellWidth
        for item in globalIndex...lastIndex {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let height = width*delegate.collectionView(collectionView, heightRatioAtIndexPath: indexPath)
            
            let offset = nextColumnOffset
            let offsetX = (width+cellSpacing)*Double(offset.0)
            let offsetY = nextColumnOffset.1
            
            let frame = CGRect(x: offsetX, y: offsetY, width: width, height: height)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
            
            nextColumnOffset.1 = offsetY+height+cellSpacing
        }
        
        globalIndex = lastIndex+1
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter{$0.frame.intersects(rect)}
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
