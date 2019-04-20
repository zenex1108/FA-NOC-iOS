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
import RxDataSources
import RxCocoa

struct SubmissonSection {
    var items: [Item]
}

extension SubmissonSection: SectionModelType {
    typealias Item = SubmissionCellDataProtocol
    typealias type = Item.Type
    
    init(original: SubmissonSection, items: [Item]) {
        self = original
        self.items = items
    }
}

class SubmissionViewController: BaseViewContorller {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var indicator: UIActivityIndicatorView!
    private var navigationTitleLabel: UILabel!
    
    var galleryModel: GalleryItemModel? {
        didSet{
            guard let model = galleryModel else { return }
            let width = Double(view.bounds.width)
            let height = width * model.ratio
            preferredContentSize = CGSize(width: width, height: height)
        }
    }
    var possibledLoad = true
    
    var disposeBag: DisposeBag!
    var dataRelay = PublishRelay<SubmissionModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        indicator = UIActivityIndicatorView(style: .gray)
        tableView.backgroundView = indicator
        
        navigationTitleLabel = {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44.0))
            titleLabel.backgroundColor = .clear
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
            return titleLabel
        }()
        navigationTitleLabel.text = galleryModel?.title
        navigationItem.titleView = navigationTitleLabel
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 86.0
        
        bind()
    }
    
    @objc private func refresh(_ sender: UIRefreshControl?=nil) {
        guard let galleryModel = galleryModel else { return }
        loadData(galleryModel)
    }
}

extension SubmissionViewController {
    
    func bind(){
        
        let dataSource = RxTableViewSectionedReloadDataSource<SubmissonSection>(
            configureCell: { dataSource, tableView, indexPath, item -> UITableViewCell in
            
            let section = indexPath.section
            let index = indexPath.item
            
            var cell: UITableViewCell!
            
            if section == 0 {
                if let model = item as? SubmissionModel {
                    
                    var submissionCell: SubmissionCellProtocol!
                    
                    switch index {
                    case 0:
                        let imageCell: ImageCell = tableView.cell("imageCell")
                        submissionCell = imageCell
                        cell = imageCell
                    case 1:
                        let infoCell: InfoCell = tableView.cell("infoCell")
                        submissionCell = infoCell
                        cell = infoCell
                    case 2:
                        let contentCell: ContentCell = tableView.cell("contentCell")
                        submissionCell = contentCell
                        cell = contentCell
                    case 3:
                        let keywordsCell: KeywordsCell = tableView.cell("keywordsCell")
                        submissionCell = keywordsCell
                        cell = keywordsCell
                    default: break
                    }
                    
                    submissionCell.bind(model)
                }
            }else if section == 1 {
                if let model = item as? CommentModel {
                    
                    let commentCell: CommentCell = tableView.cell("commentCell")
                    commentCell.bind(model)
                    cell = commentCell
                }
            }
            
            return cell
        }, canEditRowAtIndexPath: { dataSource, indexPath in
            return (indexPath.section == 1)
        })
        
        //////////////////////////////////////////////////////////
        
        dataRelay
            .map { model -> [SubmissonSection] in
                return [SubmissonSection(items: [model,model,model,model]),
                        SubmissonSection(items: model.commentsSet.comments)]
            }.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        //////////////////////////////////////////////////////////
        
        refresh()
    }
    
    func loadData(_ galleryModel: GalleryItemModel) {
        guard possibledLoad else { return }
        
        possibledLoad = false
        tableView.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        Service.view(galleryModel)
            .do(onNext: { [weak self] _ in
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.isUserInteractionEnabled = true
                self?.indicator.stopAnimating()
                self?.possibledLoad = true
            }).bind(to: dataRelay)
            .disposed(by: rx.disposeBag)
    }
}

extension SubmissionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let hideAction = UIContextualAction(style: .normal, title: "Hide") {
            action, view, success in
            
            success(true)
        }
        hideAction.backgroundColor = .red
        hideAction.image = #imageLiteral(resourceName: "invisible")
        
        return UISwipeActionsConfiguration(actions: [hideAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let replyAction = UIContextualAction(style: .normal, title: "Reply") {
            action, view, success in
            
            success(true)
        }
        replyAction.backgroundColor = .blue
        replyAction.image = #imageLiteral(resourceName: "speech_buble")
        
        return UISwipeActionsConfiguration(actions: [replyAction])
    }
}

extension SubmissionViewController {
    
    override var previewActionItems: [UIPreviewActionItem] {
        
        let favoriteAction = UIPreviewAction(title: "Favorite", style: .default) {
            action, viewController in
            
        }
        
        let downloadAction = UIPreviewAction(title: "Download", style: .default) {
            action, viewController in
            
        }
        
        return [favoriteAction, downloadAction]
    }
}
