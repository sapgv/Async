//
//  MoyaService.swift
//  Promise
//
//  Created by Grigoriy Sapogov on 25/06/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import Moya

enum MyService {
    
    case employees
    case employee(_ id: String)
}

extension MyService: TargetType {
    
    var baseURL: URL { return URL(string: "http://dummy.restapiexample.com/api/v1")! }
    var path: String {
        switch self {
        case .employees:
            return "/employees"
        case .employee(let id):
            return "/employee/\(id)"
        }
    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        switch self {
        case .employees, .employee:
            return .requestPlain
        }
    }
    var sampleData: Data {
        return Data()
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
