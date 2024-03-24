// swiftlint:disable all
import Amplify
import Foundation

extension Reaction {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case action
    case createdAt
    case videoID
    case userID
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let reaction = Reaction.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Reactions"
    model.syncPluralName = "Reactions"
    
    model.attributes(
      .index(fields: ["videoID"], name: "byVideo"),
      .index(fields: ["userID"], name: "byUser"),
      .primaryKey(fields: [reaction.id])
    )
    
    model.fields(
      .field(reaction.id, is: .required, ofType: .string),
      .field(reaction.action, is: .optional, ofType: .enum(type: ReactionType.self)),
      .field(reaction.createdAt, is: .optional, ofType: .dateTime),
      .field(reaction.videoID, is: .required, ofType: .string),
      .field(reaction.userID, is: .required, ofType: .string),
      .field(reaction.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Reaction: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}