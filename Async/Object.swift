//
//  Object.swift
//  Promise
//
//  Created by Grigoriy Sapogov on 25/06/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import Foundation

struct Employee: Codable {
    
    let id: String
    let employee_name: String
    
    enum EmployeeKeys: String, CodingKey {
        case id = "id"
        case employee_name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EmployeeKeys.self)
        id = try container.decode(String.self, forKey: .id)
        employee_name = try container.decode(String.self, forKey: .employee_name)
    }
    
}
