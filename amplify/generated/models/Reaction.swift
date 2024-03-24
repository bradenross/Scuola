// swiftlint:disable all
import Amplify
import Foundation

public struct Reaction: Model {
  public let id: String
  public var action: ReactionType?
  public var createdAt: Temporal.DateTime?
  public var videoID: String
  public var userID: String
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      action: ReactionType? = nil,
      createdAt: Temporal.DateTime? = nil,
      videoID: String,
      userID: String) {
    self.init(id: id,
      action: action,
      createdAt: createdAt,
      videoID: videoID,
      userID: userID,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      action: ReactionType? = nil,
      createdAt: Temporal.DateTime? = nil,
      videoID: String,
      userID: String,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.action = action
      self.createdAt = createdAt
      self.videoID = videoID
      self.userID = userID
      self.updatedAt = updatedAt
  }
}