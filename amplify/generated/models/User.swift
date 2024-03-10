// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var name: String
  public var bio: String?
  public var birthdate: Temporal.DateTime?
  public var live: Bool?
  public var picture: String?
  public var userType: String?
  public var username: String?
  public var verified: Bool?
  public var following: [String?]?
  public var followers: [String?]?
  public var savedVideos: [String?]?
  public var FollowingUsers: List<Following>?
  public var Videos: List<Following>?
  public var Followers: List<Follower>?
  public var Comments: List<Comment>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String,
      bio: String? = nil,
      birthdate: Temporal.DateTime? = nil,
      live: Bool? = nil,
      picture: String? = nil,
      userType: String? = nil,
      username: String? = nil,
      verified: Bool? = nil,
      following: [String?]? = nil,
      followers: [String?]? = nil,
      savedVideos: [String?]? = nil,
      FollowingUsers: List<Following>? = [],
      Videos: List<Following>? = [],
      Followers: List<Follower>? = [],
      Comments: List<Comment>? = []) {
    self.init(id: id,
      name: name,
      bio: bio,
      birthdate: birthdate,
      live: live,
      picture: picture,
      userType: userType,
      username: username,
      verified: verified,
      following: following,
      followers: followers,
      savedVideos: savedVideos,
      FollowingUsers: FollowingUsers,
      Videos: Videos,
      Followers: Followers,
      Comments: Comments,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String,
      bio: String? = nil,
      birthdate: Temporal.DateTime? = nil,
      live: Bool? = nil,
      picture: String? = nil,
      userType: String? = nil,
      username: String? = nil,
      verified: Bool? = nil,
      following: [String?]? = nil,
      followers: [String?]? = nil,
      savedVideos: [String?]? = nil,
      FollowingUsers: List<Following>? = [],
      Videos: List<Following>? = [],
      Followers: List<Follower>? = [],
      Comments: List<Comment>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.bio = bio
      self.birthdate = birthdate
      self.live = live
      self.picture = picture
      self.userType = userType
      self.username = username
      self.verified = verified
      self.following = following
      self.followers = followers
      self.savedVideos = savedVideos
      self.FollowingUsers = FollowingUsers
      self.Videos = Videos
      self.Followers = Followers
      self.Comments = Comments
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}