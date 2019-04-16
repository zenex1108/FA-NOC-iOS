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
    
    var galleryModel: GalleryItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        navigationItem.titleView = navigationTitleLabel
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 86.0
        
        bind()
    }
}

extension SubmissionViewController {
    
    func bind(){
        guard let galleryModel = galleryModel else { return }
        
        indicator.startAnimating()
        
        let dataSource = RxTableViewSectionedReloadDataSource<SubmissonSection>(
            configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
                
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
        })
        
        //////////////////////////////////////////////////////////
        
        let shared = Service.view(galleryModel).share()
        
        shared.map{$0.galleryModel.title}
            .do(onNext: {[weak self] _ in self?.indicator.stopAnimating()})
            .bind(to: navigationTitleLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        shared.map { model -> [SubmissonSection] in
            return [SubmissonSection(items: [model,model,model,model]),
                    SubmissonSection(items: model.commentsSet.comments)]
            }.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
    }
}
