// swiftlint:disable all
import Amplify
import Foundation

public struct Following: Model {
  public let id: String
  public var timestamp: Temporal.DateTime?
  public var userID: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      timestamp: Temporal.DateTime? = nil,
      userID: String) {
    self.init(id: id,
      timestamp: timestamp,
      userID: userID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      timestamp: Temporal.DateTime? = nil,
      userID: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.timestamp = timestamp
      self.userID = userID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}