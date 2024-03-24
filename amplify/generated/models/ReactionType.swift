// swiftlint:disable all
import Amplify
import Foundation

public enum ReactionType: String, EnumPersistable {
  case like = "LIKE"
  case dislike = "DISLIKE"
}