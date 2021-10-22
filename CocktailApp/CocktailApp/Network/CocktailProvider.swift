//
//  CocktailProvider.swift
//  CocktailApp
//
//

import Foundation
import Moya

final class CocktailProvider<T: TargetType>: MoyaProvider<T> {
    init() {
        let networkActivityClosure: NetworkActivityPlugin.NetworkActivityClosure = { activity, _ in
            switch activity {
            case .began:
                NetworkManager.shared.isLoading = true
            case .ended:
                NetworkManager.shared.isLoading = false
            }
        }
        
        super.init(plugins: [NetworkActivityPlugin(networkActivityClosure: networkActivityClosure)])
    }
}
