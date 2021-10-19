//
//  FilterInteractor.swift
//  CocktailApp
//
//

import Foundation
import RIBs
import RxRelay
import RxSwift

protocol FilterRouting: Routing {
    func cleanupViews()
}

protocol FilterListener: AnyObject {
    var isLoadingRelay: BehaviorRelay<Bool> { get }
    var filterTypeRelay: PublishRelay<FilterType> { get }
    var filterKeywordsRelay: BehaviorRelay<[String]> { get }
}

final class FilterInteractor: Interactor, FilterInteractable {

    weak var router: FilterRouting?
    weak var listener: FilterListener?
    
    private let repository: CommonRepository

    init(repository: CommonRepository) {
        self.repository = repository
        super.init()
    }
    
    // MARK: - Override

    override func didBecomeActive() {
        super.didBecomeActive()
        saveFilterKeywords()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
    }
    
    // MARK: - Private
    
    private func checkSavedKeywords() {
        let current = Date().toString()
        
        if UserShared.Info.lastFilterSaveTime.isEmpty || UserShared.Info.lastFilterSaveTime < current {
            UserShared.Info.lastFilterSaveTime = current
            
            saveFilterKeywords()
        }
    }
    
    private func saveFilterKeywords() {
        listener?.isLoadingRelay.accept(true)
        
        repository.filter.writeFilterKeywords()
            .subscribe(with: self, onCompleted: { owner in
                owner.listener?.isLoadingRelay.accept(false)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func bind() {
        listener?.filterTypeRelay
            .bind(with: self, onNext: { owner, type in
                owner.getKeywords(type: type)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func getKeywords(type: FilterType) {
        guard let listener = listener else { return }
          
        repository.filter.fetchFilterKeywords(type: type)
            .bind(to: listener.filterKeywordsRelay)
            .disposeOnDeactivate(interactor: self)
    }
}
