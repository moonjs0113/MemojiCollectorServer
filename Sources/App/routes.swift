import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    
    app.get("a.png") { req -> Response in
        let directoryURL = DirectoryConfiguration.detect().publicDirectory + "a.png"
        return req.fileio.streamFile(at: directoryURL, mediaType: .png)
    }
    
    try app.register(collection: FileController())
    try app.register(collection: CardController())
}
