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

    @IBOutlet var infinityGalleryView: InfinityGallery!
    
    private var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infinityGalleryView.infGalleryDelegate = self
        
        //파라미터로 넘겨줘야 할 설정을 가져온다
        //가져온 파라미터로 호출
        //변환된 모델을 순차적으로 인피니티로 넘긴다
        //마지막 위치가 보이기 전에 푸터로 인디케이터 표시하고
        //
    }
}

extension MainBrowseViewController: InfinityGalleryDelegate {
    
    func infinityGallery(_ infinityGallery: InfinityGallery, didSelectItemAt item: GalleryItemModel) {
        
        //넘겨받은 정보로 세부창으로 이동 - 모델을 받도록 변경 필요
        print(item)
    }
    
    func preLoading(in infinityGallery: InfinityGallery, initialLoad flag: Bool) {
        
        //추가 로딩 신호를 받으면 추가로 요청한 후 모델로 변경 후 아이템 추가 - 아이템 추가 함수 자체를 파라미터로 받도록 하기
        
        page = (flag ? 1 : page+1)
        Service.browse(page)
            .subscribe(onNext: { models in
                infinityGallery.add(items: models, isInit: flag)
            }, onError: { error in
                infinityGallery.add(items: [], isInit: false)
            }).disposed(by: rx.disposeBag)
    }
}
