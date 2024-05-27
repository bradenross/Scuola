// swiftlint:disable all
import Amplify
import Foundation

extension Conversation {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case messages
    case participants
    case lastMessageID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let conversation = Conversation.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Conversations"
    model.syncPluralName = "Conversations"
    
    model.attributes(
      .primaryKey(fields: [conversation.id])
    )
    
    model.fields(
      .field(conversation.id, is: .required, ofType: .string),
      .hasMany(conversation.messages, is: .optional, ofType: Message.self, associatedWith: Message.keys.conversationID),
      .field(conversation.participants, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(conversation.lastMessageID, is: .optional, ofType: .string),
      .field(conversation.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(conversation.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Conversation: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}