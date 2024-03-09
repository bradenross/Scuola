// swiftlint:disable all
import Amplify
import Foundation

extension Comment {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case body
    case timestamp
    case responses
    case videoID
    case userID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let comment = Comment.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Comments"
    model.syncPluralName = "Comments"
    
    model.attributes(
      .index(fields: ["videoID"], name: "byVideo"),
      .index(fields: ["userID"], name: "byUser"),
      .primaryKey(fields: [comment.id])
    )
    
    model.fields(
      .field(comment.id, is: .required, ofType: .string),
      .field(comment.body, is: .optional, ofType: .string),
      .field(comment.timestamp, is: .optional, ofType: .dateTime),
      .field(comment.responses, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(comment.videoID, is: .required, ofType: .string),
      .field(comment.userID, is: .required, ofType: .string),
      .field(comment.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(comment.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Comment: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}