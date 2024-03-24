// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "3f587deacfd579f3802fcfb734b4fd5c"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Reaction.self)
    ModelRegistry.register(modelType: StreamKey.self)
    ModelRegistry.register(modelType: Comment.self)
    ModelRegistry.register(modelType: Follower.self)
    ModelRegistry.register(modelType: Video.self)
    ModelRegistry.register(modelType: Following.self)
    ModelRegistry.register(modelType: User.self)
  }
}