//
//  UserMigration.swift
//  
//
//  Created by Moon Jongseek on 2022/08/09.
//

import FluentKit

struct UserMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema)
            .id()
            .field("userName", .string, .required)
            .field("firstCardID", .string)
            .field("secondCardID", .string)
            .field("sharedCardIDs", .array(of: .string), .required)
            .field("token", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema).delete()
    }
}
