//
//  SearchFilterInteractor.swift
//  CocktailApp
//
//

import RIBs
import RxCocoa
import RxSwift

protocol SearchFilterRouting: ViewableRouting {
}

protocol SearchFilterPresentable: Presentable {
    var listener: SearchFilterPresentableListener? { get set }
}

protocol SearchFilterListener: AnyObject {
}

final class SearchFilterInteractor: PresentableInteractor<SearchFilterPresentable>, SearchFilterInteractable, SearchFilterPresentableListener {

    weak var router: SearchFilterRouting?
    weak var listener: SearchFilterListener?
    
    private let repository: CommonRepository
    
    var filterInputRelay: PublishRelay<FilterType> = PublishRelay<FilterType>()

    init(presenter: SearchFilterPresentable, repository: CommonRepository) {
        self.repository = repository
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        repository.filter.saveFilterContentsFromAPI()
            .subscribe(onCompleted: {
                print("saveFiltercompleted")
            })
            .disposeOnDeactivate(interactor: self)

        let ings = repository.filter.fetchFilterContents(type: .ingredient)
//        let glasses = repository.filter.fetchFilterContents(type: .glass)
//        let categories = repository.filter.fetchFilterContents(type: .category)
//
//        print(ings)
//        print(glasses)
//        print(categories)
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
