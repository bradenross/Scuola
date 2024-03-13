// swiftlint:disable all
import Amplify
import Foundation

public struct StreamKey: Model {
  public let id: String
  public var streamKey: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      streamKey: String? = nil) {
    self.init(id: id,
      streamKey: streamKey,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      streamKey: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.streamKey = streamKey
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}