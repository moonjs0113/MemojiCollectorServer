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
        card.get(use: readAllCard)
        card.post(use: createCard) // 카드 생성 POST
        card.group(":id") { cardID in
            cardID.delete(use: deleteMyCard) // 나의 카드 지우기 DELETE
            cardID.get(use: readSingleCard) // 카드 단일 조회 GET
        }
        
        // 공유받은 카드 추가 PATCH
        // 공유받은 카드 삭제 PATCH
        
        let user = routes.grouped("user")
        user.get(use: readAllUser)
        user.get("createUserID", ":id", use: createUserID) // User 등록하기 GET
        user.get(":id", use: readSingleUser) // User 정보 가져오기 GET
        user.delete(":id", use: deleteUser) // User 정보 지우기 DELETE
        user.patch(use: updateUserName) // User 이름 바꾸기 PATCH
    }
    
    func readAllCard(req: Request) throws -> EventLoopFuture<[Card]> {
        return Card.query(on: req.db).all()
    }
    
    func readAllUser(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }
    
    // 카드 단일 조회 GET
    func readSingleCard(req: Request) throws -> EventLoopFuture<Card> {
        guard let cardID = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "Failed Get Parameters")
        }
        
        guard let cardUUID = UUID(uuidString: cardID) else {
            throw Abort(.badRequest, reason: "Failed Convert UUID Parameters")
        }
        
        return Card.query(on: req.db)
            .filter(\.$id == cardUUID)
            .first()
            .unwrap(or: Abort(.notFound, reason: "CardID: \(cardID) Not Found"))
    }
    
    // 나의 카드 삭제 DELETE
    func deleteMyCard(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let cardDTO = try req.content.decode(CardDTO.self)
        let cardID = cardDTO.cardID ?? UUID()
        return Card.find(cardID, on: req.db)
            .map { card in
                _ = User.find(cardDTO.userID, on: req.db)
                    .map { user in
                        if (cardDTO.isRight ?? true) {
                            user?.firstCardID = nil
                        } else {
                            user?.secondCardID = nil
                        }
                        _ = user?.update(on: req.db)
                    }
                _ = card?.delete(on: req.db)
            }
            .transform(to: .ok)
    }
    
    // 공유받은 카드 삭제 PATCH
    // [] User에서만 지우기
    func deleteShardCard(req: Request) throws -> EventLoopFuture<User> {
        let userDTO = try req.content.decode(UserDTO.self)
        let userID = (userDTO.id ?? UUID())
        return User.query(on: req.db)
            .filter(\.$id == userID)
            .first()
            .unwrap(or: Abort(.notFound, reason: "UserID: \(userID) Not Found"))
    }

    // 카드 생성 POST
    func createCard(req: Request) throws -> EventLoopFuture<Card> {
        let cardDTO = try req.content.decode(CardDTO.self)
        let card = cardDTO.createCard()
        return card.create(on: req.db).map {
            _ = User.find(cardDTO.userID, on: req.db)
                .map {
                    if (cardDTO.isRight ?? true) {
                        $0?.firstCardID = card.id?.uuidString
                    } else {
                        $0?.secondCardID = card.id?.uuidString
                    }
                    _ = $0?.update(on: req.db)
                }
            return card
        }
    }
    
    // 받은 카드 추가 PATCH
    // [] User에 저장히기
    
    // User 등록하기 GET
    func createUserID(req: Request) throws -> EventLoopFuture<User> {
        guard let userName = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "Failed Get Parameters")
        }
        
        let user = User(userName: userName)
        return user.create(on: req.db)
            .map{ user }
    }
    
    // User 정보 가져오기 GET
    func readSingleUser(req: Request) throws -> EventLoopFuture<User> {
        guard let userID = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "Failed Get Parameters")
        }
        
        guard let userUUID = UUID(uuidString: userID) else {
            throw Abort(.badRequest, reason: "Failed Convert UUID Parameters")
        }
        
        return User.query(on: req.db)
            .filter(\.$id == userUUID)
            .first()
            .unwrap(or: Abort(.notFound, reason: "UserID: \(userUUID) Not Found"))
    }
    
    // User 정보 지우기 DELETE
    // [] User에서 지우기
    // [] Card 에서 지우기
    func deleteUser(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let userID = req.parameters.get("id") else {
            throw Abort(.badRequest, reason: "Failed Get Parameters")
        }
        
        guard let userUUID = UUID(uuidString: userID) else {
            throw Abort(.badRequest, reason: "Failed Convert UUID Parameters")
        }
        
        return User.query(on: req.db)
            .filter(\.$id == userUUID)
            .all()
            .mapEach {
                $0.delete(on: req.db)
            }
            .transform(to: .ok)
    }
    
    // User 이름 바꾸기 PATCH
    func updateUserName(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let userDTO = try req.content.decode(UserDTO.self)
        return User.query(on: req.db)
            .filter(\.$id == (userDTO.id ?? UUID()))
            .all()
            .mapEach {
                $0.userName = userDTO.userName ?? ""
                _ = $0.update(on: req.db)
            }
            .transform(to: .ok)
    }
}
