//
//  Card.swift
//  
//
//  Created by Moon Jongseek on 2022/08/09.
//

import Fluent
import Vapor

final class Card: Model, Content {
    static let schema = "card"
    
    /// User의 DB ID
    @ID(key: .id)
    var id: UUID?
    
    /// User의 닉네임
    @Field(key: "userName")
    var userName: String
    
    /// User의 받은 카드 ID
    @Field(key: "firstString")
    var firstString: String
    
    @Field(key: "secondString")
    var secondString: String
    
    init() {
        
    }

    init(id: UUID? = nil,
         userName: String,
         firstString: String,
         secondString: String
    ) {
        self.id = id
        self.userName = userName
        self.firstString = firstString
        self.secondString = secondString
    }
}
