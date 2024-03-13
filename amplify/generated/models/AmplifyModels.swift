// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "24962ce2cbc2a188f14595c64b012eee"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: StreamKey.self)
    ModelRegistry.register(modelType: Comment.self)
    ModelRegistry.register(modelType: Follower.self)
    ModelRegistry.register(modelType: Video.self)
    ModelRegistry.register(modelType: Following.self)
    ModelRegistry.register(modelType: User.self)
  }
}