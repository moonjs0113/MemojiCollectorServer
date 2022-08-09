//
//  CardController.swift
//  
//
//  Created by Moon Jongseek on 2022/08/10.
//

import Fluent
import Vapor
import Foundation

struct CardController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let card = routes.grouped("card")
        card.get(use: allCard)
        card.delete(use: deleteAllCard)
    }
    
    func allCard(req: Request) throws -> EventLoopFuture<[Card]> {
        return Card.query(on: req.db).all()
    }
    
    func deleteAllCard(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Card.query(on: req.db)
            .all()
            .mapEach { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
