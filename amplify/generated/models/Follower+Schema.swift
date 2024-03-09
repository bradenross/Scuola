// swiftlint:disable all
import Amplify
import Foundation

extension Follower {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case timestamp
    case userID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let follower = Follower.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Followers"
    model.syncPluralName = "Followers"
    
    model.attributes(
      .index(fields: ["userID"], name: "byUser"),
      .primaryKey(fields: [follower.id])
    )
    
    model.fields(
      .field(follower.id, is: .required, ofType: .string),
      .field(follower.timestamp, is: .optional, ofType: .dateTime),
      .field(follower.userID, is: .required, ofType: .string),
      .field(follower.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(follower.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Follower: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}