//
//  UserDTO.swift
//  
//
//  Created by Moon Jongseek on 2022/08/10.
//

import Foundation

struct UserDTO: Codable {
    var id: UUID?
    var userName: String?
    var firstCardID: String?
    var secondCardID: String?
    var sharedCardIDs: [String]?
    var token: String?
}
