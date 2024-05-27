// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "606e6132e8958992d46d9973acd9acb3"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Conversation.self)
    ModelRegistry.register(modelType: Message.self)
    ModelRegistry.register(modelType: Reaction.self)
    ModelRegistry.register(modelType: StreamKey.self)
    ModelRegistry.register(modelType: Comment.self)
    ModelRegistry.register(modelType: Follower.self)
    ModelRegistry.register(modelType: Video.self)
    ModelRegistry.register(modelType: Following.self)
    ModelRegistry.register(modelType: User.self)
  }
}