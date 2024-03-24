// swiftlint:disable all
import Amplify
import Foundation

extension User {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case bio
    case birthdate
    case live
    case picture
    case userType
    case username
    case verified
    case following
    case followers
    case savedVideos
    case FollowingUsers
    case Videos
    case Followers
    case Comments
    case UserStreamKey
    case Reactions
    case createdAt
    case updatedAt
    case userUserStreamKeyId
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let user = User.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Users"
    model.syncPluralName = "Users"
    
    model.attributes(
      .primaryKey(fields: [user.id])
    )
    
    model.fields(
      .field(user.id, is: .required, ofType: .string),
      .field(user.name, is: .required, ofType: .string),
      .field(user.bio, is: .required, ofType: .string),
      .field(user.birthdate, is: .required, ofType: .dateTime),
      .field(user.live, is: .optional, ofType: .bool),
      .field(user.picture, is: .optional, ofType: .string),
      .field(user.userType, is: .required, ofType: .string),
      .field(user.username, is: .required, ofType: .string),
      .field(user.verified, is: .required, ofType: .bool),
      .field(user.following, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(user.followers, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(user.savedVideos, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .hasMany(user.FollowingUsers, is: .optional, ofType: Following.self, associatedWith: Following.keys.userID),
      .hasMany(user.Videos, is: .optional, ofType: Following.self, associatedWith: Following.keys.userID),
      .hasMany(user.Followers, is: .optional, ofType: Follower.self, associatedWith: Follower.keys.userID),
      .hasMany(user.Comments, is: .optional, ofType: Comment.self, associatedWith: Comment.keys.userID),
      .hasOne(user.UserStreamKey, is: .optional, ofType: StreamKey.self, associatedWith: StreamKey.keys.id, targetNames: ["userUserStreamKeyId"]),
      .hasMany(user.Reactions, is: .optional, ofType: Reaction.self, associatedWith: Reaction.keys.userID),
      .field(user.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(user.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(user.userUserStreamKeyId, is: .optional, ofType: .string)
    )
    }
}

extension User: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}