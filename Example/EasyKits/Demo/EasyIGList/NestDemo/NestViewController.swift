//
//  NestViewController.swift
//  ShiHuiFeiZhu
//
//  Created by Ming on 2021/8/24.
//

import Foundation
import IGListKit
import RxSwift
import RxCocoa
import EasyKits
import MJRefresh

class NestViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    lazy var sections: [ListBaseSection] = (0...10).map { _ in
        ListBaseSection().then {
            $0.add(ListEmptyItem(bgColor: .red, itemHeight: 50))
        }
    }
    
    lazy var collectionView = EasyNestListPagingView().then {
        $0.nestDataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(collectionView) { maker in
            maker.leading.trailing.bottom.equalTo(0)
            maker.top(equalToController: self)
        }
        collectionView.pagingContainer = NestCategoryViewController()
        
        let requestResult = collectionView.rx.headerRefresh
            .asDriver()
            .flatMapLatest {
                NestViewController.request().asDriver(onErrorDriveWith: .empty())
            }
    
        requestResult
            .map { .normal }
            .drive(collectionView.rx.endRefresh)
            .disposed(by: disposeBag)

        requestResult
            .drive(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                self.sections = (0...20).map { _ in
                    ListBaseSection().then {
                        $0.add(ListEmptyItem(bgColor: .red, itemHeight: 50))
                    }
                }
                self.collectionView.adapter.performUpdates(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    static func request() -> Observable<Void> {
        return Observable<Void>.just(())
            .delay(.seconds(2), scheduler: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
    
    deinit {
        print("\(Self.self)")
    }
}

extension NestViewController: EasyNestListPagingViewDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        sections
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        ListBindingBaseSectionController()
    }
}
