import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    
    app.get("photo_zone_a.png") { req -> Response in
        let directoryURL = DirectoryConfiguration.detect().publicDirectory + "photoA.png"
        return req.fileio.streamFile(at: directoryURL, mediaType: .png)
    }
    
    app.get("photo_zone_b.png") { req -> Response in
        let directoryURL = DirectoryConfiguration.detect().publicDirectory + "photoB.png"
        return req.fileio.streamFile(at: directoryURL, mediaType: .png)
    }
    
    try app.register(collection: FileController())
    try app.register(collection: CardController())
}
