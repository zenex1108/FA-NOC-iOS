//
//  SwitchTableViewCell.swift
//  FA-NOC-iOS
//
//  Created by joowon on 05/01/2019.
//  Copyright © 2019 zenex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SwitchTableViewCell: UITableViewCell {

    weak var delegate: SettingDetailDelegate?
    var disposeBag: DisposeBag!

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var toggleSwitch: UISwitch!

    func binding(model: SettingModel) {
        
        titleLabel?.text = model.name
        toggleSwitch.isOn = (model.selectedSection.selectedItem!.value == "on")
        
        disposeBag = DisposeBag()
        toggleSwitch.rx.isOn.asObservable()
            .distinctUntilChanged().skip(1)
            .map{$0 ? "on":"off"}
            .subscribe(onNext: { [unowned self] value in
                model.select(value: value)
                self.delegate?.didSelect(model)
            }).disposed(by: disposeBag)
    }
}
