// swiftlint:disable all
import Amplify
import Foundation

public struct Video: Model {
  public let id: String
  public var description: String?
  public var title: String?
  public var views: Int?
  public var votes: Int?
  public var userID: String
  public var Comments: List<Comment>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      description: String? = nil,
      title: String? = nil,
      views: Int? = nil,
      votes: Int? = nil,
      userID: String,
      Comments: List<Comment>? = []) {
    self.init(id: id,
      description: description,
      title: title,
      views: views,
      votes: votes,
      userID: userID,
      Comments: Comments,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      description: String? = nil,
      title: String? = nil,
      views: Int? = nil,
      votes: Int? = nil,
      userID: String,
      Comments: List<Comment>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.description = description
      self.title = title
      self.views = views
      self.votes = votes
      self.userID = userID
      self.Comments = Comments
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}