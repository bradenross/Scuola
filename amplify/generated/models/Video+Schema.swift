// swiftlint:disable all
import Amplify
import Foundation

extension Video {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case description
    case title
    case views
    case votes
    case userID
    case Comments
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let video = Video.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Videos"
    model.syncPluralName = "Videos"
    
    model.attributes(
      .index(fields: ["userID"], name: "byUser"),
      .primaryKey(fields: [video.id])
    )
    
    model.fields(
      .field(video.id, is: .required, ofType: .string),
      .field(video.description, is: .optional, ofType: .string),
      .field(video.title, is: .optional, ofType: .string),
      .field(video.views, is: .optional, ofType: .int),
      .field(video.votes, is: .optional, ofType: .int),
      .field(video.userID, is: .required, ofType: .string),
      .hasMany(video.Comments, is: .optional, ofType: Comment.self, associatedWith: Comment.keys.videoID),
      .field(video.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(video.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Video: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}