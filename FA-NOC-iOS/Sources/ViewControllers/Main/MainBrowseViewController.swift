//
//  MainBrowseViewController.swift
//  FA-NOC-iOS
//
//  Created by joowon on 18/12/2018.
//  Copyright © 2018 zenex. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

class MainBrowseViewController: MainBaseViewController {

    @IBOutlet private weak var infinityGalleryView: InfinityGallery!
    
    private var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infinityGalleryView.infGalleryDelegate = self
        infinityGalleryView.numberOfColumns.accept(Int(Settings.getBrowse().columnCount)!)
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let settingViewController = segue.destination as? SettingTableViewController
        settingViewController?.type = .browse
        settingViewController?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if infinityGalleryView.refreshControl!.isRefreshing {
            infinityGalleryView.refreshControl!.endRefreshing()
        }
    }
}

extension MainBrowseViewController: InfinityGalleryDelegate {
    
    func infinityGallery(_ infinityGallery: InfinityGallery, didSelectItemAt item: GalleryItemModel) {
        
        //넘겨받은 정보로 세부창으로 이동 - 모델을 받도록 변경 필요
        print(item)
        
        let viewController = SubmissionViewController.loadViewController(.Submission)
        viewController.galleryModel = item
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func preLoading(in infinityGallery: InfinityGallery, initialLoad flag: Bool) {

        ImageLoadScheduler.shared.load(weakify { strongSelf, completion in
            strongSelf.page = (flag ? 1 : strongSelf.page+1)
            let prevPage = strongSelf.page-1
            Service.browse(strongSelf.page)
                .subscribe(onNext: { models in
                    infinityGallery.add(items: models, isInit: flag)
                    completion()
                }, onError: { error in
                    strongSelf.page = prevPage
                    infinityGallery.add(items: [], isInit: false)
                    completion()
                }, onCompleted: completion)
                .disposed(by: strongSelf.rx.disposeBag)
        }, isInit: flag)
    }
}

extension MainBrowseViewController: SettingTableViewControllerDelegate {
    
    func chagedSetting(_ onlyLayout: Bool) {
        
        if onlyLayout {
            infinityGalleryView.numberOfColumns.accept(Int(Settings.getBrowse().columnCount)!)
        }else{
            preLoading(in: infinityGalleryView, initialLoad: true)
        }
    }
}

extension MainBrowseViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.show(viewControllerToCommit, sender: self)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let locationCell = infinityGalleryView.convert(location, from: view)
        
        guard let indexPath = infinityGalleryView.indexPathForItem(at: locationCell) else {
            print(locationCell)
            print("Cell Not found")
            return nil
        }
        
        print("indexPath.row :: \(indexPath.row)")
        guard let cell = infinityGalleryView.cellForItem(at: indexPath) else { return nil }
        
        let viewController = SubmissionViewController.loadViewController(.Submission)
        viewController.galleryModel = infinityGalleryView.item(indexPath)
        
        previewingContext.sourceRect = infinityGalleryView.convert(cell.frame, to: infinityGalleryView.superview)
        
        return viewController
    }
}
