//
//  NumbersTableViewCell.swift
//  FA-NOC-iOS
//
//  Created by joowon on 06/01/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NumbersTableViewCell: UITableViewCell {
    
    weak var delegate: SettingDetailDelegate?
    var disposeBag: DisposeBag!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var numbersSegment: UISegmentedControl!

    func binding(model: SettingModel) {
        
        titleLabel?.text = model.name
        
        let selectedIndex = Array(0..<5).filter{numbersSegment.titleForSegment(at: $0) == model.selectedSection.selectedItem?.value}.first!
        numbersSegment.selectedSegmentIndex = selectedIndex
        
        disposeBag = DisposeBag()
        numbersSegment.rx.value.asObservable()
            .distinctUntilChanged()
            .skip(1)
            .map{self.numbersSegment.titleForSegment(at: $0)!}
            .subscribe(onNext: { [unowned self] value in
                model.select(value: value)
                self.delegate?.didSelect(model)
            }).disposed(by: disposeBag)
    }
}
