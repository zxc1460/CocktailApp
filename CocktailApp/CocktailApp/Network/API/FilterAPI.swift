//
//  FilterAPI.swift
//  CocktailApp
//
//  Created by DoHyeong on 2021/10/08.
//

import Foundation
import Moya

enum FilterAPI {
    case list(type: FilterType)
}

extension FilterAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constant.shared.baseURL) else {
            fatalError()
        }
        return url
    }
    
    // MARK: - Path
    
    var path: String {
        switch self {
        case .list:
            return "list.php"
        }
    }
    
    // MARK: - Method
    
    var method: Moya.Method {
        return .get
    }
    
    // MARK: - Task
    
    var task: Task {
        switch self {
        case .list(let type):
            return .requestParameters(parameters: [type.rawValue: "list"], encoding: URLEncoding.queryString)
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
