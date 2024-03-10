// swiftlint:disable all
import Amplify
import Foundation

extension Following {
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
    let following = Following.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Followings"
    model.syncPluralName = "Followings"
    
    model.attributes(
      .index(fields: ["userID"], name: "byUser"),
      .primaryKey(fields: [following.id])
    )
    
    model.fields(
      .field(following.id, is: .required, ofType: .string),
      .field(following.timestamp, is: .optional, ofType: .dateTime),
      .field(following.userID, is: .required, ofType: .string),
      .field(following.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(following.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Following: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}