//
//  File.swift
//  
//
//  Created by Moon Jongseek on 2022/08/09.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "user"
    
    /// User의 DB ID
    @ID(key: .id)
    var id: UUID?
    
    /// User의 닉네임
    @Field(key: "userName")
    var userName: String
    
    @OptionalField(key: "firstCardID")
    var firstCardID: String?
    
    @OptionalField(key: "secondCardID")
    var secondCardID: String?
    
    /// User의 받은 카드 ID
    @Field(key: "sharedCardIDs")
    var sharedCardIDs: [String]
    
    init() {
        
    }

    init(id: UUID? = nil, userName: String, firstCardID: String?, secondCardID: String?, sharedCardIDs: [String]) {
        self.id = id
        self.userName = userName
        self.firstCardID = firstCardID
        self.secondCardID = secondCardID
        self.sharedCardIDs = sharedCardIDs
    }
}
