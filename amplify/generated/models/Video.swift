// swiftlint:disable all
import Amplify
import Foundation

public struct Video: Model {
  public let id: String
  public var description: String
  public var title: String
  public var views: Int
  public var votes: Int
  public var userID: String
  public var Comments: List<Comment>?
  public var Reactions: List<Reaction>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      description: String,
      title: String,
      views: Int,
      votes: Int,
      userID: String,
      Comments: List<Comment>? = [],
      Reactions: List<Reaction>? = []) {
    self.init(id: id,
      description: description,
      title: title,
      views: views,
      votes: votes,
      userID: userID,
      Comments: Comments,
      Reactions: Reactions,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      description: String,
      title: String,
      views: Int,
      votes: Int,
      userID: String,
      Comments: List<Comment>? = [],
      Reactions: List<Reaction>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.description = description
      self.title = title
      self.views = views
      self.votes = votes
      self.userID = userID
      self.Comments = Comments
      self.Reactions = Reactions
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}