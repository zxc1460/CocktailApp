//
//  LoadingManager.swift
//  CocktailApp
//
//

import Foundation
import RxRelay
import RxSwift

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    public var loadingStateChanged = BehaviorRelay<Bool>(value: false)
    
    public var isLoading: Bool {
        get {
            return loadingStateChanged.value
        }
        set {
            loadingStateChanged.accept(newValue)
        }
    }
}
