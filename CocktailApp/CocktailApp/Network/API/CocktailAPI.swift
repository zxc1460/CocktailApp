//
//  APIService.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/09/24.
//

import Foundation
import Moya

enum ListType: String, CaseIterable {
    case popular
    case latest
    case random = "randomselection"
}

enum CocktailAPI {
    case cocktailList(type: ListType)
    case detail(id: String)
}

extension CocktailAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constant.shared.baseURL) else {
            fatalError()
        }
        return url
    }
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .cocktailList(let type):
            return "/\(type.rawValue).php"
        case .detail:
            return "lookup.php"
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        return .get
    }
    
    // MARK: - Task
    
    var task: Task {
        switch self {
        case .cocktailList:
            return .requestPlain
        case .detail(let id):
            return .requestParameters(parameters: ["i": id], encoding: URLEncoding.queryString)
        }
    }
    
    // MARK: - Data
    
    var sampleData: Data {
        return Data()
    }
    
    // MARK: - Headers
    
    var headers: [String: String]? {
        return ["x-rapidapi-host": Constant.shared.host,
                "x-rapidapi-key": Constant.shared.key]
    }
}
