//
//  CocktailRepository.swift
//  CocktailApp
//
// 

import Foundation
import Moya
import RxMoya
import RxSwift

final class CocktailRepository {
    private let cocktailService: MoyaProvider<CocktailAPI>
    private let cocktailDAO: CocktailDAO
    
    init() {
        self.cocktailService = MoyaProvider<CocktailAPI>()
        self.cocktailDAO = CocktailDAO()
    }
    
    // MARK: - Private
    
    private func getCocktailList(of type: ListType) -> Observable<[Cocktail]> {
        return cocktailService.rx.request(.cocktailList(type: type))
            .asObservable()
            .map(CocktailResponse.self)
            .compactMap { $0.data }
    }
    
    private func getSavedCocktailList(from list: [Cocktail]) -> [CocktailData] {
        var result = [CocktailData]()
        
        for data in list {
            if let savedData = self.cocktailDAO.read(id: data.id) {
                result.append(savedData)
            } else {
                let cocktailData = CocktailData(data)
                self.cocktailDAO.insert(data: cocktailData)
                result.append(cocktailData)
            }
        }
        
        return result
    }
    
    private func getCocktailDetail(from id: String) -> Observable<CocktailData> {
        self.cocktailService.rx.request(.detail(id: id))
            .asObservable()
            .map(CocktailResponse.self)
            .compactMap { $0.data?.first }
            .map { CocktailData($0) }
    }
    
    private func saveCocktailDetail(data: CocktailData) {
        self.cocktailDAO.insert(data: data)
    }
    
    func loadCocktailList(of type: ListType) -> Single<[CocktailData]> {
        return Single<[CocktailData]>.create { [weak self] single in
            guard let self = self else {
                fatalError("reference of CocktailRepository already released is used.")
            }
            
            let disposable = self.getCocktailList(of: type)
                .subscribe(onNext: { list in
                    single(.success(self.getSavedCocktailList(from: list)))
                })
            
            return Disposables.create { disposable.dispose() }
        }
    }
    
    func loadCocktailDetail(from id: String) -> Observable<CocktailData?> {
        if let data = self.cocktailDAO.read(id: id) {
            return Observable.just(data)
        }
        
        return Observable<CocktailData?>.create { [weak self] observer in
            guard let self = self else {
                fatalError("reference of CocktailRepository already released is used.")
            }
            
            let disposable = self.getCocktailDetail(from: id)
                .subscribe(onNext: { cocktail in
                    self.saveCocktailDetail(data: cocktail)
                    observer.onNext(cocktail)
                }, onCompleted: {
                    observer.onCompleted()
                })
            
            return Disposables.create { disposable.dispose() }
        }
    }
    
    func searchCocktail(name: String) -> Observable<[CocktailData]> {
        guard name.count > 0 else {
            return Observable.just([])
                .asObservable()
        }
        
        return Observable<[CocktailData]>.create { [weak self] observer in
            guard let self = self else {
                fatalError("reference of CocktailRepository already released is used.")
            }
            
            let disposable = self.cocktailService.rx.request(.search(name: name))
                .asObservable()
                .map(CocktailResponse.self)
                .compactMap { $0.data }
                .subscribe(onNext: { list in
                    var result = [CocktailData]()
                    
                    for data in list {
                        if let cocktailData = self.cocktailDAO.read(id: data.id) {
                            result.append(cocktailData)
                        } else {
                            let cocktailData = CocktailData(data)
                            result.append(cocktailData)
                            self.cocktailDAO.insert(data: cocktailData)
                        }
                    }
                    
                    observer.onNext(result)
                }, onCompleted: {
                    observer.onCompleted()
                })
            
            
            return Disposables.create { disposable.dispose() }
        }
    }
    
    func searchCocktail(type: FilterType, keyword: String) -> Observable<[CocktailSnippet]> {
        return cocktailService.rx.request(.filter(type: type, keyword: keyword))
            .asObservable()
            .map { try JSONDecoder().decode(CocktailSnippetResponse.self, from: $0.data) }
            .catchAndReturn(CocktailSnippetResponse(data: []))
            .compactMap { $0.data }
    }
}
