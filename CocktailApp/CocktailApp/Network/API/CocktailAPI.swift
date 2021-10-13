//
//  APIService.swift
//  CocktailApp
//
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
    case search(name: String)
    case filter(type: FilterType, keyword: String)
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
        case .search:
            return "search.php"
        case .filter:
            return "filter.php"
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
        case .search(let name):
            return .requestParameters(parameters: ["s": name], encoding: URLEncoding.queryString)
        case .filter(let type, let keyword):
            return .requestParameters(parameters: [type.rawValue: keyword], encoding: URLEncoding.queryString)
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
