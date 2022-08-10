//
//  CardDTO.swift
//  
//
//  Created by Moon Jongseek on 2022/08/10.
//

import Foundation

struct CardDTO: Codable {
    var userID: UUID
    var userName: String?
    var firstString: String?
    var secondString: String?
    var isRight: Bool?
    
    func createCard() -> Card {
        return Card(userName: self.userName ?? "",
                    firstString: self.firstString ?? "",
                    secondString: self.secondString ?? "")
    }
}



