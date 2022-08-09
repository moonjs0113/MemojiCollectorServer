//
//  CardMigration.swift
//  
//
//  Created by Moon Jongseek on 2022/08/09.
//

import FluentKit

struct CardMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Card.schema)
            .id()
            .field("userName", .string, .required)
            .field("firstString", .string, .required)
            .field("secondString", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Card.schema).delete()
    }
}
