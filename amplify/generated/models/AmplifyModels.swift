// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "16f3628ea535c7e30b1293969b7d2f56"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Comment.self)
    ModelRegistry.register(modelType: Follower.self)
    ModelRegistry.register(modelType: Video.self)
    ModelRegistry.register(modelType: Following.self)
    ModelRegistry.register(modelType: User.self)
  }
}