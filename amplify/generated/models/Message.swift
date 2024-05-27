// swiftlint:disable all
import Amplify
import Foundation

public struct Message: Model {
  public let id: String
  public var content: String
  public var createdAt: Temporal.DateTime?
  public var sender: String?
  public var conversationID: String
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      content: String,
      createdAt: Temporal.DateTime? = nil,
      sender: String? = nil,
      conversationID: String) {
    self.init(id: id,
      content: content,
      createdAt: createdAt,
      sender: sender,
      conversationID: conversationID,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      content: String,
      createdAt: Temporal.DateTime? = nil,
      sender: String? = nil,
      conversationID: String,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.content = content
      self.createdAt = createdAt
      self.sender = sender
      self.conversationID = conversationID
      self.updatedAt = updatedAt
  }
}