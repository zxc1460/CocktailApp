//
//  MoyaProviderExtension.swift
//  CocktailApp
//
//

import Moya

extension MoyaProvider {
    convenience init() {
        let networkActivityPlugin = NetworkActivityPlugin { change, _ in
            switch change {
            case .began:
                NetworkManager.shared.isLoading = true
            case .ended:
                NetworkManager.shared.isLoading = false
            }
        }
        
        self.init(plugins: [networkActivityPlugin])
    }
}
