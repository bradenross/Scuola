// swiftlint:disable all
import Amplify
import Foundation

extension StreamKey {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case streamKey
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let streamKey = StreamKey.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "StreamKeys"
    model.syncPluralName = "StreamKeys"
    
    model.attributes(
      .primaryKey(fields: [streamKey.id])
    )
    
    model.fields(
      .field(streamKey.id, is: .required, ofType: .string),
      .field(streamKey.streamKey, is: .optional, ofType: .string),
      .field(streamKey.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(streamKey.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension StreamKey: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}