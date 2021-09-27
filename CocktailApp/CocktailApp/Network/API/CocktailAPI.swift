//
//  APIService.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/24.
//

import Foundation
import Moya

enum ListType: String {
    case popular
    case latest
}

enum CocktailAPI {
    case cocktailsList(type: ListType)
}

extension CocktailAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constant.baseURL) else {
            fatalError()
        }
        return url
    }
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .cocktailsList(let type):
            return "/\(type.rawValue).php"
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        return .get
    }
    
    // MARK: - Task
    
    var task: Task {
        switch self {
        case .cocktailsList:
            return .requestPlain
        }
    }
    
    // MARK: - Data
    
    var sampleData: Data {
        return Data()
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        return ["x-rapidapi-host": Constant.host,
                "x-rapidapi-key": Constant.key]
    }
}