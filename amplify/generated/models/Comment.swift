// swiftlint:disable all
import Amplify
import Foundation

public struct Comment: Model {
  public let id: String
  public var body: String?
  public var timestamp: Temporal.DateTime?
  public var responses: [String?]?
  public var videoID: String
  public var userID: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      body: String? = nil,
      timestamp: Temporal.DateTime? = nil,
      responses: [String?]? = nil,
      videoID: String,
      userID: String) {
    self.init(id: id,
      body: body,
      timestamp: timestamp,
      responses: responses,
      videoID: videoID,
      userID: userID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      body: String? = nil,
      timestamp: Temporal.DateTime? = nil,
      responses: [String?]? = nil,
      videoID: String,
      userID: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.body = body
      self.timestamp = timestamp
      self.responses = responses
      self.videoID = videoID
      self.userID = userID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}