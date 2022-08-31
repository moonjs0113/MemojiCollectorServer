//
//  FileController.swift
//  
//
//  Created by Moon Jongseek on 2022/08/31.
//

import Fluent
import Vapor
import Foundation



struct FileController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let file = routes.grouped("file")
        file.post(use: uploadImage)
    }
    
    
    func uploadImage(req: Request) throws -> EventLoopFuture<Response> {
        let file = try req.content.decode(File.self)
        let path = req.application.directory.publicDirectory + file.filename
        
        return req.fileio
          .writeFile(file.data, at: path)
          .transform(to: Response(status: .accepted))
    }
}
