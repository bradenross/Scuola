// swiftlint:disable all
import Amplify
import Foundation

public struct Conversation: Model, Codable {
  public let id: String
  public var messages: List<Message>?
  public var participants: [String?]?
  public var lastMessageID: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      messages: List<Message>? = [],
      participants: [String?]? = nil,
      lastMessageID: String? = nil) {
    self.init(id: id,
      messages: messages,
      participants: participants,
      lastMessageID: lastMessageID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      messages: List<Message>? = [],
      participants: [String?]? = nil,
      lastMessageID: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.messages = messages
      self.participants = participants
      self.lastMessageID = lastMessageID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}
