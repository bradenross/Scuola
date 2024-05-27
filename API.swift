//  This file was automatically generated and should not be edited.

#if canImport(AWSAPIPlugin)
import Foundation

public protocol GraphQLInputValue {
}

public struct GraphQLVariable {
  let name: String
  
  public init(_ name: String) {
    self.name = name
  }
}

extension GraphQLVariable: GraphQLInputValue {
}

extension JSONEncodable {
  public func evaluate(with variables: [String: JSONEncodable]?) throws -> Any {
    return jsonValue
  }
}

public typealias GraphQLMap = [String: JSONEncodable?]

extension Dictionary where Key == String, Value == JSONEncodable? {
  public var withNilValuesRemoved: Dictionary<String, JSONEncodable> {
    var filtered = Dictionary<String, JSONEncodable>(minimumCapacity: count)
    for (key, value) in self {
      if value != nil {
        filtered[key] = value
      }
    }
    return filtered
  }
}

public protocol GraphQLMapConvertible: JSONEncodable {
  var graphQLMap: GraphQLMap { get }
}

public extension GraphQLMapConvertible {
  var jsonValue: Any {
    return graphQLMap.withNilValuesRemoved.jsonValue
  }
}

public typealias GraphQLID = String

public protocol APISwiftGraphQLOperation: AnyObject {
  
  static var operationString: String { get }
  static var requestString: String { get }
  static var operationIdentifier: String? { get }
  
  var variables: GraphQLMap? { get }
  
  associatedtype Data: GraphQLSelectionSet
}

public extension APISwiftGraphQLOperation {
  static var requestString: String {
    return operationString
  }

  static var operationIdentifier: String? {
    return nil
  }

  var variables: GraphQLMap? {
    return nil
  }
}

public protocol GraphQLQuery: APISwiftGraphQLOperation {}

public protocol GraphQLMutation: APISwiftGraphQLOperation {}

public protocol GraphQLSubscription: APISwiftGraphQLOperation {}

public protocol GraphQLFragment: GraphQLSelectionSet {
  static var possibleTypes: [String] { get }
}

public typealias Snapshot = [String: Any?]

public protocol GraphQLSelectionSet: Decodable {
  static var selections: [GraphQLSelection] { get }
  
  var snapshot: Snapshot { get }
  init(snapshot: Snapshot)
}

extension GraphQLSelectionSet {
    public init(from decoder: Decoder) throws {
        if let jsonObject = try? APISwiftJSONValue(from: decoder) {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(jsonObject)
            let decodedDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            let optionalDictionary = decodedDictionary.mapValues { $0 as Any? }

            self.init(snapshot: optionalDictionary)
        } else {
            self.init(snapshot: [:])
        }
    }
}

enum APISwiftJSONValue: Codable {
    case array([APISwiftJSONValue])
    case boolean(Bool)
    case number(Double)
    case object([String: APISwiftJSONValue])
    case string(String)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode([String: APISwiftJSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([APISwiftJSONValue].self) {
            self = .array(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .boolean(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else {
            self = .null
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .array(let value):
            try container.encode(value)
        case .boolean(let value):
            try container.encode(value)
        case .number(let value):
            try container.encode(value)
        case .object(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .null:
            try container.encodeNil()
        }
    }
}

public protocol GraphQLSelection {
}

public struct GraphQLField: GraphQLSelection {
  let name: String
  let alias: String?
  let arguments: [String: GraphQLInputValue]?
  
  var responseKey: String {
    return alias ?? name
  }
  
  let type: GraphQLOutputType
  
  public init(_ name: String, alias: String? = nil, arguments: [String: GraphQLInputValue]? = nil, type: GraphQLOutputType) {
    self.name = name
    self.alias = alias
    
    self.arguments = arguments
    
    self.type = type
  }
}

public indirect enum GraphQLOutputType {
  case scalar(JSONDecodable.Type)
  case object([GraphQLSelection])
  case nonNull(GraphQLOutputType)
  case list(GraphQLOutputType)
  
  var namedType: GraphQLOutputType {
    switch self {
    case .nonNull(let innerType), .list(let innerType):
      return innerType.namedType
    case .scalar, .object:
      return self
    }
  }
}

public struct GraphQLBooleanCondition: GraphQLSelection {
  let variableName: String
  let inverted: Bool
  let selections: [GraphQLSelection]
  
  public init(variableName: String, inverted: Bool, selections: [GraphQLSelection]) {
    self.variableName = variableName
    self.inverted = inverted;
    self.selections = selections;
  }
}

public struct GraphQLTypeCondition: GraphQLSelection {
  let possibleTypes: [String]
  let selections: [GraphQLSelection]
  
  public init(possibleTypes: [String], selections: [GraphQLSelection]) {
    self.possibleTypes = possibleTypes
    self.selections = selections;
  }
}

public struct GraphQLFragmentSpread: GraphQLSelection {
  let fragment: GraphQLFragment.Type
  
  public init(_ fragment: GraphQLFragment.Type) {
    self.fragment = fragment
  }
}

public struct GraphQLTypeCase: GraphQLSelection {
  let variants: [String: [GraphQLSelection]]
  let `default`: [GraphQLSelection]
  
  public init(variants: [String: [GraphQLSelection]], default: [GraphQLSelection]) {
    self.variants = variants
    self.default = `default`;
  }
}

public typealias JSONObject = [String: Any]

public protocol JSONDecodable {
  init(jsonValue value: Any) throws
}

public protocol JSONEncodable: GraphQLInputValue {
  var jsonValue: Any { get }
}

public enum JSONDecodingError: Error, LocalizedError {
  case missingValue
  case nullValue
  case wrongType
  case couldNotConvert(value: Any, to: Any.Type)
  
  public var errorDescription: String? {
    switch self {
    case .missingValue:
      return "Missing value"
    case .nullValue:
      return "Unexpected null value"
    case .wrongType:
      return "Wrong type"
    case .couldNotConvert(let value, let expectedType):
      return "Could not convert \"\(value)\" to \(expectedType)"
    }
  }
}

extension String: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: String.self)
    }
    self = string
  }

  public var jsonValue: Any {
    return self
  }
}

extension Int: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Int.self)
    }
    self = number.intValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Float: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Float.self)
    }
    self = number.floatValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Double: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let number = value as? NSNumber else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Double.self)
    }
    self = number.doubleValue
  }

  public var jsonValue: Any {
    return self
  }
}

extension Bool: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let bool = value as? Bool else {
        throw JSONDecodingError.couldNotConvert(value: value, to: Bool.self)
    }
    self = bool
  }

  public var jsonValue: Any {
    return self
  }
}

extension RawRepresentable where RawValue: JSONDecodable {
  public init(jsonValue value: Any) throws {
    let rawValue = try RawValue(jsonValue: value)
    if let tempSelf = Self(rawValue: rawValue) {
      self = tempSelf
    } else {
      throw JSONDecodingError.couldNotConvert(value: value, to: Self.self)
    }
  }
}

extension RawRepresentable where RawValue: JSONEncodable {
  public var jsonValue: Any {
    return rawValue.jsonValue
  }
}

extension Optional where Wrapped: JSONDecodable {
  public init(jsonValue value: Any) throws {
    if value is NSNull {
      self = .none
    } else {
      self = .some(try Wrapped(jsonValue: value))
    }
  }
}

extension Optional: JSONEncodable {
  public var jsonValue: Any {
    switch self {
    case .none:
      return NSNull()
    case .some(let wrapped as JSONEncodable):
      return wrapped.jsonValue
    default:
      fatalError("Optional is only JSONEncodable if Wrapped is")
    }
  }
}

extension Dictionary: JSONEncodable {
  public var jsonValue: Any {
    return jsonObject
  }
  
  public var jsonObject: JSONObject {
    var jsonObject = JSONObject(minimumCapacity: count)
    for (key, value) in self {
      if case let (key as String, value as JSONEncodable) = (key, value) {
        jsonObject[key] = value.jsonValue
      } else {
        fatalError("Dictionary is only JSONEncodable if Value is (and if Key is String)")
      }
    }
    return jsonObject
  }
}

extension Array: JSONEncodable {
  public var jsonValue: Any {
    return map() { element -> (Any) in
      if case let element as JSONEncodable = element {
        return element.jsonValue
      } else {
        fatalError("Array is only JSONEncodable if Element is")
      }
    }
  }
}

extension URL: JSONDecodable, JSONEncodable {
  public init(jsonValue value: Any) throws {
    guard let string = value as? String else {
      throw JSONDecodingError.couldNotConvert(value: value, to: URL.self)
    }
    self.init(string: string)!
  }

  public var jsonValue: Any {
    return self.absoluteString
  }
}

extension Dictionary {
  static func += (lhs: inout Dictionary, rhs: Dictionary) {
    lhs.merge(rhs) { (_, new) in new }
  }
}

#elseif canImport(AWSAppSync)
import AWSAppSync
#endif

public struct CreateConversationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, participants: [String?]? = nil, lastMessageId: String? = nil) {
    graphQLMap = ["id": id, "participants": participants, "lastMessageID": lastMessageId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var participants: [String?]? {
    get {
      return graphQLMap["participants"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "participants")
    }
  }

  public var lastMessageId: String? {
    get {
      return graphQLMap["lastMessageID"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastMessageID")
    }
  }
}

public struct ModelConversationConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(participants: ModelStringInput? = nil, lastMessageId: ModelStringInput? = nil, and: [ModelConversationConditionInput?]? = nil, or: [ModelConversationConditionInput?]? = nil, not: ModelConversationConditionInput? = nil) {
    graphQLMap = ["participants": participants, "lastMessageID": lastMessageId, "and": and, "or": or, "not": not]
  }

  public var participants: ModelStringInput? {
    get {
      return graphQLMap["participants"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "participants")
    }
  }

  public var lastMessageId: ModelStringInput? {
    get {
      return graphQLMap["lastMessageID"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastMessageID")
    }
  }

  public var and: [ModelConversationConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelConversationConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelConversationConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelConversationConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelConversationConditionInput? {
    get {
      return graphQLMap["not"] as! ModelConversationConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public enum ModelAttributeTypes: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case binary
  case binarySet
  case bool
  case list
  case map
  case number
  case numberSet
  case string
  case stringSet
  case null
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "binary": self = .binary
      case "binarySet": self = .binarySet
      case "bool": self = .bool
      case "list": self = .list
      case "map": self = .map
      case "number": self = .number
      case "numberSet": self = .numberSet
      case "string": self = .string
      case "stringSet": self = .stringSet
      case "_null": self = .null
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .binary: return "binary"
      case .binarySet: return "binarySet"
      case .bool: return "bool"
      case .list: return "list"
      case .map: return "map"
      case .number: return "number"
      case .numberSet: return "numberSet"
      case .string: return "string"
      case .stringSet: return "stringSet"
      case .null: return "_null"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelAttributeTypes, rhs: ModelAttributeTypes) -> Bool {
    switch (lhs, rhs) {
      case (.binary, .binary): return true
      case (.binarySet, .binarySet): return true
      case (.bool, .bool): return true
      case (.list, .list): return true
      case (.map, .map): return true
      case (.number, .number): return true
      case (.numberSet, .numberSet): return true
      case (.string, .string): return true
      case (.stringSet, .stringSet): return true
      case (.null, .null): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelSizeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }
}

public struct UpdateConversationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, participants: [String?]? = nil, lastMessageId: String? = nil) {
    graphQLMap = ["id": id, "participants": participants, "lastMessageID": lastMessageId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var participants: [String?]? {
    get {
      return graphQLMap["participants"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "participants")
    }
  }

  public var lastMessageId: String? {
    get {
      return graphQLMap["lastMessageID"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastMessageID")
    }
  }
}

public struct DeleteConversationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateMessageInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, content: String, createdAt: String? = nil, sender: String? = nil, conversationId: GraphQLID) {
    graphQLMap = ["id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: String {
    get {
      return graphQLMap["content"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var sender: String? {
    get {
      return graphQLMap["sender"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  public var conversationId: GraphQLID {
    get {
      return graphQLMap["conversationID"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "conversationID")
    }
  }
}

public struct ModelMessageConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(content: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, sender: ModelStringInput? = nil, conversationId: ModelIDInput? = nil, and: [ModelMessageConditionInput?]? = nil, or: [ModelMessageConditionInput?]? = nil, not: ModelMessageConditionInput? = nil) {
    graphQLMap = ["content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "and": and, "or": or, "not": not]
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var sender: ModelStringInput? {
    get {
      return graphQLMap["sender"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  public var conversationId: ModelIDInput? {
    get {
      return graphQLMap["conversationID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "conversationID")
    }
  }

  public var and: [ModelMessageConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelMessageConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelMessageConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelMessageConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelMessageConditionInput? {
    get {
      return graphQLMap["not"] as! ModelMessageConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil, size: ModelSizeInput? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "attributeExists": attributeExists, "attributeType": attributeType, "size": size]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }

  public var size: ModelSizeInput? {
    get {
      return graphQLMap["size"] as! ModelSizeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "size")
    }
  }
}

public struct UpdateMessageInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, content: String? = nil, createdAt: String? = nil, sender: String? = nil, conversationId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: String? {
    get {
      return graphQLMap["content"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var sender: String? {
    get {
      return graphQLMap["sender"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  public var conversationId: GraphQLID? {
    get {
      return graphQLMap["conversationID"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "conversationID")
    }
  }
}

public struct DeleteMessageInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateReactionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID, userId: GraphQLID) {
    graphQLMap = ["id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var action: ReactionType? {
    get {
      return graphQLMap["action"] as! ReactionType?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "action")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var videoId: GraphQLID {
    get {
      return graphQLMap["videoID"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoID")
    }
  }

  public var userId: GraphQLID {
    get {
      return graphQLMap["userID"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }
}

public enum ReactionType: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case like
  case dislike
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "LIKE": self = .like
      case "DISLIKE": self = .dislike
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .like: return "LIKE"
      case .dislike: return "DISLIKE"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ReactionType, rhs: ReactionType) -> Bool {
    switch (lhs, rhs) {
      case (.like, .like): return true
      case (.dislike, .dislike): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelReactionConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(action: ModelReactionTypeInput? = nil, createdAt: ModelStringInput? = nil, videoId: ModelIDInput? = nil, userId: ModelIDInput? = nil, and: [ModelReactionConditionInput?]? = nil, or: [ModelReactionConditionInput?]? = nil, not: ModelReactionConditionInput? = nil) {
    graphQLMap = ["action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "and": and, "or": or, "not": not]
  }

  public var action: ModelReactionTypeInput? {
    get {
      return graphQLMap["action"] as! ModelReactionTypeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "action")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var videoId: ModelIDInput? {
    get {
      return graphQLMap["videoID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoID")
    }
  }

  public var userId: ModelIDInput? {
    get {
      return graphQLMap["userID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelReactionConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelReactionConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelReactionConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelReactionConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelReactionConditionInput? {
    get {
      return graphQLMap["not"] as! ModelReactionConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelReactionTypeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: ReactionType? = nil, ne: ReactionType? = nil) {
    graphQLMap = ["eq": eq, "ne": ne]
  }

  public var eq: ReactionType? {
    get {
      return graphQLMap["eq"] as! ReactionType?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var ne: ReactionType? {
    get {
      return graphQLMap["ne"] as! ReactionType?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }
}

public struct UpdateReactionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID? = nil, userId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var action: ReactionType? {
    get {
      return graphQLMap["action"] as! ReactionType?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "action")
    }
  }

  public var createdAt: String? {
    get {
      return graphQLMap["createdAt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var videoId: GraphQLID? {
    get {
      return graphQLMap["videoID"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoID")
    }
  }

  public var userId: GraphQLID? {
    get {
      return graphQLMap["userID"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }
}

public struct DeleteReactionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateStreamKeyInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, streamKey: String? = nil) {
    graphQLMap = ["id": id, "streamKey": streamKey]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var streamKey: String? {
    get {
      return graphQLMap["streamKey"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "streamKey")
    }
  }
}

public struct ModelStreamKeyConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(streamKey: ModelStringInput? = nil, and: [ModelStreamKeyConditionInput?]? = nil, or: [ModelStreamKeyConditionInput?]? = nil, not: ModelStreamKeyConditionInput? = nil) {
    graphQLMap = ["streamKey": streamKey, "and": and, "or": or, "not": not]
  }

  public var streamKey: ModelStringInput? {
    get {
      return graphQLMap["streamKey"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "streamKey")
    }
  }

  public var and: [ModelStreamKeyConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelStreamKeyConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelStreamKeyConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelStreamKeyConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelStreamKeyConditionInput? {
    get {
      return graphQLMap["not"] as! ModelStreamKeyConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateStreamKeyInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, streamKey: String? = nil) {
    graphQLMap = ["id": id, "streamKey": streamKey]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var streamKey: String? {
    get {
      return graphQLMap["streamKey"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "streamKey")
    }
  }
}

public struct DeleteStreamKeyInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateCommentInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID, userId: GraphQLID) {
    graphQLMap = ["id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var body: String? {
    get {
      return graphQLMap["body"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "body")
    }
  }

  public var timestamp: String? {
    get {
      return graphQLMap["timestamp"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var responses: [String?]? {
    get {
      return graphQLMap["responses"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "responses")
    }
  }

  public var videoId: GraphQLID {
    get {
      return graphQLMap["videoID"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoID")
    }
  }

  public var userId: GraphQLID {
    get {
      return graphQLMap["userID"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }
}

public struct ModelCommentConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(body: ModelStringInput? = nil, timestamp: ModelStringInput? = nil, responses: ModelStringInput? = nil, videoId: ModelIDInput? = nil, userId: ModelIDInput? = nil, and: [ModelCommentConditionInput?]? = nil, or: [ModelCommentConditionInput?]? = nil, not: ModelCommentConditionInput? = nil) {
    graphQLMap = ["body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "and": and, "or": or, "not": not]
  }

  public var body: ModelStringInput? {
    get {
      return graphQLMap["body"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "body")
    }
  }

  public var timestamp: ModelStringInput? {
    get {
      return graphQLMap["timestamp"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var responses: ModelStringInput? {
    get {
      return graphQLMap["responses"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "responses")
    }
  }

  public var videoId: ModelIDInput? {
    get {
      return graphQLMap["videoID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoID")
    }
  }

  public var userId: ModelIDInput? {
    get {
      return graphQLMap["userID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelCommentConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelCommentConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelCommentConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelCommentConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelCommentConditionInput? {
    get {
      return graphQLMap["not"] as! ModelCommentConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateCommentInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID? = nil, userId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var body: String? {
    get {
      return graphQLMap["body"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "body")
    }
  }

  public var timestamp: String? {
    get {
      return graphQLMap["timestamp"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var responses: [String?]? {
    get {
      return graphQLMap["responses"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "responses")
    }
  }

  public var videoId: GraphQLID? {
    get {
      return graphQLMap["videoID"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoID")
    }
  }

  public var userId: GraphQLID? {
    get {
      return graphQLMap["userID"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }
}

public struct DeleteCommentInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateFollowerInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, timestamp: String? = nil, userId: GraphQLID) {
    graphQLMap = ["id": id, "timestamp": timestamp, "userID": userId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var timestamp: String? {
    get {
      return graphQLMap["timestamp"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var userId: GraphQLID {
    get {
      return graphQLMap["userID"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }
}

public struct ModelFollowerConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(timestamp: ModelStringInput? = nil, userId: ModelIDInput? = nil, and: [ModelFollowerConditionInput?]? = nil, or: [ModelFollowerConditionInput?]? = nil, not: ModelFollowerConditionInput? = nil) {
    graphQLMap = ["timestamp": timestamp, "userID": userId, "and": and, "or": or, "not": not]
  }

  public var timestamp: ModelStringInput? {
    get {
      return graphQLMap["timestamp"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var userId: ModelIDInput? {
    get {
      return graphQLMap["userID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelFollowerConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelFollowerConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelFollowerConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelFollowerConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelFollowerConditionInput? {
    get {
      return graphQLMap["not"] as! ModelFollowerConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateFollowerInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "timestamp": timestamp, "userID": userId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var timestamp: String? {
    get {
      return graphQLMap["timestamp"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var userId: GraphQLID? {
    get {
      return graphQLMap["userID"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }
}

public struct DeleteFollowerInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateVideoInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, description: String, title: String, views: Int, votes: Int, userId: GraphQLID) {
    graphQLMap = ["id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var description: String {
    get {
      return graphQLMap["description"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var title: String {
    get {
      return graphQLMap["title"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var views: Int {
    get {
      return graphQLMap["views"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "views")
    }
  }

  public var votes: Int {
    get {
      return graphQLMap["votes"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "votes")
    }
  }

  public var userId: GraphQLID {
    get {
      return graphQLMap["userID"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }
}

public struct ModelVideoConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(description: ModelStringInput? = nil, title: ModelStringInput? = nil, views: ModelIntInput? = nil, votes: ModelIntInput? = nil, userId: ModelIDInput? = nil, and: [ModelVideoConditionInput?]? = nil, or: [ModelVideoConditionInput?]? = nil, not: ModelVideoConditionInput? = nil) {
    graphQLMap = ["description": description, "title": title, "views": views, "votes": votes, "userID": userId, "and": and, "or": or, "not": not]
  }

  public var description: ModelStringInput? {
    get {
      return graphQLMap["description"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var title: ModelStringInput? {
    get {
      return graphQLMap["title"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var views: ModelIntInput? {
    get {
      return graphQLMap["views"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "views")
    }
  }

  public var votes: ModelIntInput? {
    get {
      return graphQLMap["votes"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "votes")
    }
  }

  public var userId: ModelIDInput? {
    get {
      return graphQLMap["userID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelVideoConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelVideoConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelVideoConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelVideoConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelVideoConditionInput? {
    get {
      return graphQLMap["not"] as! ModelVideoConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelIntInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "attributeExists": attributeExists, "attributeType": attributeType]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }
}

public struct UpdateVideoInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, description: String? = nil, title: String? = nil, views: Int? = nil, votes: Int? = nil, userId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var description: String? {
    get {
      return graphQLMap["description"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var title: String? {
    get {
      return graphQLMap["title"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var views: Int? {
    get {
      return graphQLMap["views"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "views")
    }
  }

  public var votes: Int? {
    get {
      return graphQLMap["votes"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "votes")
    }
  }

  public var userId: GraphQLID? {
    get {
      return graphQLMap["userID"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }
}

public struct DeleteVideoInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateFollowingInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, timestamp: String? = nil, userId: GraphQLID) {
    graphQLMap = ["id": id, "timestamp": timestamp, "userID": userId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var timestamp: String? {
    get {
      return graphQLMap["timestamp"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var userId: GraphQLID {
    get {
      return graphQLMap["userID"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }
}

public struct ModelFollowingConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(timestamp: ModelStringInput? = nil, userId: ModelIDInput? = nil, and: [ModelFollowingConditionInput?]? = nil, or: [ModelFollowingConditionInput?]? = nil, not: ModelFollowingConditionInput? = nil) {
    graphQLMap = ["timestamp": timestamp, "userID": userId, "and": and, "or": or, "not": not]
  }

  public var timestamp: ModelStringInput? {
    get {
      return graphQLMap["timestamp"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var userId: ModelIDInput? {
    get {
      return graphQLMap["userID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelFollowingConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelFollowingConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelFollowingConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelFollowingConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelFollowingConditionInput? {
    get {
      return graphQLMap["not"] as! ModelFollowingConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct UpdateFollowingInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "timestamp": timestamp, "userID": userId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var timestamp: String? {
    get {
      return graphQLMap["timestamp"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var userId: GraphQLID? {
    get {
      return graphQLMap["userID"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }
}

public struct DeleteFollowingInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct CreateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID? = nil, name: String, bio: String, birthdate: String, live: Bool? = nil, picture: String? = nil, userType: String, username: String, verified: Bool, following: [String?]? = nil, followers: [String?]? = nil, savedVideos: [String?]? = nil, bioLink: String? = nil, userUserStreamKeyId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "bioLink": bioLink, "userUserStreamKeyId": userUserStreamKeyId]
  }

  public var id: GraphQLID? {
    get {
      return graphQLMap["id"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var bio: String {
    get {
      return graphQLMap["bio"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bio")
    }
  }

  public var birthdate: String {
    get {
      return graphQLMap["birthdate"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "birthdate")
    }
  }

  public var live: Bool? {
    get {
      return graphQLMap["live"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "live")
    }
  }

  public var picture: String? {
    get {
      return graphQLMap["picture"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "picture")
    }
  }

  public var userType: String {
    get {
      return graphQLMap["userType"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userType")
    }
  }

  public var username: String {
    get {
      return graphQLMap["username"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var verified: Bool {
    get {
      return graphQLMap["verified"] as! Bool
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "verified")
    }
  }

  public var following: [String?]? {
    get {
      return graphQLMap["following"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "following")
    }
  }

  public var followers: [String?]? {
    get {
      return graphQLMap["followers"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "followers")
    }
  }

  public var savedVideos: [String?]? {
    get {
      return graphQLMap["savedVideos"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "savedVideos")
    }
  }

  public var bioLink: String? {
    get {
      return graphQLMap["bioLink"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bioLink")
    }
  }

  public var userUserStreamKeyId: GraphQLID? {
    get {
      return graphQLMap["userUserStreamKeyId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userUserStreamKeyId")
    }
  }
}

public struct ModelUserConditionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: ModelStringInput? = nil, bio: ModelStringInput? = nil, birthdate: ModelStringInput? = nil, live: ModelBooleanInput? = nil, picture: ModelStringInput? = nil, userType: ModelStringInput? = nil, username: ModelStringInput? = nil, verified: ModelBooleanInput? = nil, following: ModelStringInput? = nil, followers: ModelStringInput? = nil, savedVideos: ModelStringInput? = nil, bioLink: ModelStringInput? = nil, and: [ModelUserConditionInput?]? = nil, or: [ModelUserConditionInput?]? = nil, not: ModelUserConditionInput? = nil, userUserStreamKeyId: ModelIDInput? = nil) {
    graphQLMap = ["name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "bioLink": bioLink, "and": and, "or": or, "not": not, "userUserStreamKeyId": userUserStreamKeyId]
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var bio: ModelStringInput? {
    get {
      return graphQLMap["bio"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bio")
    }
  }

  public var birthdate: ModelStringInput? {
    get {
      return graphQLMap["birthdate"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "birthdate")
    }
  }

  public var live: ModelBooleanInput? {
    get {
      return graphQLMap["live"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "live")
    }
  }

  public var picture: ModelStringInput? {
    get {
      return graphQLMap["picture"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "picture")
    }
  }

  public var userType: ModelStringInput? {
    get {
      return graphQLMap["userType"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userType")
    }
  }

  public var username: ModelStringInput? {
    get {
      return graphQLMap["username"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var verified: ModelBooleanInput? {
    get {
      return graphQLMap["verified"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "verified")
    }
  }

  public var following: ModelStringInput? {
    get {
      return graphQLMap["following"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "following")
    }
  }

  public var followers: ModelStringInput? {
    get {
      return graphQLMap["followers"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "followers")
    }
  }

  public var savedVideos: ModelStringInput? {
    get {
      return graphQLMap["savedVideos"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "savedVideos")
    }
  }

  public var bioLink: ModelStringInput? {
    get {
      return graphQLMap["bioLink"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bioLink")
    }
  }

  public var and: [ModelUserConditionInput?]? {
    get {
      return graphQLMap["and"] as! [ModelUserConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelUserConditionInput?]? {
    get {
      return graphQLMap["or"] as! [ModelUserConditionInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelUserConditionInput? {
    get {
      return graphQLMap["not"] as! ModelUserConditionInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var userUserStreamKeyId: ModelIDInput? {
    get {
      return graphQLMap["userUserStreamKeyId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userUserStreamKeyId")
    }
  }
}

public struct ModelBooleanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Bool? = nil, eq: Bool? = nil, attributeExists: Bool? = nil, attributeType: ModelAttributeTypes? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "attributeExists": attributeExists, "attributeType": attributeType]
  }

  public var ne: Bool? {
    get {
      return graphQLMap["ne"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Bool? {
    get {
      return graphQLMap["eq"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var attributeExists: Bool? {
    get {
      return graphQLMap["attributeExists"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeExists")
    }
  }

  public var attributeType: ModelAttributeTypes? {
    get {
      return graphQLMap["attributeType"] as! ModelAttributeTypes?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "attributeType")
    }
  }
}

public struct UpdateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, name: String? = nil, bio: String? = nil, birthdate: String? = nil, live: Bool? = nil, picture: String? = nil, userType: String? = nil, username: String? = nil, verified: Bool? = nil, following: [String?]? = nil, followers: [String?]? = nil, savedVideos: [String?]? = nil, bioLink: String? = nil, userUserStreamKeyId: GraphQLID? = nil) {
    graphQLMap = ["id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "bioLink": bioLink, "userUserStreamKeyId": userUserStreamKeyId]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: String? {
    get {
      return graphQLMap["name"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var bio: String? {
    get {
      return graphQLMap["bio"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bio")
    }
  }

  public var birthdate: String? {
    get {
      return graphQLMap["birthdate"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "birthdate")
    }
  }

  public var live: Bool? {
    get {
      return graphQLMap["live"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "live")
    }
  }

  public var picture: String? {
    get {
      return graphQLMap["picture"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "picture")
    }
  }

  public var userType: String? {
    get {
      return graphQLMap["userType"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userType")
    }
  }

  public var username: String? {
    get {
      return graphQLMap["username"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var verified: Bool? {
    get {
      return graphQLMap["verified"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "verified")
    }
  }

  public var following: [String?]? {
    get {
      return graphQLMap["following"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "following")
    }
  }

  public var followers: [String?]? {
    get {
      return graphQLMap["followers"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "followers")
    }
  }

  public var savedVideos: [String?]? {
    get {
      return graphQLMap["savedVideos"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "savedVideos")
    }
  }

  public var bioLink: String? {
    get {
      return graphQLMap["bioLink"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bioLink")
    }
  }

  public var userUserStreamKeyId: GraphQLID? {
    get {
      return graphQLMap["userUserStreamKeyId"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userUserStreamKeyId")
    }
  }
}

public struct DeleteUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID) {
    graphQLMap = ["id": id]
  }

  public var id: GraphQLID {
    get {
      return graphQLMap["id"] as! GraphQLID
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }
}

public struct ModelConversationFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, participants: ModelStringInput? = nil, lastMessageId: ModelStringInput? = nil, and: [ModelConversationFilterInput?]? = nil, or: [ModelConversationFilterInput?]? = nil, not: ModelConversationFilterInput? = nil) {
    graphQLMap = ["id": id, "participants": participants, "lastMessageID": lastMessageId, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var participants: ModelStringInput? {
    get {
      return graphQLMap["participants"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "participants")
    }
  }

  public var lastMessageId: ModelStringInput? {
    get {
      return graphQLMap["lastMessageID"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastMessageID")
    }
  }

  public var and: [ModelConversationFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelConversationFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelConversationFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelConversationFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelConversationFilterInput? {
    get {
      return graphQLMap["not"] as! ModelConversationFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelMessageFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, content: ModelStringInput? = nil, createdAt: ModelStringInput? = nil, sender: ModelStringInput? = nil, conversationId: ModelIDInput? = nil, and: [ModelMessageFilterInput?]? = nil, or: [ModelMessageFilterInput?]? = nil, not: ModelMessageFilterInput? = nil) {
    graphQLMap = ["id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: ModelStringInput? {
    get {
      return graphQLMap["content"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var sender: ModelStringInput? {
    get {
      return graphQLMap["sender"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  public var conversationId: ModelIDInput? {
    get {
      return graphQLMap["conversationID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "conversationID")
    }
  }

  public var and: [ModelMessageFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelMessageFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelMessageFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelMessageFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelMessageFilterInput? {
    get {
      return graphQLMap["not"] as! ModelMessageFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public enum ModelSortDirection: RawRepresentable, Equatable, JSONDecodable, JSONEncodable {
  public typealias RawValue = String
  case asc
  case desc
  /// Auto generated constant for unknown enum values
  case unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ASC": self = .asc
      case "DESC": self = .desc
      default: self = .unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .asc: return "ASC"
      case .desc: return "DESC"
      case .unknown(let value): return value
    }
  }

  public static func == (lhs: ModelSortDirection, rhs: ModelSortDirection) -> Bool {
    switch (lhs, rhs) {
      case (.asc, .asc): return true
      case (.desc, .desc): return true
      case (.unknown(let lhsValue), .unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public struct ModelReactionFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, action: ModelReactionTypeInput? = nil, createdAt: ModelStringInput? = nil, videoId: ModelIDInput? = nil, userId: ModelIDInput? = nil, and: [ModelReactionFilterInput?]? = nil, or: [ModelReactionFilterInput?]? = nil, not: ModelReactionFilterInput? = nil) {
    graphQLMap = ["id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var action: ModelReactionTypeInput? {
    get {
      return graphQLMap["action"] as! ModelReactionTypeInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "action")
    }
  }

  public var createdAt: ModelStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var videoId: ModelIDInput? {
    get {
      return graphQLMap["videoID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoID")
    }
  }

  public var userId: ModelIDInput? {
    get {
      return graphQLMap["userID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelReactionFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelReactionFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelReactionFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelReactionFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelReactionFilterInput? {
    get {
      return graphQLMap["not"] as! ModelReactionFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelStreamKeyFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, streamKey: ModelStringInput? = nil, and: [ModelStreamKeyFilterInput?]? = nil, or: [ModelStreamKeyFilterInput?]? = nil, not: ModelStreamKeyFilterInput? = nil) {
    graphQLMap = ["id": id, "streamKey": streamKey, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var streamKey: ModelStringInput? {
    get {
      return graphQLMap["streamKey"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "streamKey")
    }
  }

  public var and: [ModelStreamKeyFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelStreamKeyFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelStreamKeyFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelStreamKeyFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelStreamKeyFilterInput? {
    get {
      return graphQLMap["not"] as! ModelStreamKeyFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelCommentFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, body: ModelStringInput? = nil, timestamp: ModelStringInput? = nil, responses: ModelStringInput? = nil, videoId: ModelIDInput? = nil, userId: ModelIDInput? = nil, and: [ModelCommentFilterInput?]? = nil, or: [ModelCommentFilterInput?]? = nil, not: ModelCommentFilterInput? = nil) {
    graphQLMap = ["id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var body: ModelStringInput? {
    get {
      return graphQLMap["body"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "body")
    }
  }

  public var timestamp: ModelStringInput? {
    get {
      return graphQLMap["timestamp"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var responses: ModelStringInput? {
    get {
      return graphQLMap["responses"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "responses")
    }
  }

  public var videoId: ModelIDInput? {
    get {
      return graphQLMap["videoID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoID")
    }
  }

  public var userId: ModelIDInput? {
    get {
      return graphQLMap["userID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelCommentFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelCommentFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelCommentFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelCommentFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelCommentFilterInput? {
    get {
      return graphQLMap["not"] as! ModelCommentFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelFollowerFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, timestamp: ModelStringInput? = nil, userId: ModelIDInput? = nil, and: [ModelFollowerFilterInput?]? = nil, or: [ModelFollowerFilterInput?]? = nil, not: ModelFollowerFilterInput? = nil) {
    graphQLMap = ["id": id, "timestamp": timestamp, "userID": userId, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var timestamp: ModelStringInput? {
    get {
      return graphQLMap["timestamp"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var userId: ModelIDInput? {
    get {
      return graphQLMap["userID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelFollowerFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelFollowerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelFollowerFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelFollowerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelFollowerFilterInput? {
    get {
      return graphQLMap["not"] as! ModelFollowerFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelVideoFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, description: ModelStringInput? = nil, title: ModelStringInput? = nil, views: ModelIntInput? = nil, votes: ModelIntInput? = nil, userId: ModelIDInput? = nil, and: [ModelVideoFilterInput?]? = nil, or: [ModelVideoFilterInput?]? = nil, not: ModelVideoFilterInput? = nil) {
    graphQLMap = ["id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var description: ModelStringInput? {
    get {
      return graphQLMap["description"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var title: ModelStringInput? {
    get {
      return graphQLMap["title"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var views: ModelIntInput? {
    get {
      return graphQLMap["views"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "views")
    }
  }

  public var votes: ModelIntInput? {
    get {
      return graphQLMap["votes"] as! ModelIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "votes")
    }
  }

  public var userId: ModelIDInput? {
    get {
      return graphQLMap["userID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelVideoFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelVideoFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelVideoFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelVideoFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelVideoFilterInput? {
    get {
      return graphQLMap["not"] as! ModelVideoFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelFollowingFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, timestamp: ModelStringInput? = nil, userId: ModelIDInput? = nil, and: [ModelFollowingFilterInput?]? = nil, or: [ModelFollowingFilterInput?]? = nil, not: ModelFollowingFilterInput? = nil) {
    graphQLMap = ["id": id, "timestamp": timestamp, "userID": userId, "and": and, "or": or, "not": not]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var timestamp: ModelStringInput? {
    get {
      return graphQLMap["timestamp"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var userId: ModelIDInput? {
    get {
      return graphQLMap["userID"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelFollowingFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelFollowingFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelFollowingFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelFollowingFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelFollowingFilterInput? {
    get {
      return graphQLMap["not"] as! ModelFollowingFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }
}

public struct ModelUserFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelIDInput? = nil, name: ModelStringInput? = nil, bio: ModelStringInput? = nil, birthdate: ModelStringInput? = nil, live: ModelBooleanInput? = nil, picture: ModelStringInput? = nil, userType: ModelStringInput? = nil, username: ModelStringInput? = nil, verified: ModelBooleanInput? = nil, following: ModelStringInput? = nil, followers: ModelStringInput? = nil, savedVideos: ModelStringInput? = nil, bioLink: ModelStringInput? = nil, and: [ModelUserFilterInput?]? = nil, or: [ModelUserFilterInput?]? = nil, not: ModelUserFilterInput? = nil, userUserStreamKeyId: ModelIDInput? = nil) {
    graphQLMap = ["id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "bioLink": bioLink, "and": and, "or": or, "not": not, "userUserStreamKeyId": userUserStreamKeyId]
  }

  public var id: ModelIDInput? {
    get {
      return graphQLMap["id"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: ModelStringInput? {
    get {
      return graphQLMap["name"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var bio: ModelStringInput? {
    get {
      return graphQLMap["bio"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bio")
    }
  }

  public var birthdate: ModelStringInput? {
    get {
      return graphQLMap["birthdate"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "birthdate")
    }
  }

  public var live: ModelBooleanInput? {
    get {
      return graphQLMap["live"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "live")
    }
  }

  public var picture: ModelStringInput? {
    get {
      return graphQLMap["picture"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "picture")
    }
  }

  public var userType: ModelStringInput? {
    get {
      return graphQLMap["userType"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userType")
    }
  }

  public var username: ModelStringInput? {
    get {
      return graphQLMap["username"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var verified: ModelBooleanInput? {
    get {
      return graphQLMap["verified"] as! ModelBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "verified")
    }
  }

  public var following: ModelStringInput? {
    get {
      return graphQLMap["following"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "following")
    }
  }

  public var followers: ModelStringInput? {
    get {
      return graphQLMap["followers"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "followers")
    }
  }

  public var savedVideos: ModelStringInput? {
    get {
      return graphQLMap["savedVideos"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "savedVideos")
    }
  }

  public var bioLink: ModelStringInput? {
    get {
      return graphQLMap["bioLink"] as! ModelStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bioLink")
    }
  }

  public var and: [ModelUserFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelUserFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelUserFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelUserFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }

  public var not: ModelUserFilterInput? {
    get {
      return graphQLMap["not"] as! ModelUserFilterInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "not")
    }
  }

  public var userUserStreamKeyId: ModelIDInput? {
    get {
      return graphQLMap["userUserStreamKeyId"] as! ModelIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userUserStreamKeyId")
    }
  }
}

public struct ModelSubscriptionConversationFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, participants: ModelSubscriptionStringInput? = nil, lastMessageId: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionConversationFilterInput?]? = nil, or: [ModelSubscriptionConversationFilterInput?]? = nil) {
    graphQLMap = ["id": id, "participants": participants, "lastMessageID": lastMessageId, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var participants: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["participants"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "participants")
    }
  }

  public var lastMessageId: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["lastMessageID"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastMessageID")
    }
  }

  public var and: [ModelSubscriptionConversationFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionConversationFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionConversationFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionConversationFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionIDInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: GraphQLID? = nil, eq: GraphQLID? = nil, le: GraphQLID? = nil, lt: GraphQLID? = nil, ge: GraphQLID? = nil, gt: GraphQLID? = nil, contains: GraphQLID? = nil, notContains: GraphQLID? = nil, between: [GraphQLID?]? = nil, beginsWith: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: GraphQLID? {
    get {
      return graphQLMap["ne"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: GraphQLID? {
    get {
      return graphQLMap["eq"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: GraphQLID? {
    get {
      return graphQLMap["le"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: GraphQLID? {
    get {
      return graphQLMap["lt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: GraphQLID? {
    get {
      return graphQLMap["ge"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: GraphQLID? {
    get {
      return graphQLMap["gt"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: GraphQLID? {
    get {
      return graphQLMap["contains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: GraphQLID? {
    get {
      return graphQLMap["notContains"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [GraphQLID?]? {
    get {
      return graphQLMap["between"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: GraphQLID? {
    get {
      return graphQLMap["beginsWith"] as! GraphQLID?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [GraphQLID?]? {
    get {
      return graphQLMap["in"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [GraphQLID?]? {
    get {
      return graphQLMap["notIn"] as! [GraphQLID?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionStringInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: String? = nil, eq: String? = nil, le: String? = nil, lt: String? = nil, ge: String? = nil, gt: String? = nil, contains: String? = nil, notContains: String? = nil, between: [String?]? = nil, beginsWith: String? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "contains": contains, "notContains": notContains, "between": between, "beginsWith": beginsWith, "in": `in`, "notIn": notIn]
  }

  public var ne: String? {
    get {
      return graphQLMap["ne"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: String? {
    get {
      return graphQLMap["eq"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: String? {
    get {
      return graphQLMap["le"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: String? {
    get {
      return graphQLMap["lt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: String? {
    get {
      return graphQLMap["ge"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: String? {
    get {
      return graphQLMap["gt"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var contains: String? {
    get {
      return graphQLMap["contains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "contains")
    }
  }

  public var notContains: String? {
    get {
      return graphQLMap["notContains"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notContains")
    }
  }

  public var between: [String?]? {
    get {
      return graphQLMap["between"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var beginsWith: String? {
    get {
      return graphQLMap["beginsWith"] as! String?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "beginsWith")
    }
  }

  public var `in`: [String?]? {
    get {
      return graphQLMap["in"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [String?]? {
    get {
      return graphQLMap["notIn"] as! [String?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionMessageFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, content: ModelSubscriptionStringInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, sender: ModelSubscriptionStringInput? = nil, conversationId: ModelSubscriptionIDInput? = nil, and: [ModelSubscriptionMessageFilterInput?]? = nil, or: [ModelSubscriptionMessageFilterInput?]? = nil) {
    graphQLMap = ["id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var content: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["content"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "content")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var sender: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["sender"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sender")
    }
  }

  public var conversationId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["conversationID"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "conversationID")
    }
  }

  public var and: [ModelSubscriptionMessageFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionMessageFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionMessageFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionMessageFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionReactionFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, action: ModelSubscriptionStringInput? = nil, createdAt: ModelSubscriptionStringInput? = nil, videoId: ModelSubscriptionIDInput? = nil, userId: ModelSubscriptionIDInput? = nil, and: [ModelSubscriptionReactionFilterInput?]? = nil, or: [ModelSubscriptionReactionFilterInput?]? = nil) {
    graphQLMap = ["id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var action: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["action"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "action")
    }
  }

  public var createdAt: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["createdAt"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var videoId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["videoID"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoID")
    }
  }

  public var userId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["userID"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelSubscriptionReactionFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionReactionFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionReactionFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionReactionFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionStreamKeyFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, streamKey: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionStreamKeyFilterInput?]? = nil, or: [ModelSubscriptionStreamKeyFilterInput?]? = nil) {
    graphQLMap = ["id": id, "streamKey": streamKey, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var streamKey: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["streamKey"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "streamKey")
    }
  }

  public var and: [ModelSubscriptionStreamKeyFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionStreamKeyFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionStreamKeyFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionStreamKeyFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionCommentFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, body: ModelSubscriptionStringInput? = nil, timestamp: ModelSubscriptionStringInput? = nil, responses: ModelSubscriptionStringInput? = nil, videoId: ModelSubscriptionIDInput? = nil, userId: ModelSubscriptionIDInput? = nil, and: [ModelSubscriptionCommentFilterInput?]? = nil, or: [ModelSubscriptionCommentFilterInput?]? = nil) {
    graphQLMap = ["id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var body: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["body"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "body")
    }
  }

  public var timestamp: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["timestamp"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var responses: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["responses"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "responses")
    }
  }

  public var videoId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["videoID"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "videoID")
    }
  }

  public var userId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["userID"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelSubscriptionCommentFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionCommentFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionCommentFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionCommentFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionFollowerFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, timestamp: ModelSubscriptionStringInput? = nil, userId: ModelSubscriptionIDInput? = nil, and: [ModelSubscriptionFollowerFilterInput?]? = nil, or: [ModelSubscriptionFollowerFilterInput?]? = nil) {
    graphQLMap = ["id": id, "timestamp": timestamp, "userID": userId, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var timestamp: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["timestamp"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var userId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["userID"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelSubscriptionFollowerFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionFollowerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionFollowerFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionFollowerFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionVideoFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, description: ModelSubscriptionStringInput? = nil, title: ModelSubscriptionStringInput? = nil, views: ModelSubscriptionIntInput? = nil, votes: ModelSubscriptionIntInput? = nil, userId: ModelSubscriptionIDInput? = nil, and: [ModelSubscriptionVideoFilterInput?]? = nil, or: [ModelSubscriptionVideoFilterInput?]? = nil) {
    graphQLMap = ["id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var description: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["description"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "description")
    }
  }

  public var title: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["title"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var views: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["views"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "views")
    }
  }

  public var votes: ModelSubscriptionIntInput? {
    get {
      return graphQLMap["votes"] as! ModelSubscriptionIntInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "votes")
    }
  }

  public var userId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["userID"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelSubscriptionVideoFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionVideoFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionVideoFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionVideoFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionIntInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Int? = nil, eq: Int? = nil, le: Int? = nil, lt: Int? = nil, ge: Int? = nil, gt: Int? = nil, between: [Int?]? = nil, `in`: [Int?]? = nil, notIn: [Int?]? = nil) {
    graphQLMap = ["ne": ne, "eq": eq, "le": le, "lt": lt, "ge": ge, "gt": gt, "between": between, "in": `in`, "notIn": notIn]
  }

  public var ne: Int? {
    get {
      return graphQLMap["ne"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Int? {
    get {
      return graphQLMap["eq"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }

  public var le: Int? {
    get {
      return graphQLMap["le"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "le")
    }
  }

  public var lt: Int? {
    get {
      return graphQLMap["lt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lt")
    }
  }

  public var ge: Int? {
    get {
      return graphQLMap["ge"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ge")
    }
  }

  public var gt: Int? {
    get {
      return graphQLMap["gt"] as! Int?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gt")
    }
  }

  public var between: [Int?]? {
    get {
      return graphQLMap["between"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "between")
    }
  }

  public var `in`: [Int?]? {
    get {
      return graphQLMap["in"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "in")
    }
  }

  public var notIn: [Int?]? {
    get {
      return graphQLMap["notIn"] as! [Int?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "notIn")
    }
  }
}

public struct ModelSubscriptionFollowingFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, timestamp: ModelSubscriptionStringInput? = nil, userId: ModelSubscriptionIDInput? = nil, and: [ModelSubscriptionFollowingFilterInput?]? = nil, or: [ModelSubscriptionFollowingFilterInput?]? = nil) {
    graphQLMap = ["id": id, "timestamp": timestamp, "userID": userId, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var timestamp: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["timestamp"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "timestamp")
    }
  }

  public var userId: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["userID"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userID")
    }
  }

  public var and: [ModelSubscriptionFollowingFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionFollowingFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionFollowingFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionFollowingFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionUserFilterInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: ModelSubscriptionIDInput? = nil, name: ModelSubscriptionStringInput? = nil, bio: ModelSubscriptionStringInput? = nil, birthdate: ModelSubscriptionStringInput? = nil, live: ModelSubscriptionBooleanInput? = nil, picture: ModelSubscriptionStringInput? = nil, userType: ModelSubscriptionStringInput? = nil, username: ModelSubscriptionStringInput? = nil, verified: ModelSubscriptionBooleanInput? = nil, following: ModelSubscriptionStringInput? = nil, followers: ModelSubscriptionStringInput? = nil, savedVideos: ModelSubscriptionStringInput? = nil, bioLink: ModelSubscriptionStringInput? = nil, and: [ModelSubscriptionUserFilterInput?]? = nil, or: [ModelSubscriptionUserFilterInput?]? = nil) {
    graphQLMap = ["id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "bioLink": bioLink, "and": and, "or": or]
  }

  public var id: ModelSubscriptionIDInput? {
    get {
      return graphQLMap["id"] as! ModelSubscriptionIDInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var name: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["name"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var bio: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["bio"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bio")
    }
  }

  public var birthdate: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["birthdate"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "birthdate")
    }
  }

  public var live: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["live"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "live")
    }
  }

  public var picture: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["picture"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "picture")
    }
  }

  public var userType: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["userType"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "userType")
    }
  }

  public var username: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["username"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "username")
    }
  }

  public var verified: ModelSubscriptionBooleanInput? {
    get {
      return graphQLMap["verified"] as! ModelSubscriptionBooleanInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "verified")
    }
  }

  public var following: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["following"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "following")
    }
  }

  public var followers: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["followers"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "followers")
    }
  }

  public var savedVideos: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["savedVideos"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "savedVideos")
    }
  }

  public var bioLink: ModelSubscriptionStringInput? {
    get {
      return graphQLMap["bioLink"] as! ModelSubscriptionStringInput?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bioLink")
    }
  }

  public var and: [ModelSubscriptionUserFilterInput?]? {
    get {
      return graphQLMap["and"] as! [ModelSubscriptionUserFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "and")
    }
  }

  public var or: [ModelSubscriptionUserFilterInput?]? {
    get {
      return graphQLMap["or"] as! [ModelSubscriptionUserFilterInput?]?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "or")
    }
  }
}

public struct ModelSubscriptionBooleanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(ne: Bool? = nil, eq: Bool? = nil) {
    graphQLMap = ["ne": ne, "eq": eq]
  }

  public var ne: Bool? {
    get {
      return graphQLMap["ne"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ne")
    }
  }

  public var eq: Bool? {
    get {
      return graphQLMap["eq"] as! Bool?
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "eq")
    }
  }
}

public final class CreateConversationMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateConversation($input: CreateConversationInput!, $condition: ModelConversationConditionInput) {\n  createConversation(input: $input, condition: $condition) {\n    __typename\n    id\n    messages {\n      __typename\n      nextToken\n    }\n    participants\n    lastMessageID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateConversationInput
  public var condition: ModelConversationConditionInput?

  public init(input: CreateConversationInput, condition: ModelConversationConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createConversation", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createConversation: CreateConversation? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createConversation": createConversation.flatMap { $0.snapshot }])
    }

    public var createConversation: CreateConversation? {
      get {
        return (snapshot["createConversation"] as? Snapshot).flatMap { CreateConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createConversation")
      }
    }

    public struct CreateConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("messages", type: .object(Message.selections)),
        GraphQLField("participants", type: .list(.scalar(String.self))),
        GraphQLField("lastMessageID", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, messages: Message? = nil, participants: [String?]? = nil, lastMessageId: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Conversation", "id": id, "messages": messages.flatMap { $0.snapshot }, "participants": participants, "lastMessageID": lastMessageId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var messages: Message? {
        get {
          return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "messages")
        }
      }

      public var participants: [String?]? {
        get {
          return snapshot["participants"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "participants")
        }
      }

      public var lastMessageId: String? {
        get {
          return snapshot["lastMessageID"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastMessageID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelMessageConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelMessageConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class UpdateConversationMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateConversation($input: UpdateConversationInput!, $condition: ModelConversationConditionInput) {\n  updateConversation(input: $input, condition: $condition) {\n    __typename\n    id\n    messages {\n      __typename\n      nextToken\n    }\n    participants\n    lastMessageID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateConversationInput
  public var condition: ModelConversationConditionInput?

  public init(input: UpdateConversationInput, condition: ModelConversationConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateConversation", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateConversation: UpdateConversation? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateConversation": updateConversation.flatMap { $0.snapshot }])
    }

    public var updateConversation: UpdateConversation? {
      get {
        return (snapshot["updateConversation"] as? Snapshot).flatMap { UpdateConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateConversation")
      }
    }

    public struct UpdateConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("messages", type: .object(Message.selections)),
        GraphQLField("participants", type: .list(.scalar(String.self))),
        GraphQLField("lastMessageID", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, messages: Message? = nil, participants: [String?]? = nil, lastMessageId: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Conversation", "id": id, "messages": messages.flatMap { $0.snapshot }, "participants": participants, "lastMessageID": lastMessageId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var messages: Message? {
        get {
          return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "messages")
        }
      }

      public var participants: [String?]? {
        get {
          return snapshot["participants"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "participants")
        }
      }

      public var lastMessageId: String? {
        get {
          return snapshot["lastMessageID"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastMessageID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelMessageConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelMessageConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class DeleteConversationMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteConversation($input: DeleteConversationInput!, $condition: ModelConversationConditionInput) {\n  deleteConversation(input: $input, condition: $condition) {\n    __typename\n    id\n    messages {\n      __typename\n      nextToken\n    }\n    participants\n    lastMessageID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteConversationInput
  public var condition: ModelConversationConditionInput?

  public init(input: DeleteConversationInput, condition: ModelConversationConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteConversation", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteConversation: DeleteConversation? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteConversation": deleteConversation.flatMap { $0.snapshot }])
    }

    public var deleteConversation: DeleteConversation? {
      get {
        return (snapshot["deleteConversation"] as? Snapshot).flatMap { DeleteConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteConversation")
      }
    }

    public struct DeleteConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("messages", type: .object(Message.selections)),
        GraphQLField("participants", type: .list(.scalar(String.self))),
        GraphQLField("lastMessageID", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, messages: Message? = nil, participants: [String?]? = nil, lastMessageId: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Conversation", "id": id, "messages": messages.flatMap { $0.snapshot }, "participants": participants, "lastMessageID": lastMessageId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var messages: Message? {
        get {
          return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "messages")
        }
      }

      public var participants: [String?]? {
        get {
          return snapshot["participants"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "participants")
        }
      }

      public var lastMessageId: String? {
        get {
          return snapshot["lastMessageID"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastMessageID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelMessageConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelMessageConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class CreateMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateMessage($input: CreateMessageInput!, $condition: ModelMessageConditionInput) {\n  createMessage(input: $input, condition: $condition) {\n    __typename\n    id\n    content\n    createdAt\n    sender\n    conversationID\n    updatedAt\n  }\n}"

  public var input: CreateMessageInput
  public var condition: ModelMessageConditionInput?

  public init(input: CreateMessageInput, condition: ModelMessageConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createMessage", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createMessage: CreateMessage? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createMessage": createMessage.flatMap { $0.snapshot }])
    }

    public var createMessage: CreateMessage? {
      get {
        return (snapshot["createMessage"] as? Snapshot).flatMap { CreateMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createMessage")
      }
    }

    public struct CreateMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("sender", type: .scalar(String.self)),
        GraphQLField("conversationID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, createdAt: String? = nil, sender: String? = nil, conversationId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var sender: String? {
        get {
          return snapshot["sender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class UpdateMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateMessage($input: UpdateMessageInput!, $condition: ModelMessageConditionInput) {\n  updateMessage(input: $input, condition: $condition) {\n    __typename\n    id\n    content\n    createdAt\n    sender\n    conversationID\n    updatedAt\n  }\n}"

  public var input: UpdateMessageInput
  public var condition: ModelMessageConditionInput?

  public init(input: UpdateMessageInput, condition: ModelMessageConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateMessage", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateMessage: UpdateMessage? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateMessage": updateMessage.flatMap { $0.snapshot }])
    }

    public var updateMessage: UpdateMessage? {
      get {
        return (snapshot["updateMessage"] as? Snapshot).flatMap { UpdateMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateMessage")
      }
    }

    public struct UpdateMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("sender", type: .scalar(String.self)),
        GraphQLField("conversationID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, createdAt: String? = nil, sender: String? = nil, conversationId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var sender: String? {
        get {
          return snapshot["sender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class DeleteMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteMessage($input: DeleteMessageInput!, $condition: ModelMessageConditionInput) {\n  deleteMessage(input: $input, condition: $condition) {\n    __typename\n    id\n    content\n    createdAt\n    sender\n    conversationID\n    updatedAt\n  }\n}"

  public var input: DeleteMessageInput
  public var condition: ModelMessageConditionInput?

  public init(input: DeleteMessageInput, condition: ModelMessageConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteMessage", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteMessage: DeleteMessage? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteMessage": deleteMessage.flatMap { $0.snapshot }])
    }

    public var deleteMessage: DeleteMessage? {
      get {
        return (snapshot["deleteMessage"] as? Snapshot).flatMap { DeleteMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteMessage")
      }
    }

    public struct DeleteMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("sender", type: .scalar(String.self)),
        GraphQLField("conversationID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, createdAt: String? = nil, sender: String? = nil, conversationId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var sender: String? {
        get {
          return snapshot["sender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class CreateReactionMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateReaction($input: CreateReactionInput!, $condition: ModelReactionConditionInput) {\n  createReaction(input: $input, condition: $condition) {\n    __typename\n    id\n    action\n    createdAt\n    videoID\n    userID\n    updatedAt\n  }\n}"

  public var input: CreateReactionInput
  public var condition: ModelReactionConditionInput?

  public init(input: CreateReactionInput, condition: ModelReactionConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createReaction", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateReaction.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createReaction: CreateReaction? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createReaction": createReaction.flatMap { $0.snapshot }])
    }

    public var createReaction: CreateReaction? {
      get {
        return (snapshot["createReaction"] as? Snapshot).flatMap { CreateReaction(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createReaction")
      }
    }

    public struct CreateReaction: GraphQLSelectionSet {
      public static let possibleTypes = ["Reaction"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("action", type: .scalar(ReactionType.self)),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID, userId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Reaction", "id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var action: ReactionType? {
        get {
          return snapshot["action"] as? ReactionType
        }
        set {
          snapshot.updateValue(newValue, forKey: "action")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class UpdateReactionMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateReaction($input: UpdateReactionInput!, $condition: ModelReactionConditionInput) {\n  updateReaction(input: $input, condition: $condition) {\n    __typename\n    id\n    action\n    createdAt\n    videoID\n    userID\n    updatedAt\n  }\n}"

  public var input: UpdateReactionInput
  public var condition: ModelReactionConditionInput?

  public init(input: UpdateReactionInput, condition: ModelReactionConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateReaction", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateReaction.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateReaction: UpdateReaction? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateReaction": updateReaction.flatMap { $0.snapshot }])
    }

    public var updateReaction: UpdateReaction? {
      get {
        return (snapshot["updateReaction"] as? Snapshot).flatMap { UpdateReaction(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateReaction")
      }
    }

    public struct UpdateReaction: GraphQLSelectionSet {
      public static let possibleTypes = ["Reaction"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("action", type: .scalar(ReactionType.self)),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID, userId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Reaction", "id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var action: ReactionType? {
        get {
          return snapshot["action"] as? ReactionType
        }
        set {
          snapshot.updateValue(newValue, forKey: "action")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class DeleteReactionMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteReaction($input: DeleteReactionInput!, $condition: ModelReactionConditionInput) {\n  deleteReaction(input: $input, condition: $condition) {\n    __typename\n    id\n    action\n    createdAt\n    videoID\n    userID\n    updatedAt\n  }\n}"

  public var input: DeleteReactionInput
  public var condition: ModelReactionConditionInput?

  public init(input: DeleteReactionInput, condition: ModelReactionConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteReaction", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteReaction.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteReaction: DeleteReaction? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteReaction": deleteReaction.flatMap { $0.snapshot }])
    }

    public var deleteReaction: DeleteReaction? {
      get {
        return (snapshot["deleteReaction"] as? Snapshot).flatMap { DeleteReaction(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteReaction")
      }
    }

    public struct DeleteReaction: GraphQLSelectionSet {
      public static let possibleTypes = ["Reaction"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("action", type: .scalar(ReactionType.self)),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID, userId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Reaction", "id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var action: ReactionType? {
        get {
          return snapshot["action"] as? ReactionType
        }
        set {
          snapshot.updateValue(newValue, forKey: "action")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class CreateStreamKeyMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateStreamKey($input: CreateStreamKeyInput!, $condition: ModelStreamKeyConditionInput) {\n  createStreamKey(input: $input, condition: $condition) {\n    __typename\n    id\n    streamKey\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateStreamKeyInput
  public var condition: ModelStreamKeyConditionInput?

  public init(input: CreateStreamKeyInput, condition: ModelStreamKeyConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createStreamKey", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateStreamKey.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createStreamKey: CreateStreamKey? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createStreamKey": createStreamKey.flatMap { $0.snapshot }])
    }

    public var createStreamKey: CreateStreamKey? {
      get {
        return (snapshot["createStreamKey"] as? Snapshot).flatMap { CreateStreamKey(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createStreamKey")
      }
    }

    public struct CreateStreamKey: GraphQLSelectionSet {
      public static let possibleTypes = ["StreamKey"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("streamKey", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var streamKey: String? {
        get {
          return snapshot["streamKey"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "streamKey")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class UpdateStreamKeyMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateStreamKey($input: UpdateStreamKeyInput!, $condition: ModelStreamKeyConditionInput) {\n  updateStreamKey(input: $input, condition: $condition) {\n    __typename\n    id\n    streamKey\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateStreamKeyInput
  public var condition: ModelStreamKeyConditionInput?

  public init(input: UpdateStreamKeyInput, condition: ModelStreamKeyConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateStreamKey", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateStreamKey.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateStreamKey: UpdateStreamKey? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateStreamKey": updateStreamKey.flatMap { $0.snapshot }])
    }

    public var updateStreamKey: UpdateStreamKey? {
      get {
        return (snapshot["updateStreamKey"] as? Snapshot).flatMap { UpdateStreamKey(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateStreamKey")
      }
    }

    public struct UpdateStreamKey: GraphQLSelectionSet {
      public static let possibleTypes = ["StreamKey"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("streamKey", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var streamKey: String? {
        get {
          return snapshot["streamKey"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "streamKey")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class DeleteStreamKeyMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteStreamKey($input: DeleteStreamKeyInput!, $condition: ModelStreamKeyConditionInput) {\n  deleteStreamKey(input: $input, condition: $condition) {\n    __typename\n    id\n    streamKey\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteStreamKeyInput
  public var condition: ModelStreamKeyConditionInput?

  public init(input: DeleteStreamKeyInput, condition: ModelStreamKeyConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteStreamKey", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteStreamKey.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteStreamKey: DeleteStreamKey? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteStreamKey": deleteStreamKey.flatMap { $0.snapshot }])
    }

    public var deleteStreamKey: DeleteStreamKey? {
      get {
        return (snapshot["deleteStreamKey"] as? Snapshot).flatMap { DeleteStreamKey(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteStreamKey")
      }
    }

    public struct DeleteStreamKey: GraphQLSelectionSet {
      public static let possibleTypes = ["StreamKey"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("streamKey", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var streamKey: String? {
        get {
          return snapshot["streamKey"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "streamKey")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class CreateCommentMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateComment($input: CreateCommentInput!, $condition: ModelCommentConditionInput) {\n  createComment(input: $input, condition: $condition) {\n    __typename\n    id\n    body\n    timestamp\n    responses\n    videoID\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateCommentInput
  public var condition: ModelCommentConditionInput?

  public init(input: CreateCommentInput, condition: ModelCommentConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createComment", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateComment.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createComment: CreateComment? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createComment": createComment.flatMap { $0.snapshot }])
    }

    public var createComment: CreateComment? {
      get {
        return (snapshot["createComment"] as? Snapshot).flatMap { CreateComment(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createComment")
      }
    }

    public struct CreateComment: GraphQLSelectionSet {
      public static let possibleTypes = ["Comment"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("body", type: .scalar(String.self)),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("responses", type: .list(.scalar(String.self))),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Comment", "id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var body: String? {
        get {
          return snapshot["body"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "body")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var responses: [String?]? {
        get {
          return snapshot["responses"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "responses")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class UpdateCommentMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateComment($input: UpdateCommentInput!, $condition: ModelCommentConditionInput) {\n  updateComment(input: $input, condition: $condition) {\n    __typename\n    id\n    body\n    timestamp\n    responses\n    videoID\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateCommentInput
  public var condition: ModelCommentConditionInput?

  public init(input: UpdateCommentInput, condition: ModelCommentConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateComment", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateComment.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateComment: UpdateComment? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateComment": updateComment.flatMap { $0.snapshot }])
    }

    public var updateComment: UpdateComment? {
      get {
        return (snapshot["updateComment"] as? Snapshot).flatMap { UpdateComment(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateComment")
      }
    }

    public struct UpdateComment: GraphQLSelectionSet {
      public static let possibleTypes = ["Comment"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("body", type: .scalar(String.self)),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("responses", type: .list(.scalar(String.self))),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Comment", "id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var body: String? {
        get {
          return snapshot["body"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "body")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var responses: [String?]? {
        get {
          return snapshot["responses"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "responses")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class DeleteCommentMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteComment($input: DeleteCommentInput!, $condition: ModelCommentConditionInput) {\n  deleteComment(input: $input, condition: $condition) {\n    __typename\n    id\n    body\n    timestamp\n    responses\n    videoID\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteCommentInput
  public var condition: ModelCommentConditionInput?

  public init(input: DeleteCommentInput, condition: ModelCommentConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteComment", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteComment.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteComment: DeleteComment? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteComment": deleteComment.flatMap { $0.snapshot }])
    }

    public var deleteComment: DeleteComment? {
      get {
        return (snapshot["deleteComment"] as? Snapshot).flatMap { DeleteComment(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteComment")
      }
    }

    public struct DeleteComment: GraphQLSelectionSet {
      public static let possibleTypes = ["Comment"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("body", type: .scalar(String.self)),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("responses", type: .list(.scalar(String.self))),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Comment", "id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var body: String? {
        get {
          return snapshot["body"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "body")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var responses: [String?]? {
        get {
          return snapshot["responses"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "responses")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class CreateFollowerMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateFollower($input: CreateFollowerInput!, $condition: ModelFollowerConditionInput) {\n  createFollower(input: $input, condition: $condition) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateFollowerInput
  public var condition: ModelFollowerConditionInput?

  public init(input: CreateFollowerInput, condition: ModelFollowerConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createFollower", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateFollower.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createFollower: CreateFollower? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createFollower": createFollower.flatMap { $0.snapshot }])
    }

    public var createFollower: CreateFollower? {
      get {
        return (snapshot["createFollower"] as? Snapshot).flatMap { CreateFollower(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createFollower")
      }
    }

    public struct CreateFollower: GraphQLSelectionSet {
      public static let possibleTypes = ["Follower"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Follower", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class UpdateFollowerMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateFollower($input: UpdateFollowerInput!, $condition: ModelFollowerConditionInput) {\n  updateFollower(input: $input, condition: $condition) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateFollowerInput
  public var condition: ModelFollowerConditionInput?

  public init(input: UpdateFollowerInput, condition: ModelFollowerConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateFollower", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateFollower.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateFollower: UpdateFollower? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateFollower": updateFollower.flatMap { $0.snapshot }])
    }

    public var updateFollower: UpdateFollower? {
      get {
        return (snapshot["updateFollower"] as? Snapshot).flatMap { UpdateFollower(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateFollower")
      }
    }

    public struct UpdateFollower: GraphQLSelectionSet {
      public static let possibleTypes = ["Follower"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Follower", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class DeleteFollowerMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteFollower($input: DeleteFollowerInput!, $condition: ModelFollowerConditionInput) {\n  deleteFollower(input: $input, condition: $condition) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteFollowerInput
  public var condition: ModelFollowerConditionInput?

  public init(input: DeleteFollowerInput, condition: ModelFollowerConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteFollower", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteFollower.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteFollower: DeleteFollower? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteFollower": deleteFollower.flatMap { $0.snapshot }])
    }

    public var deleteFollower: DeleteFollower? {
      get {
        return (snapshot["deleteFollower"] as? Snapshot).flatMap { DeleteFollower(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteFollower")
      }
    }

    public struct DeleteFollower: GraphQLSelectionSet {
      public static let possibleTypes = ["Follower"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Follower", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class CreateVideoMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateVideo($input: CreateVideoInput!, $condition: ModelVideoConditionInput) {\n  createVideo(input: $input, condition: $condition) {\n    __typename\n    id\n    description\n    title\n    views\n    votes\n    userID\n    Comments {\n      __typename\n      nextToken\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateVideoInput
  public var condition: ModelVideoConditionInput?

  public init(input: CreateVideoInput, condition: ModelVideoConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createVideo", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createVideo: CreateVideo? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createVideo": createVideo.flatMap { $0.snapshot }])
    }

    public var createVideo: CreateVideo? {
      get {
        return (snapshot["createVideo"] as? Snapshot).flatMap { CreateVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createVideo")
      }
    }

    public struct CreateVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("views", type: .nonNull(.scalar(Int.self))),
        GraphQLField("votes", type: .nonNull(.scalar(Int.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, title: String, views: Int, votes: Int, userId: GraphQLID, comments: Comment? = nil, reactions: Reaction? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Video", "id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId, "Comments": comments.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var views: Int {
        get {
          return snapshot["views"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "views")
        }
      }

      public var votes: Int {
        get {
          return snapshot["votes"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "votes")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class UpdateVideoMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateVideo($input: UpdateVideoInput!, $condition: ModelVideoConditionInput) {\n  updateVideo(input: $input, condition: $condition) {\n    __typename\n    id\n    description\n    title\n    views\n    votes\n    userID\n    Comments {\n      __typename\n      nextToken\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateVideoInput
  public var condition: ModelVideoConditionInput?

  public init(input: UpdateVideoInput, condition: ModelVideoConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateVideo", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateVideo: UpdateVideo? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateVideo": updateVideo.flatMap { $0.snapshot }])
    }

    public var updateVideo: UpdateVideo? {
      get {
        return (snapshot["updateVideo"] as? Snapshot).flatMap { UpdateVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateVideo")
      }
    }

    public struct UpdateVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("views", type: .nonNull(.scalar(Int.self))),
        GraphQLField("votes", type: .nonNull(.scalar(Int.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, title: String, views: Int, votes: Int, userId: GraphQLID, comments: Comment? = nil, reactions: Reaction? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Video", "id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId, "Comments": comments.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var views: Int {
        get {
          return snapshot["views"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "views")
        }
      }

      public var votes: Int {
        get {
          return snapshot["votes"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "votes")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class DeleteVideoMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteVideo($input: DeleteVideoInput!, $condition: ModelVideoConditionInput) {\n  deleteVideo(input: $input, condition: $condition) {\n    __typename\n    id\n    description\n    title\n    views\n    votes\n    userID\n    Comments {\n      __typename\n      nextToken\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteVideoInput
  public var condition: ModelVideoConditionInput?

  public init(input: DeleteVideoInput, condition: ModelVideoConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteVideo", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteVideo: DeleteVideo? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteVideo": deleteVideo.flatMap { $0.snapshot }])
    }

    public var deleteVideo: DeleteVideo? {
      get {
        return (snapshot["deleteVideo"] as? Snapshot).flatMap { DeleteVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteVideo")
      }
    }

    public struct DeleteVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("views", type: .nonNull(.scalar(Int.self))),
        GraphQLField("votes", type: .nonNull(.scalar(Int.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, title: String, views: Int, votes: Int, userId: GraphQLID, comments: Comment? = nil, reactions: Reaction? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Video", "id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId, "Comments": comments.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var views: Int {
        get {
          return snapshot["views"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "views")
        }
      }

      public var votes: Int {
        get {
          return snapshot["votes"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "votes")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class CreateFollowingMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateFollowing($input: CreateFollowingInput!, $condition: ModelFollowingConditionInput) {\n  createFollowing(input: $input, condition: $condition) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: CreateFollowingInput
  public var condition: ModelFollowingConditionInput?

  public init(input: CreateFollowingInput, condition: ModelFollowingConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createFollowing", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateFollowing.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createFollowing: CreateFollowing? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createFollowing": createFollowing.flatMap { $0.snapshot }])
    }

    public var createFollowing: CreateFollowing? {
      get {
        return (snapshot["createFollowing"] as? Snapshot).flatMap { CreateFollowing(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createFollowing")
      }
    }

    public struct CreateFollowing: GraphQLSelectionSet {
      public static let possibleTypes = ["Following"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Following", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class UpdateFollowingMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateFollowing($input: UpdateFollowingInput!, $condition: ModelFollowingConditionInput) {\n  updateFollowing(input: $input, condition: $condition) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: UpdateFollowingInput
  public var condition: ModelFollowingConditionInput?

  public init(input: UpdateFollowingInput, condition: ModelFollowingConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateFollowing", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateFollowing.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateFollowing: UpdateFollowing? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateFollowing": updateFollowing.flatMap { $0.snapshot }])
    }

    public var updateFollowing: UpdateFollowing? {
      get {
        return (snapshot["updateFollowing"] as? Snapshot).flatMap { UpdateFollowing(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateFollowing")
      }
    }

    public struct UpdateFollowing: GraphQLSelectionSet {
      public static let possibleTypes = ["Following"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Following", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class DeleteFollowingMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteFollowing($input: DeleteFollowingInput!, $condition: ModelFollowingConditionInput) {\n  deleteFollowing(input: $input, condition: $condition) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var input: DeleteFollowingInput
  public var condition: ModelFollowingConditionInput?

  public init(input: DeleteFollowingInput, condition: ModelFollowingConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteFollowing", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteFollowing.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteFollowing: DeleteFollowing? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteFollowing": deleteFollowing.flatMap { $0.snapshot }])
    }

    public var deleteFollowing: DeleteFollowing? {
      get {
        return (snapshot["deleteFollowing"] as? Snapshot).flatMap { DeleteFollowing(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteFollowing")
      }
    }

    public struct DeleteFollowing: GraphQLSelectionSet {
      public static let possibleTypes = ["Following"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Following", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class CreateUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation CreateUser($input: CreateUserInput!, $condition: ModelUserConditionInput) {\n  createUser(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    bio\n    birthdate\n    live\n    picture\n    userType\n    username\n    verified\n    following\n    followers\n    savedVideos\n    FollowingUsers {\n      __typename\n      nextToken\n    }\n    Videos {\n      __typename\n      nextToken\n    }\n    Followers {\n      __typename\n      nextToken\n    }\n    Comments {\n      __typename\n      nextToken\n    }\n    UserStreamKey {\n      __typename\n      id\n      streamKey\n      createdAt\n      updatedAt\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    bioLink\n    createdAt\n    updatedAt\n    userUserStreamKeyId\n  }\n}"

  public var input: CreateUserInput
  public var condition: ModelUserConditionInput?

  public init(input: CreateUserInput, condition: ModelUserConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createUser", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(CreateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(createUser: CreateUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "createUser": createUser.flatMap { $0.snapshot }])
    }

    public var createUser: CreateUser? {
      get {
        return (snapshot["createUser"] as? Snapshot).flatMap { CreateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "createUser")
      }
    }

    public struct CreateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("bio", type: .nonNull(.scalar(String.self))),
        GraphQLField("birthdate", type: .nonNull(.scalar(String.self))),
        GraphQLField("live", type: .scalar(Bool.self)),
        GraphQLField("picture", type: .scalar(String.self)),
        GraphQLField("userType", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("verified", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("following", type: .list(.scalar(String.self))),
        GraphQLField("followers", type: .list(.scalar(String.self))),
        GraphQLField("savedVideos", type: .list(.scalar(String.self))),
        GraphQLField("FollowingUsers", type: .object(FollowingUser.selections)),
        GraphQLField("Videos", type: .object(Video.selections)),
        GraphQLField("Followers", type: .object(Follower.selections)),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("UserStreamKey", type: .object(UserStreamKey.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("bioLink", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("userUserStreamKeyId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, bio: String, birthdate: String, live: Bool? = nil, picture: String? = nil, userType: String, username: String, verified: Bool, following: [String?]? = nil, followers: [String?]? = nil, savedVideos: [String?]? = nil, followingUsers: FollowingUser? = nil, videos: Video? = nil, followers: Follower? = nil, comments: Comment? = nil, userStreamKey: UserStreamKey? = nil, reactions: Reaction? = nil, bioLink: String? = nil, createdAt: String, updatedAt: String, userUserStreamKeyId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "FollowingUsers": followingUsers.flatMap { $0.snapshot }, "Videos": videos.flatMap { $0.snapshot }, "Followers": followers.flatMap { $0.snapshot }, "Comments": comments.flatMap { $0.snapshot }, "UserStreamKey": userStreamKey.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "bioLink": bioLink, "createdAt": createdAt, "updatedAt": updatedAt, "userUserStreamKeyId": userUserStreamKeyId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var bio: String {
        get {
          return snapshot["bio"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bio")
        }
      }

      public var birthdate: String {
        get {
          return snapshot["birthdate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "birthdate")
        }
      }

      public var live: Bool? {
        get {
          return snapshot["live"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "live")
        }
      }

      public var picture: String? {
        get {
          return snapshot["picture"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "picture")
        }
      }

      public var userType: String {
        get {
          return snapshot["userType"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "userType")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var verified: Bool {
        get {
          return snapshot["verified"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "verified")
        }
      }

      public var following: [String?]? {
        get {
          return snapshot["following"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "following")
        }
      }

      public var followers: [String?]? {
        get {
          return snapshot["followers"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "followers")
        }
      }

      public var savedVideos: [String?]? {
        get {
          return snapshot["savedVideos"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "savedVideos")
        }
      }

      public var followingUsers: FollowingUser? {
        get {
          return (snapshot["FollowingUsers"] as? Snapshot).flatMap { FollowingUser(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "FollowingUsers")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["Videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Videos")
        }
      }

      public var followers: Follower? {
        get {
          return (snapshot["Followers"] as? Snapshot).flatMap { Follower(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Followers")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var userStreamKey: UserStreamKey? {
        get {
          return (snapshot["UserStreamKey"] as? Snapshot).flatMap { UserStreamKey(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "UserStreamKey")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var bioLink: String? {
        get {
          return snapshot["bioLink"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bioLink")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var userUserStreamKeyId: GraphQLID? {
        get {
          return snapshot["userUserStreamKeyId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userUserStreamKeyId")
        }
      }

      public struct FollowingUser: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Follower: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowerConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowerConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct UserStreamKey: GraphQLSelectionSet {
        public static let possibleTypes = ["StreamKey"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("streamKey", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var streamKey: String? {
          get {
            return snapshot["streamKey"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "streamKey")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class UpdateUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation UpdateUser($input: UpdateUserInput!, $condition: ModelUserConditionInput) {\n  updateUser(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    bio\n    birthdate\n    live\n    picture\n    userType\n    username\n    verified\n    following\n    followers\n    savedVideos\n    FollowingUsers {\n      __typename\n      nextToken\n    }\n    Videos {\n      __typename\n      nextToken\n    }\n    Followers {\n      __typename\n      nextToken\n    }\n    Comments {\n      __typename\n      nextToken\n    }\n    UserStreamKey {\n      __typename\n      id\n      streamKey\n      createdAt\n      updatedAt\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    bioLink\n    createdAt\n    updatedAt\n    userUserStreamKeyId\n  }\n}"

  public var input: UpdateUserInput
  public var condition: ModelUserConditionInput?

  public init(input: UpdateUserInput, condition: ModelUserConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("updateUser", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(UpdateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(updateUser: UpdateUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "updateUser": updateUser.flatMap { $0.snapshot }])
    }

    public var updateUser: UpdateUser? {
      get {
        return (snapshot["updateUser"] as? Snapshot).flatMap { UpdateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "updateUser")
      }
    }

    public struct UpdateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("bio", type: .nonNull(.scalar(String.self))),
        GraphQLField("birthdate", type: .nonNull(.scalar(String.self))),
        GraphQLField("live", type: .scalar(Bool.self)),
        GraphQLField("picture", type: .scalar(String.self)),
        GraphQLField("userType", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("verified", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("following", type: .list(.scalar(String.self))),
        GraphQLField("followers", type: .list(.scalar(String.self))),
        GraphQLField("savedVideos", type: .list(.scalar(String.self))),
        GraphQLField("FollowingUsers", type: .object(FollowingUser.selections)),
        GraphQLField("Videos", type: .object(Video.selections)),
        GraphQLField("Followers", type: .object(Follower.selections)),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("UserStreamKey", type: .object(UserStreamKey.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("bioLink", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("userUserStreamKeyId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, bio: String, birthdate: String, live: Bool? = nil, picture: String? = nil, userType: String, username: String, verified: Bool, following: [String?]? = nil, followers: [String?]? = nil, savedVideos: [String?]? = nil, followingUsers: FollowingUser? = nil, videos: Video? = nil, followers: Follower? = nil, comments: Comment? = nil, userStreamKey: UserStreamKey? = nil, reactions: Reaction? = nil, bioLink: String? = nil, createdAt: String, updatedAt: String, userUserStreamKeyId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "FollowingUsers": followingUsers.flatMap { $0.snapshot }, "Videos": videos.flatMap { $0.snapshot }, "Followers": followers.flatMap { $0.snapshot }, "Comments": comments.flatMap { $0.snapshot }, "UserStreamKey": userStreamKey.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "bioLink": bioLink, "createdAt": createdAt, "updatedAt": updatedAt, "userUserStreamKeyId": userUserStreamKeyId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var bio: String {
        get {
          return snapshot["bio"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bio")
        }
      }

      public var birthdate: String {
        get {
          return snapshot["birthdate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "birthdate")
        }
      }

      public var live: Bool? {
        get {
          return snapshot["live"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "live")
        }
      }

      public var picture: String? {
        get {
          return snapshot["picture"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "picture")
        }
      }

      public var userType: String {
        get {
          return snapshot["userType"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "userType")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var verified: Bool {
        get {
          return snapshot["verified"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "verified")
        }
      }

      public var following: [String?]? {
        get {
          return snapshot["following"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "following")
        }
      }

      public var followers: [String?]? {
        get {
          return snapshot["followers"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "followers")
        }
      }

      public var savedVideos: [String?]? {
        get {
          return snapshot["savedVideos"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "savedVideos")
        }
      }

      public var followingUsers: FollowingUser? {
        get {
          return (snapshot["FollowingUsers"] as? Snapshot).flatMap { FollowingUser(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "FollowingUsers")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["Videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Videos")
        }
      }

      public var followers: Follower? {
        get {
          return (snapshot["Followers"] as? Snapshot).flatMap { Follower(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Followers")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var userStreamKey: UserStreamKey? {
        get {
          return (snapshot["UserStreamKey"] as? Snapshot).flatMap { UserStreamKey(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "UserStreamKey")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var bioLink: String? {
        get {
          return snapshot["bioLink"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bioLink")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var userUserStreamKeyId: GraphQLID? {
        get {
          return snapshot["userUserStreamKeyId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userUserStreamKeyId")
        }
      }

      public struct FollowingUser: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Follower: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowerConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowerConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct UserStreamKey: GraphQLSelectionSet {
        public static let possibleTypes = ["StreamKey"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("streamKey", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var streamKey: String? {
          get {
            return snapshot["streamKey"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "streamKey")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class DeleteUserMutation: GraphQLMutation {
  public static let operationString =
    "mutation DeleteUser($input: DeleteUserInput!, $condition: ModelUserConditionInput) {\n  deleteUser(input: $input, condition: $condition) {\n    __typename\n    id\n    name\n    bio\n    birthdate\n    live\n    picture\n    userType\n    username\n    verified\n    following\n    followers\n    savedVideos\n    FollowingUsers {\n      __typename\n      nextToken\n    }\n    Videos {\n      __typename\n      nextToken\n    }\n    Followers {\n      __typename\n      nextToken\n    }\n    Comments {\n      __typename\n      nextToken\n    }\n    UserStreamKey {\n      __typename\n      id\n      streamKey\n      createdAt\n      updatedAt\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    bioLink\n    createdAt\n    updatedAt\n    userUserStreamKeyId\n  }\n}"

  public var input: DeleteUserInput
  public var condition: ModelUserConditionInput?

  public init(input: DeleteUserInput, condition: ModelUserConditionInput? = nil) {
    self.input = input
    self.condition = condition
  }

  public var variables: GraphQLMap? {
    return ["input": input, "condition": condition]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteUser", arguments: ["input": GraphQLVariable("input"), "condition": GraphQLVariable("condition")], type: .object(DeleteUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(deleteUser: DeleteUser? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "deleteUser": deleteUser.flatMap { $0.snapshot }])
    }

    public var deleteUser: DeleteUser? {
      get {
        return (snapshot["deleteUser"] as? Snapshot).flatMap { DeleteUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "deleteUser")
      }
    }

    public struct DeleteUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("bio", type: .nonNull(.scalar(String.self))),
        GraphQLField("birthdate", type: .nonNull(.scalar(String.self))),
        GraphQLField("live", type: .scalar(Bool.self)),
        GraphQLField("picture", type: .scalar(String.self)),
        GraphQLField("userType", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("verified", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("following", type: .list(.scalar(String.self))),
        GraphQLField("followers", type: .list(.scalar(String.self))),
        GraphQLField("savedVideos", type: .list(.scalar(String.self))),
        GraphQLField("FollowingUsers", type: .object(FollowingUser.selections)),
        GraphQLField("Videos", type: .object(Video.selections)),
        GraphQLField("Followers", type: .object(Follower.selections)),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("UserStreamKey", type: .object(UserStreamKey.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("bioLink", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("userUserStreamKeyId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, bio: String, birthdate: String, live: Bool? = nil, picture: String? = nil, userType: String, username: String, verified: Bool, following: [String?]? = nil, followers: [String?]? = nil, savedVideos: [String?]? = nil, followingUsers: FollowingUser? = nil, videos: Video? = nil, followers: Follower? = nil, comments: Comment? = nil, userStreamKey: UserStreamKey? = nil, reactions: Reaction? = nil, bioLink: String? = nil, createdAt: String, updatedAt: String, userUserStreamKeyId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "FollowingUsers": followingUsers.flatMap { $0.snapshot }, "Videos": videos.flatMap { $0.snapshot }, "Followers": followers.flatMap { $0.snapshot }, "Comments": comments.flatMap { $0.snapshot }, "UserStreamKey": userStreamKey.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "bioLink": bioLink, "createdAt": createdAt, "updatedAt": updatedAt, "userUserStreamKeyId": userUserStreamKeyId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var bio: String {
        get {
          return snapshot["bio"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bio")
        }
      }

      public var birthdate: String {
        get {
          return snapshot["birthdate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "birthdate")
        }
      }

      public var live: Bool? {
        get {
          return snapshot["live"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "live")
        }
      }

      public var picture: String? {
        get {
          return snapshot["picture"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "picture")
        }
      }

      public var userType: String {
        get {
          return snapshot["userType"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "userType")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var verified: Bool {
        get {
          return snapshot["verified"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "verified")
        }
      }

      public var following: [String?]? {
        get {
          return snapshot["following"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "following")
        }
      }

      public var followers: [String?]? {
        get {
          return snapshot["followers"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "followers")
        }
      }

      public var savedVideos: [String?]? {
        get {
          return snapshot["savedVideos"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "savedVideos")
        }
      }

      public var followingUsers: FollowingUser? {
        get {
          return (snapshot["FollowingUsers"] as? Snapshot).flatMap { FollowingUser(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "FollowingUsers")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["Videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Videos")
        }
      }

      public var followers: Follower? {
        get {
          return (snapshot["Followers"] as? Snapshot).flatMap { Follower(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Followers")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var userStreamKey: UserStreamKey? {
        get {
          return (snapshot["UserStreamKey"] as? Snapshot).flatMap { UserStreamKey(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "UserStreamKey")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var bioLink: String? {
        get {
          return snapshot["bioLink"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bioLink")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var userUserStreamKeyId: GraphQLID? {
        get {
          return snapshot["userUserStreamKeyId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userUserStreamKeyId")
        }
      }

      public struct FollowingUser: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Follower: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowerConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowerConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct UserStreamKey: GraphQLSelectionSet {
        public static let possibleTypes = ["StreamKey"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("streamKey", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var streamKey: String? {
          get {
            return snapshot["streamKey"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "streamKey")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class GetConversationQuery: GraphQLQuery {
  public static let operationString =
    "query GetConversation($id: ID!) {\n  getConversation(id: $id) {\n    __typename\n    id\n    messages {\n      __typename\n      nextToken\n    }\n    participants\n    lastMessageID\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getConversation", arguments: ["id": GraphQLVariable("id")], type: .object(GetConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getConversation: GetConversation? = nil) {
      self.init(snapshot: ["__typename": "Query", "getConversation": getConversation.flatMap { $0.snapshot }])
    }

    public var getConversation: GetConversation? {
      get {
        return (snapshot["getConversation"] as? Snapshot).flatMap { GetConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getConversation")
      }
    }

    public struct GetConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("messages", type: .object(Message.selections)),
        GraphQLField("participants", type: .list(.scalar(String.self))),
        GraphQLField("lastMessageID", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, messages: Message? = nil, participants: [String?]? = nil, lastMessageId: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Conversation", "id": id, "messages": messages.flatMap { $0.snapshot }, "participants": participants, "lastMessageID": lastMessageId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var messages: Message? {
        get {
          return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "messages")
        }
      }

      public var participants: [String?]? {
        get {
          return snapshot["participants"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "participants")
        }
      }

      public var lastMessageId: String? {
        get {
          return snapshot["lastMessageID"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastMessageID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelMessageConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelMessageConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class ListConversationsQuery: GraphQLQuery {
  public static let operationString =
    "query ListConversations($filter: ModelConversationFilterInput, $limit: Int, $nextToken: String) {\n  listConversations(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      participants\n      lastMessageID\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelConversationFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelConversationFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listConversations", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listConversations: ListConversation? = nil) {
      self.init(snapshot: ["__typename": "Query", "listConversations": listConversations.flatMap { $0.snapshot }])
    }

    public var listConversations: ListConversation? {
      get {
        return (snapshot["listConversations"] as? Snapshot).flatMap { ListConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listConversations")
      }
    }

    public struct ListConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelConversationConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelConversationConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Conversation"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("participants", type: .list(.scalar(String.self))),
          GraphQLField("lastMessageID", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, participants: [String?]? = nil, lastMessageId: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Conversation", "id": id, "participants": participants, "lastMessageID": lastMessageId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var participants: [String?]? {
          get {
            return snapshot["participants"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "participants")
          }
        }

        public var lastMessageId: String? {
          get {
            return snapshot["lastMessageID"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "lastMessageID")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetMessageQuery: GraphQLQuery {
  public static let operationString =
    "query GetMessage($id: ID!) {\n  getMessage(id: $id) {\n    __typename\n    id\n    content\n    createdAt\n    sender\n    conversationID\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getMessage", arguments: ["id": GraphQLVariable("id")], type: .object(GetMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getMessage: GetMessage? = nil) {
      self.init(snapshot: ["__typename": "Query", "getMessage": getMessage.flatMap { $0.snapshot }])
    }

    public var getMessage: GetMessage? {
      get {
        return (snapshot["getMessage"] as? Snapshot).flatMap { GetMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getMessage")
      }
    }

    public struct GetMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("sender", type: .scalar(String.self)),
        GraphQLField("conversationID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, createdAt: String? = nil, sender: String? = nil, conversationId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var sender: String? {
        get {
          return snapshot["sender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class ListMessagesQuery: GraphQLQuery {
  public static let operationString =
    "query ListMessages($filter: ModelMessageFilterInput, $limit: Int, $nextToken: String) {\n  listMessages(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      content\n      createdAt\n      sender\n      conversationID\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelMessageFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelMessageFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listMessages", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listMessages: ListMessage? = nil) {
      self.init(snapshot: ["__typename": "Query", "listMessages": listMessages.flatMap { $0.snapshot }])
    }

    public var listMessages: ListMessage? {
      get {
        return (snapshot["listMessages"] as? Snapshot).flatMap { ListMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listMessages")
      }
    }

    public struct ListMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelMessageConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelMessageConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Message"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .scalar(String.self)),
          GraphQLField("sender", type: .scalar(String.self)),
          GraphQLField("conversationID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, content: String, createdAt: String? = nil, sender: String? = nil, conversationId: GraphQLID, updatedAt: String) {
          self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var content: String {
          get {
            return snapshot["content"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
          }
        }

        public var createdAt: String? {
          get {
            return snapshot["createdAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var sender: String? {
          get {
            return snapshot["sender"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "sender")
          }
        }

        public var conversationId: GraphQLID {
          get {
            return snapshot["conversationID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "conversationID")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class MessagesByConversationIdQuery: GraphQLQuery {
  public static let operationString =
    "query MessagesByConversationID($conversationID: ID!, $sortDirection: ModelSortDirection, $filter: ModelMessageFilterInput, $limit: Int, $nextToken: String) {\n  messagesByConversationID(\n    conversationID: $conversationID\n    sortDirection: $sortDirection\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      content\n      createdAt\n      sender\n      conversationID\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var conversationID: GraphQLID
  public var sortDirection: ModelSortDirection?
  public var filter: ModelMessageFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(conversationID: GraphQLID, sortDirection: ModelSortDirection? = nil, filter: ModelMessageFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.conversationID = conversationID
    self.sortDirection = sortDirection
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["conversationID": conversationID, "sortDirection": sortDirection, "filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("messagesByConversationID", arguments: ["conversationID": GraphQLVariable("conversationID"), "sortDirection": GraphQLVariable("sortDirection"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(MessagesByConversationId.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(messagesByConversationId: MessagesByConversationId? = nil) {
      self.init(snapshot: ["__typename": "Query", "messagesByConversationID": messagesByConversationId.flatMap { $0.snapshot }])
    }

    public var messagesByConversationId: MessagesByConversationId? {
      get {
        return (snapshot["messagesByConversationID"] as? Snapshot).flatMap { MessagesByConversationId(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "messagesByConversationID")
      }
    }

    public struct MessagesByConversationId: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelMessageConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelMessageConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Message"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("content", type: .nonNull(.scalar(String.self))),
          GraphQLField("createdAt", type: .scalar(String.self)),
          GraphQLField("sender", type: .scalar(String.self)),
          GraphQLField("conversationID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, content: String, createdAt: String? = nil, sender: String? = nil, conversationId: GraphQLID, updatedAt: String) {
          self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var content: String {
          get {
            return snapshot["content"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "content")
          }
        }

        public var createdAt: String? {
          get {
            return snapshot["createdAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var sender: String? {
          get {
            return snapshot["sender"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "sender")
          }
        }

        public var conversationId: GraphQLID {
          get {
            return snapshot["conversationID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "conversationID")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetReactionQuery: GraphQLQuery {
  public static let operationString =
    "query GetReaction($id: ID!) {\n  getReaction(id: $id) {\n    __typename\n    id\n    action\n    createdAt\n    videoID\n    userID\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getReaction", arguments: ["id": GraphQLVariable("id")], type: .object(GetReaction.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getReaction: GetReaction? = nil) {
      self.init(snapshot: ["__typename": "Query", "getReaction": getReaction.flatMap { $0.snapshot }])
    }

    public var getReaction: GetReaction? {
      get {
        return (snapshot["getReaction"] as? Snapshot).flatMap { GetReaction(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getReaction")
      }
    }

    public struct GetReaction: GraphQLSelectionSet {
      public static let possibleTypes = ["Reaction"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("action", type: .scalar(ReactionType.self)),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID, userId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Reaction", "id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var action: ReactionType? {
        get {
          return snapshot["action"] as? ReactionType
        }
        set {
          snapshot.updateValue(newValue, forKey: "action")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class ListReactionsQuery: GraphQLQuery {
  public static let operationString =
    "query ListReactions($filter: ModelReactionFilterInput, $limit: Int, $nextToken: String) {\n  listReactions(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      action\n      createdAt\n      videoID\n      userID\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelReactionFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelReactionFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listReactions", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListReaction.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listReactions: ListReaction? = nil) {
      self.init(snapshot: ["__typename": "Query", "listReactions": listReactions.flatMap { $0.snapshot }])
    }

    public var listReactions: ListReaction? {
      get {
        return (snapshot["listReactions"] as? Snapshot).flatMap { ListReaction(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listReactions")
      }
    }

    public struct ListReaction: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelReactionConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelReactionConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Reaction"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("action", type: .scalar(ReactionType.self)),
          GraphQLField("createdAt", type: .scalar(String.self)),
          GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID, userId: GraphQLID, updatedAt: String) {
          self.init(snapshot: ["__typename": "Reaction", "id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var action: ReactionType? {
          get {
            return snapshot["action"] as? ReactionType
          }
          set {
            snapshot.updateValue(newValue, forKey: "action")
          }
        }

        public var createdAt: String? {
          get {
            return snapshot["createdAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var videoId: GraphQLID {
          get {
            return snapshot["videoID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "videoID")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class ReactionsByVideoIdQuery: GraphQLQuery {
  public static let operationString =
    "query ReactionsByVideoID($videoID: ID!, $sortDirection: ModelSortDirection, $filter: ModelReactionFilterInput, $limit: Int, $nextToken: String) {\n  reactionsByVideoID(\n    videoID: $videoID\n    sortDirection: $sortDirection\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      action\n      createdAt\n      videoID\n      userID\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var videoID: GraphQLID
  public var sortDirection: ModelSortDirection?
  public var filter: ModelReactionFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(videoID: GraphQLID, sortDirection: ModelSortDirection? = nil, filter: ModelReactionFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.videoID = videoID
    self.sortDirection = sortDirection
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["videoID": videoID, "sortDirection": sortDirection, "filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("reactionsByVideoID", arguments: ["videoID": GraphQLVariable("videoID"), "sortDirection": GraphQLVariable("sortDirection"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ReactionsByVideoId.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(reactionsByVideoId: ReactionsByVideoId? = nil) {
      self.init(snapshot: ["__typename": "Query", "reactionsByVideoID": reactionsByVideoId.flatMap { $0.snapshot }])
    }

    public var reactionsByVideoId: ReactionsByVideoId? {
      get {
        return (snapshot["reactionsByVideoID"] as? Snapshot).flatMap { ReactionsByVideoId(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "reactionsByVideoID")
      }
    }

    public struct ReactionsByVideoId: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelReactionConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelReactionConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Reaction"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("action", type: .scalar(ReactionType.self)),
          GraphQLField("createdAt", type: .scalar(String.self)),
          GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID, userId: GraphQLID, updatedAt: String) {
          self.init(snapshot: ["__typename": "Reaction", "id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var action: ReactionType? {
          get {
            return snapshot["action"] as? ReactionType
          }
          set {
            snapshot.updateValue(newValue, forKey: "action")
          }
        }

        public var createdAt: String? {
          get {
            return snapshot["createdAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var videoId: GraphQLID {
          get {
            return snapshot["videoID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "videoID")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class ReactionsByUserIdQuery: GraphQLQuery {
  public static let operationString =
    "query ReactionsByUserID($userID: ID!, $sortDirection: ModelSortDirection, $filter: ModelReactionFilterInput, $limit: Int, $nextToken: String) {\n  reactionsByUserID(\n    userID: $userID\n    sortDirection: $sortDirection\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      action\n      createdAt\n      videoID\n      userID\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var userID: GraphQLID
  public var sortDirection: ModelSortDirection?
  public var filter: ModelReactionFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(userID: GraphQLID, sortDirection: ModelSortDirection? = nil, filter: ModelReactionFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.userID = userID
    self.sortDirection = sortDirection
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["userID": userID, "sortDirection": sortDirection, "filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("reactionsByUserID", arguments: ["userID": GraphQLVariable("userID"), "sortDirection": GraphQLVariable("sortDirection"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ReactionsByUserId.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(reactionsByUserId: ReactionsByUserId? = nil) {
      self.init(snapshot: ["__typename": "Query", "reactionsByUserID": reactionsByUserId.flatMap { $0.snapshot }])
    }

    public var reactionsByUserId: ReactionsByUserId? {
      get {
        return (snapshot["reactionsByUserID"] as? Snapshot).flatMap { ReactionsByUserId(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "reactionsByUserID")
      }
    }

    public struct ReactionsByUserId: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelReactionConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelReactionConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Reaction"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("action", type: .scalar(ReactionType.self)),
          GraphQLField("createdAt", type: .scalar(String.self)),
          GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID, userId: GraphQLID, updatedAt: String) {
          self.init(snapshot: ["__typename": "Reaction", "id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var action: ReactionType? {
          get {
            return snapshot["action"] as? ReactionType
          }
          set {
            snapshot.updateValue(newValue, forKey: "action")
          }
        }

        public var createdAt: String? {
          get {
            return snapshot["createdAt"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var videoId: GraphQLID {
          get {
            return snapshot["videoID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "videoID")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetStreamKeyQuery: GraphQLQuery {
  public static let operationString =
    "query GetStreamKey($id: ID!) {\n  getStreamKey(id: $id) {\n    __typename\n    id\n    streamKey\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getStreamKey", arguments: ["id": GraphQLVariable("id")], type: .object(GetStreamKey.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getStreamKey: GetStreamKey? = nil) {
      self.init(snapshot: ["__typename": "Query", "getStreamKey": getStreamKey.flatMap { $0.snapshot }])
    }

    public var getStreamKey: GetStreamKey? {
      get {
        return (snapshot["getStreamKey"] as? Snapshot).flatMap { GetStreamKey(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getStreamKey")
      }
    }

    public struct GetStreamKey: GraphQLSelectionSet {
      public static let possibleTypes = ["StreamKey"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("streamKey", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var streamKey: String? {
        get {
          return snapshot["streamKey"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "streamKey")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class ListStreamKeysQuery: GraphQLQuery {
  public static let operationString =
    "query ListStreamKeys($filter: ModelStreamKeyFilterInput, $limit: Int, $nextToken: String) {\n  listStreamKeys(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      streamKey\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelStreamKeyFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelStreamKeyFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listStreamKeys", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListStreamKey.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listStreamKeys: ListStreamKey? = nil) {
      self.init(snapshot: ["__typename": "Query", "listStreamKeys": listStreamKeys.flatMap { $0.snapshot }])
    }

    public var listStreamKeys: ListStreamKey? {
      get {
        return (snapshot["listStreamKeys"] as? Snapshot).flatMap { ListStreamKey(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listStreamKeys")
      }
    }

    public struct ListStreamKey: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelStreamKeyConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelStreamKeyConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["StreamKey"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("streamKey", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var streamKey: String? {
          get {
            return snapshot["streamKey"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "streamKey")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetCommentQuery: GraphQLQuery {
  public static let operationString =
    "query GetComment($id: ID!) {\n  getComment(id: $id) {\n    __typename\n    id\n    body\n    timestamp\n    responses\n    videoID\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getComment", arguments: ["id": GraphQLVariable("id")], type: .object(GetComment.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getComment: GetComment? = nil) {
      self.init(snapshot: ["__typename": "Query", "getComment": getComment.flatMap { $0.snapshot }])
    }

    public var getComment: GetComment? {
      get {
        return (snapshot["getComment"] as? Snapshot).flatMap { GetComment(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getComment")
      }
    }

    public struct GetComment: GraphQLSelectionSet {
      public static let possibleTypes = ["Comment"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("body", type: .scalar(String.self)),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("responses", type: .list(.scalar(String.self))),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Comment", "id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var body: String? {
        get {
          return snapshot["body"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "body")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var responses: [String?]? {
        get {
          return snapshot["responses"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "responses")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class ListCommentsQuery: GraphQLQuery {
  public static let operationString =
    "query ListComments($filter: ModelCommentFilterInput, $limit: Int, $nextToken: String) {\n  listComments(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      body\n      timestamp\n      responses\n      videoID\n      userID\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelCommentFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelCommentFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listComments", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListComment.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listComments: ListComment? = nil) {
      self.init(snapshot: ["__typename": "Query", "listComments": listComments.flatMap { $0.snapshot }])
    }

    public var listComments: ListComment? {
      get {
        return (snapshot["listComments"] as? Snapshot).flatMap { ListComment(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listComments")
      }
    }

    public struct ListComment: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelCommentConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelCommentConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Comment"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("body", type: .scalar(String.self)),
          GraphQLField("timestamp", type: .scalar(String.self)),
          GraphQLField("responses", type: .list(.scalar(String.self))),
          GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID, userId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Comment", "id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var body: String? {
          get {
            return snapshot["body"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }

        public var timestamp: String? {
          get {
            return snapshot["timestamp"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "timestamp")
          }
        }

        public var responses: [String?]? {
          get {
            return snapshot["responses"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "responses")
          }
        }

        public var videoId: GraphQLID {
          get {
            return snapshot["videoID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "videoID")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class CommentsByVideoIdQuery: GraphQLQuery {
  public static let operationString =
    "query CommentsByVideoID($videoID: ID!, $sortDirection: ModelSortDirection, $filter: ModelCommentFilterInput, $limit: Int, $nextToken: String) {\n  commentsByVideoID(\n    videoID: $videoID\n    sortDirection: $sortDirection\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      body\n      timestamp\n      responses\n      videoID\n      userID\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var videoID: GraphQLID
  public var sortDirection: ModelSortDirection?
  public var filter: ModelCommentFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(videoID: GraphQLID, sortDirection: ModelSortDirection? = nil, filter: ModelCommentFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.videoID = videoID
    self.sortDirection = sortDirection
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["videoID": videoID, "sortDirection": sortDirection, "filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("commentsByVideoID", arguments: ["videoID": GraphQLVariable("videoID"), "sortDirection": GraphQLVariable("sortDirection"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(CommentsByVideoId.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(commentsByVideoId: CommentsByVideoId? = nil) {
      self.init(snapshot: ["__typename": "Query", "commentsByVideoID": commentsByVideoId.flatMap { $0.snapshot }])
    }

    public var commentsByVideoId: CommentsByVideoId? {
      get {
        return (snapshot["commentsByVideoID"] as? Snapshot).flatMap { CommentsByVideoId(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "commentsByVideoID")
      }
    }

    public struct CommentsByVideoId: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelCommentConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelCommentConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Comment"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("body", type: .scalar(String.self)),
          GraphQLField("timestamp", type: .scalar(String.self)),
          GraphQLField("responses", type: .list(.scalar(String.self))),
          GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID, userId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Comment", "id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var body: String? {
          get {
            return snapshot["body"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }

        public var timestamp: String? {
          get {
            return snapshot["timestamp"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "timestamp")
          }
        }

        public var responses: [String?]? {
          get {
            return snapshot["responses"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "responses")
          }
        }

        public var videoId: GraphQLID {
          get {
            return snapshot["videoID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "videoID")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class CommentsByUserIdQuery: GraphQLQuery {
  public static let operationString =
    "query CommentsByUserID($userID: ID!, $sortDirection: ModelSortDirection, $filter: ModelCommentFilterInput, $limit: Int, $nextToken: String) {\n  commentsByUserID(\n    userID: $userID\n    sortDirection: $sortDirection\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      body\n      timestamp\n      responses\n      videoID\n      userID\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var userID: GraphQLID
  public var sortDirection: ModelSortDirection?
  public var filter: ModelCommentFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(userID: GraphQLID, sortDirection: ModelSortDirection? = nil, filter: ModelCommentFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.userID = userID
    self.sortDirection = sortDirection
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["userID": userID, "sortDirection": sortDirection, "filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("commentsByUserID", arguments: ["userID": GraphQLVariable("userID"), "sortDirection": GraphQLVariable("sortDirection"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(CommentsByUserId.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(commentsByUserId: CommentsByUserId? = nil) {
      self.init(snapshot: ["__typename": "Query", "commentsByUserID": commentsByUserId.flatMap { $0.snapshot }])
    }

    public var commentsByUserId: CommentsByUserId? {
      get {
        return (snapshot["commentsByUserID"] as? Snapshot).flatMap { CommentsByUserId(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "commentsByUserID")
      }
    }

    public struct CommentsByUserId: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelCommentConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelCommentConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Comment"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("body", type: .scalar(String.self)),
          GraphQLField("timestamp", type: .scalar(String.self)),
          GraphQLField("responses", type: .list(.scalar(String.self))),
          GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID, userId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Comment", "id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var body: String? {
          get {
            return snapshot["body"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "body")
          }
        }

        public var timestamp: String? {
          get {
            return snapshot["timestamp"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "timestamp")
          }
        }

        public var responses: [String?]? {
          get {
            return snapshot["responses"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "responses")
          }
        }

        public var videoId: GraphQLID {
          get {
            return snapshot["videoID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "videoID")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetFollowerQuery: GraphQLQuery {
  public static let operationString =
    "query GetFollower($id: ID!) {\n  getFollower(id: $id) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getFollower", arguments: ["id": GraphQLVariable("id")], type: .object(GetFollower.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getFollower: GetFollower? = nil) {
      self.init(snapshot: ["__typename": "Query", "getFollower": getFollower.flatMap { $0.snapshot }])
    }

    public var getFollower: GetFollower? {
      get {
        return (snapshot["getFollower"] as? Snapshot).flatMap { GetFollower(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getFollower")
      }
    }

    public struct GetFollower: GraphQLSelectionSet {
      public static let possibleTypes = ["Follower"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Follower", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class ListFollowersQuery: GraphQLQuery {
  public static let operationString =
    "query ListFollowers($filter: ModelFollowerFilterInput, $limit: Int, $nextToken: String) {\n  listFollowers(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      timestamp\n      userID\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelFollowerFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelFollowerFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listFollowers", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListFollower.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listFollowers: ListFollower? = nil) {
      self.init(snapshot: ["__typename": "Query", "listFollowers": listFollowers.flatMap { $0.snapshot }])
    }

    public var listFollowers: ListFollower? {
      get {
        return (snapshot["listFollowers"] as? Snapshot).flatMap { ListFollower(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listFollowers")
      }
    }

    public struct ListFollower: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelFollowerConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelFollowerConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Follower"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("timestamp", type: .scalar(String.self)),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Follower", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var timestamp: String? {
          get {
            return snapshot["timestamp"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "timestamp")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class FollowersByUserIdQuery: GraphQLQuery {
  public static let operationString =
    "query FollowersByUserID($userID: ID!, $sortDirection: ModelSortDirection, $filter: ModelFollowerFilterInput, $limit: Int, $nextToken: String) {\n  followersByUserID(\n    userID: $userID\n    sortDirection: $sortDirection\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      timestamp\n      userID\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var userID: GraphQLID
  public var sortDirection: ModelSortDirection?
  public var filter: ModelFollowerFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(userID: GraphQLID, sortDirection: ModelSortDirection? = nil, filter: ModelFollowerFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.userID = userID
    self.sortDirection = sortDirection
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["userID": userID, "sortDirection": sortDirection, "filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("followersByUserID", arguments: ["userID": GraphQLVariable("userID"), "sortDirection": GraphQLVariable("sortDirection"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(FollowersByUserId.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(followersByUserId: FollowersByUserId? = nil) {
      self.init(snapshot: ["__typename": "Query", "followersByUserID": followersByUserId.flatMap { $0.snapshot }])
    }

    public var followersByUserId: FollowersByUserId? {
      get {
        return (snapshot["followersByUserID"] as? Snapshot).flatMap { FollowersByUserId(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "followersByUserID")
      }
    }

    public struct FollowersByUserId: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelFollowerConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelFollowerConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Follower"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("timestamp", type: .scalar(String.self)),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Follower", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var timestamp: String? {
          get {
            return snapshot["timestamp"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "timestamp")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetVideoQuery: GraphQLQuery {
  public static let operationString =
    "query GetVideo($id: ID!) {\n  getVideo(id: $id) {\n    __typename\n    id\n    description\n    title\n    views\n    votes\n    userID\n    Comments {\n      __typename\n      nextToken\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getVideo", arguments: ["id": GraphQLVariable("id")], type: .object(GetVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getVideo: GetVideo? = nil) {
      self.init(snapshot: ["__typename": "Query", "getVideo": getVideo.flatMap { $0.snapshot }])
    }

    public var getVideo: GetVideo? {
      get {
        return (snapshot["getVideo"] as? Snapshot).flatMap { GetVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getVideo")
      }
    }

    public struct GetVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("views", type: .nonNull(.scalar(Int.self))),
        GraphQLField("votes", type: .nonNull(.scalar(Int.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, title: String, views: Int, votes: Int, userId: GraphQLID, comments: Comment? = nil, reactions: Reaction? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Video", "id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId, "Comments": comments.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var views: Int {
        get {
          return snapshot["views"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "views")
        }
      }

      public var votes: Int {
        get {
          return snapshot["votes"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "votes")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class ListVideosQuery: GraphQLQuery {
  public static let operationString =
    "query ListVideos($filter: ModelVideoFilterInput, $limit: Int, $nextToken: String) {\n  listVideos(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      description\n      title\n      views\n      votes\n      userID\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelVideoFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelVideoFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listVideos", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listVideos: ListVideo? = nil) {
      self.init(snapshot: ["__typename": "Query", "listVideos": listVideos.flatMap { $0.snapshot }])
    }

    public var listVideos: ListVideo? {
      get {
        return (snapshot["listVideos"] as? Snapshot).flatMap { ListVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listVideos")
      }
    }

    public struct ListVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelVideoConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Video"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("views", type: .nonNull(.scalar(Int.self))),
          GraphQLField("votes", type: .nonNull(.scalar(Int.self))),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, description: String, title: String, views: Int, votes: Int, userId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Video", "id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var description: String {
          get {
            return snapshot["description"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var views: Int {
          get {
            return snapshot["views"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "views")
          }
        }

        public var votes: Int {
          get {
            return snapshot["votes"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "votes")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class VideosByUserIdQuery: GraphQLQuery {
  public static let operationString =
    "query VideosByUserID($userID: ID!, $sortDirection: ModelSortDirection, $filter: ModelVideoFilterInput, $limit: Int, $nextToken: String) {\n  videosByUserID(\n    userID: $userID\n    sortDirection: $sortDirection\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      description\n      title\n      views\n      votes\n      userID\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var userID: GraphQLID
  public var sortDirection: ModelSortDirection?
  public var filter: ModelVideoFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(userID: GraphQLID, sortDirection: ModelSortDirection? = nil, filter: ModelVideoFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.userID = userID
    self.sortDirection = sortDirection
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["userID": userID, "sortDirection": sortDirection, "filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("videosByUserID", arguments: ["userID": GraphQLVariable("userID"), "sortDirection": GraphQLVariable("sortDirection"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(VideosByUserId.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(videosByUserId: VideosByUserId? = nil) {
      self.init(snapshot: ["__typename": "Query", "videosByUserID": videosByUserId.flatMap { $0.snapshot }])
    }

    public var videosByUserId: VideosByUserId? {
      get {
        return (snapshot["videosByUserID"] as? Snapshot).flatMap { VideosByUserId(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "videosByUserID")
      }
    }

    public struct VideosByUserId: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelVideoConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelVideoConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Video"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("views", type: .nonNull(.scalar(Int.self))),
          GraphQLField("votes", type: .nonNull(.scalar(Int.self))),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, description: String, title: String, views: Int, votes: Int, userId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Video", "id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var description: String {
          get {
            return snapshot["description"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "description")
          }
        }

        public var title: String {
          get {
            return snapshot["title"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "title")
          }
        }

        public var views: Int {
          get {
            return snapshot["views"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "views")
          }
        }

        public var votes: Int {
          get {
            return snapshot["votes"]! as! Int
          }
          set {
            snapshot.updateValue(newValue, forKey: "votes")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetFollowingQuery: GraphQLQuery {
  public static let operationString =
    "query GetFollowing($id: ID!) {\n  getFollowing(id: $id) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getFollowing", arguments: ["id": GraphQLVariable("id")], type: .object(GetFollowing.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getFollowing: GetFollowing? = nil) {
      self.init(snapshot: ["__typename": "Query", "getFollowing": getFollowing.flatMap { $0.snapshot }])
    }

    public var getFollowing: GetFollowing? {
      get {
        return (snapshot["getFollowing"] as? Snapshot).flatMap { GetFollowing(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getFollowing")
      }
    }

    public struct GetFollowing: GraphQLSelectionSet {
      public static let possibleTypes = ["Following"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Following", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class ListFollowingsQuery: GraphQLQuery {
  public static let operationString =
    "query ListFollowings($filter: ModelFollowingFilterInput, $limit: Int, $nextToken: String) {\n  listFollowings(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      timestamp\n      userID\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var filter: ModelFollowingFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelFollowingFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listFollowings", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListFollowing.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listFollowings: ListFollowing? = nil) {
      self.init(snapshot: ["__typename": "Query", "listFollowings": listFollowings.flatMap { $0.snapshot }])
    }

    public var listFollowings: ListFollowing? {
      get {
        return (snapshot["listFollowings"] as? Snapshot).flatMap { ListFollowing(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listFollowings")
      }
    }

    public struct ListFollowing: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelFollowingConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelFollowingConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Following"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("timestamp", type: .scalar(String.self)),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Following", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var timestamp: String? {
          get {
            return snapshot["timestamp"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "timestamp")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class FollowingsByUserIdQuery: GraphQLQuery {
  public static let operationString =
    "query FollowingsByUserID($userID: ID!, $sortDirection: ModelSortDirection, $filter: ModelFollowingFilterInput, $limit: Int, $nextToken: String) {\n  followingsByUserID(\n    userID: $userID\n    sortDirection: $sortDirection\n    filter: $filter\n    limit: $limit\n    nextToken: $nextToken\n  ) {\n    __typename\n    items {\n      __typename\n      id\n      timestamp\n      userID\n      createdAt\n      updatedAt\n    }\n    nextToken\n  }\n}"

  public var userID: GraphQLID
  public var sortDirection: ModelSortDirection?
  public var filter: ModelFollowingFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(userID: GraphQLID, sortDirection: ModelSortDirection? = nil, filter: ModelFollowingFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.userID = userID
    self.sortDirection = sortDirection
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["userID": userID, "sortDirection": sortDirection, "filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("followingsByUserID", arguments: ["userID": GraphQLVariable("userID"), "sortDirection": GraphQLVariable("sortDirection"), "filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(FollowingsByUserId.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(followingsByUserId: FollowingsByUserId? = nil) {
      self.init(snapshot: ["__typename": "Query", "followingsByUserID": followingsByUserId.flatMap { $0.snapshot }])
    }

    public var followingsByUserId: FollowingsByUserId? {
      get {
        return (snapshot["followingsByUserID"] as? Snapshot).flatMap { FollowingsByUserId(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "followingsByUserID")
      }
    }

    public struct FollowingsByUserId: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelFollowingConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelFollowingConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["Following"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("timestamp", type: .scalar(String.self)),
          GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "Following", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var timestamp: String? {
          get {
            return snapshot["timestamp"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "timestamp")
          }
        }

        public var userId: GraphQLID {
          get {
            return snapshot["userID"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userID")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }
    }
  }
}

public final class GetUserQuery: GraphQLQuery {
  public static let operationString =
    "query GetUser($id: ID!) {\n  getUser(id: $id) {\n    __typename\n    id\n    name\n    bio\n    birthdate\n    live\n    picture\n    userType\n    username\n    verified\n    following\n    followers\n    savedVideos\n    FollowingUsers {\n      __typename\n      nextToken\n    }\n    Videos {\n      __typename\n      nextToken\n    }\n    Followers {\n      __typename\n      nextToken\n    }\n    Comments {\n      __typename\n      nextToken\n    }\n    UserStreamKey {\n      __typename\n      id\n      streamKey\n      createdAt\n      updatedAt\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    bioLink\n    createdAt\n    updatedAt\n    userUserStreamKeyId\n  }\n}"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getUser", arguments: ["id": GraphQLVariable("id")], type: .object(GetUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getUser: GetUser? = nil) {
      self.init(snapshot: ["__typename": "Query", "getUser": getUser.flatMap { $0.snapshot }])
    }

    public var getUser: GetUser? {
      get {
        return (snapshot["getUser"] as? Snapshot).flatMap { GetUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "getUser")
      }
    }

    public struct GetUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("bio", type: .nonNull(.scalar(String.self))),
        GraphQLField("birthdate", type: .nonNull(.scalar(String.self))),
        GraphQLField("live", type: .scalar(Bool.self)),
        GraphQLField("picture", type: .scalar(String.self)),
        GraphQLField("userType", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("verified", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("following", type: .list(.scalar(String.self))),
        GraphQLField("followers", type: .list(.scalar(String.self))),
        GraphQLField("savedVideos", type: .list(.scalar(String.self))),
        GraphQLField("FollowingUsers", type: .object(FollowingUser.selections)),
        GraphQLField("Videos", type: .object(Video.selections)),
        GraphQLField("Followers", type: .object(Follower.selections)),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("UserStreamKey", type: .object(UserStreamKey.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("bioLink", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("userUserStreamKeyId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, bio: String, birthdate: String, live: Bool? = nil, picture: String? = nil, userType: String, username: String, verified: Bool, following: [String?]? = nil, followers: [String?]? = nil, savedVideos: [String?]? = nil, followingUsers: FollowingUser? = nil, videos: Video? = nil, followers: Follower? = nil, comments: Comment? = nil, userStreamKey: UserStreamKey? = nil, reactions: Reaction? = nil, bioLink: String? = nil, createdAt: String, updatedAt: String, userUserStreamKeyId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "FollowingUsers": followingUsers.flatMap { $0.snapshot }, "Videos": videos.flatMap { $0.snapshot }, "Followers": followers.flatMap { $0.snapshot }, "Comments": comments.flatMap { $0.snapshot }, "UserStreamKey": userStreamKey.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "bioLink": bioLink, "createdAt": createdAt, "updatedAt": updatedAt, "userUserStreamKeyId": userUserStreamKeyId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var bio: String {
        get {
          return snapshot["bio"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bio")
        }
      }

      public var birthdate: String {
        get {
          return snapshot["birthdate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "birthdate")
        }
      }

      public var live: Bool? {
        get {
          return snapshot["live"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "live")
        }
      }

      public var picture: String? {
        get {
          return snapshot["picture"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "picture")
        }
      }

      public var userType: String {
        get {
          return snapshot["userType"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "userType")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var verified: Bool {
        get {
          return snapshot["verified"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "verified")
        }
      }

      public var following: [String?]? {
        get {
          return snapshot["following"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "following")
        }
      }

      public var followers: [String?]? {
        get {
          return snapshot["followers"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "followers")
        }
      }

      public var savedVideos: [String?]? {
        get {
          return snapshot["savedVideos"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "savedVideos")
        }
      }

      public var followingUsers: FollowingUser? {
        get {
          return (snapshot["FollowingUsers"] as? Snapshot).flatMap { FollowingUser(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "FollowingUsers")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["Videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Videos")
        }
      }

      public var followers: Follower? {
        get {
          return (snapshot["Followers"] as? Snapshot).flatMap { Follower(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Followers")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var userStreamKey: UserStreamKey? {
        get {
          return (snapshot["UserStreamKey"] as? Snapshot).flatMap { UserStreamKey(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "UserStreamKey")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var bioLink: String? {
        get {
          return snapshot["bioLink"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bioLink")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var userUserStreamKeyId: GraphQLID? {
        get {
          return snapshot["userUserStreamKeyId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userUserStreamKeyId")
        }
      }

      public struct FollowingUser: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Follower: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowerConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowerConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct UserStreamKey: GraphQLSelectionSet {
        public static let possibleTypes = ["StreamKey"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("streamKey", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var streamKey: String? {
          get {
            return snapshot["streamKey"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "streamKey")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class ListUsersQuery: GraphQLQuery {
  public static let operationString =
    "query ListUsers($filter: ModelUserFilterInput, $limit: Int, $nextToken: String) {\n  listUsers(filter: $filter, limit: $limit, nextToken: $nextToken) {\n    __typename\n    items {\n      __typename\n      id\n      name\n      bio\n      birthdate\n      live\n      picture\n      userType\n      username\n      verified\n      following\n      followers\n      savedVideos\n      bioLink\n      createdAt\n      updatedAt\n      userUserStreamKeyId\n    }\n    nextToken\n  }\n}"

  public var filter: ModelUserFilterInput?
  public var limit: Int?
  public var nextToken: String?

  public init(filter: ModelUserFilterInput? = nil, limit: Int? = nil, nextToken: String? = nil) {
    self.filter = filter
    self.limit = limit
    self.nextToken = nextToken
  }

  public var variables: GraphQLMap? {
    return ["filter": filter, "limit": limit, "nextToken": nextToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("listUsers", arguments: ["filter": GraphQLVariable("filter"), "limit": GraphQLVariable("limit"), "nextToken": GraphQLVariable("nextToken")], type: .object(ListUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(listUsers: ListUser? = nil) {
      self.init(snapshot: ["__typename": "Query", "listUsers": listUsers.flatMap { $0.snapshot }])
    }

    public var listUsers: ListUser? {
      get {
        return (snapshot["listUsers"] as? Snapshot).flatMap { ListUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "listUsers")
      }
    }

    public struct ListUser: GraphQLSelectionSet {
      public static let possibleTypes = ["ModelUserConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("items", type: .nonNull(.list(.object(Item.selections)))),
        GraphQLField("nextToken", type: .scalar(String.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(items: [Item?], nextToken: String? = nil) {
        self.init(snapshot: ["__typename": "ModelUserConnection", "items": items.map { $0.flatMap { $0.snapshot } }, "nextToken": nextToken])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var items: [Item?] {
        get {
          return (snapshot["items"] as! [Snapshot?]).map { $0.flatMap { Item(snapshot: $0) } }
        }
        set {
          snapshot.updateValue(newValue.map { $0.flatMap { $0.snapshot } }, forKey: "items")
        }
      }

      public var nextToken: String? {
        get {
          return snapshot["nextToken"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "nextToken")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("bio", type: .nonNull(.scalar(String.self))),
          GraphQLField("birthdate", type: .nonNull(.scalar(String.self))),
          GraphQLField("live", type: .scalar(Bool.self)),
          GraphQLField("picture", type: .scalar(String.self)),
          GraphQLField("userType", type: .nonNull(.scalar(String.self))),
          GraphQLField("username", type: .nonNull(.scalar(String.self))),
          GraphQLField("verified", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("following", type: .list(.scalar(String.self))),
          GraphQLField("followers", type: .list(.scalar(String.self))),
          GraphQLField("savedVideos", type: .list(.scalar(String.self))),
          GraphQLField("bioLink", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("userUserStreamKeyId", type: .scalar(GraphQLID.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, name: String, bio: String, birthdate: String, live: Bool? = nil, picture: String? = nil, userType: String, username: String, verified: Bool, following: [String?]? = nil, followers: [String?]? = nil, savedVideos: [String?]? = nil, bioLink: String? = nil, createdAt: String, updatedAt: String, userUserStreamKeyId: GraphQLID? = nil) {
          self.init(snapshot: ["__typename": "User", "id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "bioLink": bioLink, "createdAt": createdAt, "updatedAt": updatedAt, "userUserStreamKeyId": userUserStreamKeyId])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return snapshot["name"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "name")
          }
        }

        public var bio: String {
          get {
            return snapshot["bio"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "bio")
          }
        }

        public var birthdate: String {
          get {
            return snapshot["birthdate"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "birthdate")
          }
        }

        public var live: Bool? {
          get {
            return snapshot["live"] as? Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "live")
          }
        }

        public var picture: String? {
          get {
            return snapshot["picture"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "picture")
          }
        }

        public var userType: String {
          get {
            return snapshot["userType"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "userType")
          }
        }

        public var username: String {
          get {
            return snapshot["username"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "username")
          }
        }

        public var verified: Bool {
          get {
            return snapshot["verified"]! as! Bool
          }
          set {
            snapshot.updateValue(newValue, forKey: "verified")
          }
        }

        public var following: [String?]? {
          get {
            return snapshot["following"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "following")
          }
        }

        public var followers: [String?]? {
          get {
            return snapshot["followers"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "followers")
          }
        }

        public var savedVideos: [String?]? {
          get {
            return snapshot["savedVideos"] as? [String?]
          }
          set {
            snapshot.updateValue(newValue, forKey: "savedVideos")
          }
        }

        public var bioLink: String? {
          get {
            return snapshot["bioLink"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "bioLink")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }

        public var userUserStreamKeyId: GraphQLID? {
          get {
            return snapshot["userUserStreamKeyId"] as? GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "userUserStreamKeyId")
          }
        }
      }
    }
  }
}

public final class OnCreateConversationSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateConversation($filter: ModelSubscriptionConversationFilterInput) {\n  onCreateConversation(filter: $filter) {\n    __typename\n    id\n    messages {\n      __typename\n      nextToken\n    }\n    participants\n    lastMessageID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionConversationFilterInput?

  public init(filter: ModelSubscriptionConversationFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateConversation", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateConversation: OnCreateConversation? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateConversation": onCreateConversation.flatMap { $0.snapshot }])
    }

    public var onCreateConversation: OnCreateConversation? {
      get {
        return (snapshot["onCreateConversation"] as? Snapshot).flatMap { OnCreateConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateConversation")
      }
    }

    public struct OnCreateConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("messages", type: .object(Message.selections)),
        GraphQLField("participants", type: .list(.scalar(String.self))),
        GraphQLField("lastMessageID", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, messages: Message? = nil, participants: [String?]? = nil, lastMessageId: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Conversation", "id": id, "messages": messages.flatMap { $0.snapshot }, "participants": participants, "lastMessageID": lastMessageId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var messages: Message? {
        get {
          return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "messages")
        }
      }

      public var participants: [String?]? {
        get {
          return snapshot["participants"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "participants")
        }
      }

      public var lastMessageId: String? {
        get {
          return snapshot["lastMessageID"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastMessageID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelMessageConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelMessageConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnUpdateConversationSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateConversation($filter: ModelSubscriptionConversationFilterInput) {\n  onUpdateConversation(filter: $filter) {\n    __typename\n    id\n    messages {\n      __typename\n      nextToken\n    }\n    participants\n    lastMessageID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionConversationFilterInput?

  public init(filter: ModelSubscriptionConversationFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateConversation", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateConversation: OnUpdateConversation? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateConversation": onUpdateConversation.flatMap { $0.snapshot }])
    }

    public var onUpdateConversation: OnUpdateConversation? {
      get {
        return (snapshot["onUpdateConversation"] as? Snapshot).flatMap { OnUpdateConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateConversation")
      }
    }

    public struct OnUpdateConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("messages", type: .object(Message.selections)),
        GraphQLField("participants", type: .list(.scalar(String.self))),
        GraphQLField("lastMessageID", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, messages: Message? = nil, participants: [String?]? = nil, lastMessageId: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Conversation", "id": id, "messages": messages.flatMap { $0.snapshot }, "participants": participants, "lastMessageID": lastMessageId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var messages: Message? {
        get {
          return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "messages")
        }
      }

      public var participants: [String?]? {
        get {
          return snapshot["participants"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "participants")
        }
      }

      public var lastMessageId: String? {
        get {
          return snapshot["lastMessageID"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastMessageID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelMessageConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelMessageConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnDeleteConversationSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteConversation($filter: ModelSubscriptionConversationFilterInput) {\n  onDeleteConversation(filter: $filter) {\n    __typename\n    id\n    messages {\n      __typename\n      nextToken\n    }\n    participants\n    lastMessageID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionConversationFilterInput?

  public init(filter: ModelSubscriptionConversationFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteConversation", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteConversation.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteConversation: OnDeleteConversation? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteConversation": onDeleteConversation.flatMap { $0.snapshot }])
    }

    public var onDeleteConversation: OnDeleteConversation? {
      get {
        return (snapshot["onDeleteConversation"] as? Snapshot).flatMap { OnDeleteConversation(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteConversation")
      }
    }

    public struct OnDeleteConversation: GraphQLSelectionSet {
      public static let possibleTypes = ["Conversation"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("messages", type: .object(Message.selections)),
        GraphQLField("participants", type: .list(.scalar(String.self))),
        GraphQLField("lastMessageID", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, messages: Message? = nil, participants: [String?]? = nil, lastMessageId: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Conversation", "id": id, "messages": messages.flatMap { $0.snapshot }, "participants": participants, "lastMessageID": lastMessageId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var messages: Message? {
        get {
          return (snapshot["messages"] as? Snapshot).flatMap { Message(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "messages")
        }
      }

      public var participants: [String?]? {
        get {
          return snapshot["participants"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "participants")
        }
      }

      public var lastMessageId: String? {
        get {
          return snapshot["lastMessageID"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "lastMessageID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelMessageConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelMessageConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnCreateMessageSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateMessage($filter: ModelSubscriptionMessageFilterInput) {\n  onCreateMessage(filter: $filter) {\n    __typename\n    id\n    content\n    createdAt\n    sender\n    conversationID\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionMessageFilterInput?

  public init(filter: ModelSubscriptionMessageFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateMessage", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateMessage: OnCreateMessage? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateMessage": onCreateMessage.flatMap { $0.snapshot }])
    }

    public var onCreateMessage: OnCreateMessage? {
      get {
        return (snapshot["onCreateMessage"] as? Snapshot).flatMap { OnCreateMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateMessage")
      }
    }

    public struct OnCreateMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("sender", type: .scalar(String.self)),
        GraphQLField("conversationID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, createdAt: String? = nil, sender: String? = nil, conversationId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var sender: String? {
        get {
          return snapshot["sender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnUpdateMessageSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateMessage($filter: ModelSubscriptionMessageFilterInput) {\n  onUpdateMessage(filter: $filter) {\n    __typename\n    id\n    content\n    createdAt\n    sender\n    conversationID\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionMessageFilterInput?

  public init(filter: ModelSubscriptionMessageFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateMessage", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateMessage: OnUpdateMessage? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateMessage": onUpdateMessage.flatMap { $0.snapshot }])
    }

    public var onUpdateMessage: OnUpdateMessage? {
      get {
        return (snapshot["onUpdateMessage"] as? Snapshot).flatMap { OnUpdateMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateMessage")
      }
    }

    public struct OnUpdateMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("sender", type: .scalar(String.self)),
        GraphQLField("conversationID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, createdAt: String? = nil, sender: String? = nil, conversationId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var sender: String? {
        get {
          return snapshot["sender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnDeleteMessageSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteMessage($filter: ModelSubscriptionMessageFilterInput) {\n  onDeleteMessage(filter: $filter) {\n    __typename\n    id\n    content\n    createdAt\n    sender\n    conversationID\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionMessageFilterInput?

  public init(filter: ModelSubscriptionMessageFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteMessage", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteMessage: OnDeleteMessage? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteMessage": onDeleteMessage.flatMap { $0.snapshot }])
    }

    public var onDeleteMessage: OnDeleteMessage? {
      get {
        return (snapshot["onDeleteMessage"] as? Snapshot).flatMap { OnDeleteMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteMessage")
      }
    }

    public struct OnDeleteMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("sender", type: .scalar(String.self)),
        GraphQLField("conversationID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, createdAt: String? = nil, sender: String? = nil, conversationId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "createdAt": createdAt, "sender": sender, "conversationID": conversationId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var sender: String? {
        get {
          return snapshot["sender"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }

      public var conversationId: GraphQLID {
        get {
          return snapshot["conversationID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "conversationID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnCreateReactionSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateReaction($filter: ModelSubscriptionReactionFilterInput) {\n  onCreateReaction(filter: $filter) {\n    __typename\n    id\n    action\n    createdAt\n    videoID\n    userID\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionReactionFilterInput?

  public init(filter: ModelSubscriptionReactionFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateReaction", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateReaction.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateReaction: OnCreateReaction? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateReaction": onCreateReaction.flatMap { $0.snapshot }])
    }

    public var onCreateReaction: OnCreateReaction? {
      get {
        return (snapshot["onCreateReaction"] as? Snapshot).flatMap { OnCreateReaction(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateReaction")
      }
    }

    public struct OnCreateReaction: GraphQLSelectionSet {
      public static let possibleTypes = ["Reaction"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("action", type: .scalar(ReactionType.self)),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID, userId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Reaction", "id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var action: ReactionType? {
        get {
          return snapshot["action"] as? ReactionType
        }
        set {
          snapshot.updateValue(newValue, forKey: "action")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnUpdateReactionSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateReaction($filter: ModelSubscriptionReactionFilterInput) {\n  onUpdateReaction(filter: $filter) {\n    __typename\n    id\n    action\n    createdAt\n    videoID\n    userID\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionReactionFilterInput?

  public init(filter: ModelSubscriptionReactionFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateReaction", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateReaction.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateReaction: OnUpdateReaction? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateReaction": onUpdateReaction.flatMap { $0.snapshot }])
    }

    public var onUpdateReaction: OnUpdateReaction? {
      get {
        return (snapshot["onUpdateReaction"] as? Snapshot).flatMap { OnUpdateReaction(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateReaction")
      }
    }

    public struct OnUpdateReaction: GraphQLSelectionSet {
      public static let possibleTypes = ["Reaction"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("action", type: .scalar(ReactionType.self)),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID, userId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Reaction", "id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var action: ReactionType? {
        get {
          return snapshot["action"] as? ReactionType
        }
        set {
          snapshot.updateValue(newValue, forKey: "action")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnDeleteReactionSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteReaction($filter: ModelSubscriptionReactionFilterInput) {\n  onDeleteReaction(filter: $filter) {\n    __typename\n    id\n    action\n    createdAt\n    videoID\n    userID\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionReactionFilterInput?

  public init(filter: ModelSubscriptionReactionFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteReaction", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteReaction.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteReaction: OnDeleteReaction? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteReaction": onDeleteReaction.flatMap { $0.snapshot }])
    }

    public var onDeleteReaction: OnDeleteReaction? {
      get {
        return (snapshot["onDeleteReaction"] as? Snapshot).flatMap { OnDeleteReaction(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteReaction")
      }
    }

    public struct OnDeleteReaction: GraphQLSelectionSet {
      public static let possibleTypes = ["Reaction"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("action", type: .scalar(ReactionType.self)),
        GraphQLField("createdAt", type: .scalar(String.self)),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, action: ReactionType? = nil, createdAt: String? = nil, videoId: GraphQLID, userId: GraphQLID, updatedAt: String) {
        self.init(snapshot: ["__typename": "Reaction", "id": id, "action": action, "createdAt": createdAt, "videoID": videoId, "userID": userId, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var action: ReactionType? {
        get {
          return snapshot["action"] as? ReactionType
        }
        set {
          snapshot.updateValue(newValue, forKey: "action")
        }
      }

      public var createdAt: String? {
        get {
          return snapshot["createdAt"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnCreateStreamKeySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateStreamKey($filter: ModelSubscriptionStreamKeyFilterInput) {\n  onCreateStreamKey(filter: $filter) {\n    __typename\n    id\n    streamKey\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionStreamKeyFilterInput?

  public init(filter: ModelSubscriptionStreamKeyFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateStreamKey", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateStreamKey.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateStreamKey: OnCreateStreamKey? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateStreamKey": onCreateStreamKey.flatMap { $0.snapshot }])
    }

    public var onCreateStreamKey: OnCreateStreamKey? {
      get {
        return (snapshot["onCreateStreamKey"] as? Snapshot).flatMap { OnCreateStreamKey(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateStreamKey")
      }
    }

    public struct OnCreateStreamKey: GraphQLSelectionSet {
      public static let possibleTypes = ["StreamKey"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("streamKey", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var streamKey: String? {
        get {
          return snapshot["streamKey"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "streamKey")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnUpdateStreamKeySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateStreamKey($filter: ModelSubscriptionStreamKeyFilterInput) {\n  onUpdateStreamKey(filter: $filter) {\n    __typename\n    id\n    streamKey\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionStreamKeyFilterInput?

  public init(filter: ModelSubscriptionStreamKeyFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateStreamKey", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateStreamKey.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateStreamKey: OnUpdateStreamKey? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateStreamKey": onUpdateStreamKey.flatMap { $0.snapshot }])
    }

    public var onUpdateStreamKey: OnUpdateStreamKey? {
      get {
        return (snapshot["onUpdateStreamKey"] as? Snapshot).flatMap { OnUpdateStreamKey(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateStreamKey")
      }
    }

    public struct OnUpdateStreamKey: GraphQLSelectionSet {
      public static let possibleTypes = ["StreamKey"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("streamKey", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var streamKey: String? {
        get {
          return snapshot["streamKey"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "streamKey")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnDeleteStreamKeySubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteStreamKey($filter: ModelSubscriptionStreamKeyFilterInput) {\n  onDeleteStreamKey(filter: $filter) {\n    __typename\n    id\n    streamKey\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionStreamKeyFilterInput?

  public init(filter: ModelSubscriptionStreamKeyFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteStreamKey", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteStreamKey.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteStreamKey: OnDeleteStreamKey? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteStreamKey": onDeleteStreamKey.flatMap { $0.snapshot }])
    }

    public var onDeleteStreamKey: OnDeleteStreamKey? {
      get {
        return (snapshot["onDeleteStreamKey"] as? Snapshot).flatMap { OnDeleteStreamKey(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteStreamKey")
      }
    }

    public struct OnDeleteStreamKey: GraphQLSelectionSet {
      public static let possibleTypes = ["StreamKey"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("streamKey", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var streamKey: String? {
        get {
          return snapshot["streamKey"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "streamKey")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnCreateCommentSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateComment($filter: ModelSubscriptionCommentFilterInput) {\n  onCreateComment(filter: $filter) {\n    __typename\n    id\n    body\n    timestamp\n    responses\n    videoID\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionCommentFilterInput?

  public init(filter: ModelSubscriptionCommentFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateComment", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateComment.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateComment: OnCreateComment? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateComment": onCreateComment.flatMap { $0.snapshot }])
    }

    public var onCreateComment: OnCreateComment? {
      get {
        return (snapshot["onCreateComment"] as? Snapshot).flatMap { OnCreateComment(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateComment")
      }
    }

    public struct OnCreateComment: GraphQLSelectionSet {
      public static let possibleTypes = ["Comment"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("body", type: .scalar(String.self)),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("responses", type: .list(.scalar(String.self))),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Comment", "id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var body: String? {
        get {
          return snapshot["body"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "body")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var responses: [String?]? {
        get {
          return snapshot["responses"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "responses")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnUpdateCommentSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateComment($filter: ModelSubscriptionCommentFilterInput) {\n  onUpdateComment(filter: $filter) {\n    __typename\n    id\n    body\n    timestamp\n    responses\n    videoID\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionCommentFilterInput?

  public init(filter: ModelSubscriptionCommentFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateComment", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateComment.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateComment: OnUpdateComment? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateComment": onUpdateComment.flatMap { $0.snapshot }])
    }

    public var onUpdateComment: OnUpdateComment? {
      get {
        return (snapshot["onUpdateComment"] as? Snapshot).flatMap { OnUpdateComment(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateComment")
      }
    }

    public struct OnUpdateComment: GraphQLSelectionSet {
      public static let possibleTypes = ["Comment"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("body", type: .scalar(String.self)),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("responses", type: .list(.scalar(String.self))),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Comment", "id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var body: String? {
        get {
          return snapshot["body"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "body")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var responses: [String?]? {
        get {
          return snapshot["responses"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "responses")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnDeleteCommentSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteComment($filter: ModelSubscriptionCommentFilterInput) {\n  onDeleteComment(filter: $filter) {\n    __typename\n    id\n    body\n    timestamp\n    responses\n    videoID\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionCommentFilterInput?

  public init(filter: ModelSubscriptionCommentFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteComment", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteComment.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteComment: OnDeleteComment? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteComment": onDeleteComment.flatMap { $0.snapshot }])
    }

    public var onDeleteComment: OnDeleteComment? {
      get {
        return (snapshot["onDeleteComment"] as? Snapshot).flatMap { OnDeleteComment(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteComment")
      }
    }

    public struct OnDeleteComment: GraphQLSelectionSet {
      public static let possibleTypes = ["Comment"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("body", type: .scalar(String.self)),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("responses", type: .list(.scalar(String.self))),
        GraphQLField("videoID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, body: String? = nil, timestamp: String? = nil, responses: [String?]? = nil, videoId: GraphQLID, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Comment", "id": id, "body": body, "timestamp": timestamp, "responses": responses, "videoID": videoId, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var body: String? {
        get {
          return snapshot["body"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "body")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var responses: [String?]? {
        get {
          return snapshot["responses"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "responses")
        }
      }

      public var videoId: GraphQLID {
        get {
          return snapshot["videoID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "videoID")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnCreateFollowerSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateFollower($filter: ModelSubscriptionFollowerFilterInput) {\n  onCreateFollower(filter: $filter) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionFollowerFilterInput?

  public init(filter: ModelSubscriptionFollowerFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateFollower", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateFollower.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateFollower: OnCreateFollower? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateFollower": onCreateFollower.flatMap { $0.snapshot }])
    }

    public var onCreateFollower: OnCreateFollower? {
      get {
        return (snapshot["onCreateFollower"] as? Snapshot).flatMap { OnCreateFollower(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateFollower")
      }
    }

    public struct OnCreateFollower: GraphQLSelectionSet {
      public static let possibleTypes = ["Follower"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Follower", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnUpdateFollowerSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateFollower($filter: ModelSubscriptionFollowerFilterInput) {\n  onUpdateFollower(filter: $filter) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionFollowerFilterInput?

  public init(filter: ModelSubscriptionFollowerFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateFollower", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateFollower.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateFollower: OnUpdateFollower? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateFollower": onUpdateFollower.flatMap { $0.snapshot }])
    }

    public var onUpdateFollower: OnUpdateFollower? {
      get {
        return (snapshot["onUpdateFollower"] as? Snapshot).flatMap { OnUpdateFollower(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateFollower")
      }
    }

    public struct OnUpdateFollower: GraphQLSelectionSet {
      public static let possibleTypes = ["Follower"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Follower", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnDeleteFollowerSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteFollower($filter: ModelSubscriptionFollowerFilterInput) {\n  onDeleteFollower(filter: $filter) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionFollowerFilterInput?

  public init(filter: ModelSubscriptionFollowerFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteFollower", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteFollower.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteFollower: OnDeleteFollower? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteFollower": onDeleteFollower.flatMap { $0.snapshot }])
    }

    public var onDeleteFollower: OnDeleteFollower? {
      get {
        return (snapshot["onDeleteFollower"] as? Snapshot).flatMap { OnDeleteFollower(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteFollower")
      }
    }

    public struct OnDeleteFollower: GraphQLSelectionSet {
      public static let possibleTypes = ["Follower"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Follower", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnCreateVideoSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateVideo($filter: ModelSubscriptionVideoFilterInput) {\n  onCreateVideo(filter: $filter) {\n    __typename\n    id\n    description\n    title\n    views\n    votes\n    userID\n    Comments {\n      __typename\n      nextToken\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionVideoFilterInput?

  public init(filter: ModelSubscriptionVideoFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateVideo", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateVideo: OnCreateVideo? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateVideo": onCreateVideo.flatMap { $0.snapshot }])
    }

    public var onCreateVideo: OnCreateVideo? {
      get {
        return (snapshot["onCreateVideo"] as? Snapshot).flatMap { OnCreateVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateVideo")
      }
    }

    public struct OnCreateVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("views", type: .nonNull(.scalar(Int.self))),
        GraphQLField("votes", type: .nonNull(.scalar(Int.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, title: String, views: Int, votes: Int, userId: GraphQLID, comments: Comment? = nil, reactions: Reaction? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Video", "id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId, "Comments": comments.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var views: Int {
        get {
          return snapshot["views"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "views")
        }
      }

      public var votes: Int {
        get {
          return snapshot["votes"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "votes")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnUpdateVideoSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateVideo($filter: ModelSubscriptionVideoFilterInput) {\n  onUpdateVideo(filter: $filter) {\n    __typename\n    id\n    description\n    title\n    views\n    votes\n    userID\n    Comments {\n      __typename\n      nextToken\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionVideoFilterInput?

  public init(filter: ModelSubscriptionVideoFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateVideo", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateVideo: OnUpdateVideo? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateVideo": onUpdateVideo.flatMap { $0.snapshot }])
    }

    public var onUpdateVideo: OnUpdateVideo? {
      get {
        return (snapshot["onUpdateVideo"] as? Snapshot).flatMap { OnUpdateVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateVideo")
      }
    }

    public struct OnUpdateVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("views", type: .nonNull(.scalar(Int.self))),
        GraphQLField("votes", type: .nonNull(.scalar(Int.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, title: String, views: Int, votes: Int, userId: GraphQLID, comments: Comment? = nil, reactions: Reaction? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Video", "id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId, "Comments": comments.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var views: Int {
        get {
          return snapshot["views"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "views")
        }
      }

      public var votes: Int {
        get {
          return snapshot["votes"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "votes")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnDeleteVideoSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteVideo($filter: ModelSubscriptionVideoFilterInput) {\n  onDeleteVideo(filter: $filter) {\n    __typename\n    id\n    description\n    title\n    views\n    votes\n    userID\n    Comments {\n      __typename\n      nextToken\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionVideoFilterInput?

  public init(filter: ModelSubscriptionVideoFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteVideo", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteVideo.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteVideo: OnDeleteVideo? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteVideo": onDeleteVideo.flatMap { $0.snapshot }])
    }

    public var onDeleteVideo: OnDeleteVideo? {
      get {
        return (snapshot["onDeleteVideo"] as? Snapshot).flatMap { OnDeleteVideo(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteVideo")
      }
    }

    public struct OnDeleteVideo: GraphQLSelectionSet {
      public static let possibleTypes = ["Video"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("description", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("views", type: .nonNull(.scalar(Int.self))),
        GraphQLField("votes", type: .nonNull(.scalar(Int.self))),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, description: String, title: String, views: Int, votes: Int, userId: GraphQLID, comments: Comment? = nil, reactions: Reaction? = nil, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Video", "id": id, "description": description, "title": title, "views": views, "votes": votes, "userID": userId, "Comments": comments.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var description: String {
        get {
          return snapshot["description"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "description")
        }
      }

      public var title: String {
        get {
          return snapshot["title"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "title")
        }
      }

      public var views: Int {
        get {
          return snapshot["views"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "views")
        }
      }

      public var votes: Int {
        get {
          return snapshot["votes"]! as! Int
        }
        set {
          snapshot.updateValue(newValue, forKey: "votes")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnCreateFollowingSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateFollowing($filter: ModelSubscriptionFollowingFilterInput) {\n  onCreateFollowing(filter: $filter) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionFollowingFilterInput?

  public init(filter: ModelSubscriptionFollowingFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateFollowing", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateFollowing.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateFollowing: OnCreateFollowing? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateFollowing": onCreateFollowing.flatMap { $0.snapshot }])
    }

    public var onCreateFollowing: OnCreateFollowing? {
      get {
        return (snapshot["onCreateFollowing"] as? Snapshot).flatMap { OnCreateFollowing(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateFollowing")
      }
    }

    public struct OnCreateFollowing: GraphQLSelectionSet {
      public static let possibleTypes = ["Following"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Following", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnUpdateFollowingSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateFollowing($filter: ModelSubscriptionFollowingFilterInput) {\n  onUpdateFollowing(filter: $filter) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionFollowingFilterInput?

  public init(filter: ModelSubscriptionFollowingFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateFollowing", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateFollowing.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateFollowing: OnUpdateFollowing? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateFollowing": onUpdateFollowing.flatMap { $0.snapshot }])
    }

    public var onUpdateFollowing: OnUpdateFollowing? {
      get {
        return (snapshot["onUpdateFollowing"] as? Snapshot).flatMap { OnUpdateFollowing(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateFollowing")
      }
    }

    public struct OnUpdateFollowing: GraphQLSelectionSet {
      public static let possibleTypes = ["Following"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Following", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnDeleteFollowingSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteFollowing($filter: ModelSubscriptionFollowingFilterInput) {\n  onDeleteFollowing(filter: $filter) {\n    __typename\n    id\n    timestamp\n    userID\n    createdAt\n    updatedAt\n  }\n}"

  public var filter: ModelSubscriptionFollowingFilterInput?

  public init(filter: ModelSubscriptionFollowingFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteFollowing", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteFollowing.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteFollowing: OnDeleteFollowing? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteFollowing": onDeleteFollowing.flatMap { $0.snapshot }])
    }

    public var onDeleteFollowing: OnDeleteFollowing? {
      get {
        return (snapshot["onDeleteFollowing"] as? Snapshot).flatMap { OnDeleteFollowing(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteFollowing")
      }
    }

    public struct OnDeleteFollowing: GraphQLSelectionSet {
      public static let possibleTypes = ["Following"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("timestamp", type: .scalar(String.self)),
        GraphQLField("userID", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, timestamp: String? = nil, userId: GraphQLID, createdAt: String, updatedAt: String) {
        self.init(snapshot: ["__typename": "Following", "id": id, "timestamp": timestamp, "userID": userId, "createdAt": createdAt, "updatedAt": updatedAt])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var timestamp: String? {
        get {
          return snapshot["timestamp"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "timestamp")
        }
      }

      public var userId: GraphQLID {
        get {
          return snapshot["userID"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userID")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }
    }
  }
}

public final class OnCreateUserSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnCreateUser($filter: ModelSubscriptionUserFilterInput) {\n  onCreateUser(filter: $filter) {\n    __typename\n    id\n    name\n    bio\n    birthdate\n    live\n    picture\n    userType\n    username\n    verified\n    following\n    followers\n    savedVideos\n    FollowingUsers {\n      __typename\n      nextToken\n    }\n    Videos {\n      __typename\n      nextToken\n    }\n    Followers {\n      __typename\n      nextToken\n    }\n    Comments {\n      __typename\n      nextToken\n    }\n    UserStreamKey {\n      __typename\n      id\n      streamKey\n      createdAt\n      updatedAt\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    bioLink\n    createdAt\n    updatedAt\n    userUserStreamKeyId\n  }\n}"

  public var filter: ModelSubscriptionUserFilterInput?

  public init(filter: ModelSubscriptionUserFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onCreateUser", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnCreateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onCreateUser: OnCreateUser? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onCreateUser": onCreateUser.flatMap { $0.snapshot }])
    }

    public var onCreateUser: OnCreateUser? {
      get {
        return (snapshot["onCreateUser"] as? Snapshot).flatMap { OnCreateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onCreateUser")
      }
    }

    public struct OnCreateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("bio", type: .nonNull(.scalar(String.self))),
        GraphQLField("birthdate", type: .nonNull(.scalar(String.self))),
        GraphQLField("live", type: .scalar(Bool.self)),
        GraphQLField("picture", type: .scalar(String.self)),
        GraphQLField("userType", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("verified", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("following", type: .list(.scalar(String.self))),
        GraphQLField("followers", type: .list(.scalar(String.self))),
        GraphQLField("savedVideos", type: .list(.scalar(String.self))),
        GraphQLField("FollowingUsers", type: .object(FollowingUser.selections)),
        GraphQLField("Videos", type: .object(Video.selections)),
        GraphQLField("Followers", type: .object(Follower.selections)),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("UserStreamKey", type: .object(UserStreamKey.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("bioLink", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("userUserStreamKeyId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, bio: String, birthdate: String, live: Bool? = nil, picture: String? = nil, userType: String, username: String, verified: Bool, following: [String?]? = nil, followers: [String?]? = nil, savedVideos: [String?]? = nil, followingUsers: FollowingUser? = nil, videos: Video? = nil, followers: Follower? = nil, comments: Comment? = nil, userStreamKey: UserStreamKey? = nil, reactions: Reaction? = nil, bioLink: String? = nil, createdAt: String, updatedAt: String, userUserStreamKeyId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "FollowingUsers": followingUsers.flatMap { $0.snapshot }, "Videos": videos.flatMap { $0.snapshot }, "Followers": followers.flatMap { $0.snapshot }, "Comments": comments.flatMap { $0.snapshot }, "UserStreamKey": userStreamKey.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "bioLink": bioLink, "createdAt": createdAt, "updatedAt": updatedAt, "userUserStreamKeyId": userUserStreamKeyId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var bio: String {
        get {
          return snapshot["bio"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bio")
        }
      }

      public var birthdate: String {
        get {
          return snapshot["birthdate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "birthdate")
        }
      }

      public var live: Bool? {
        get {
          return snapshot["live"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "live")
        }
      }

      public var picture: String? {
        get {
          return snapshot["picture"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "picture")
        }
      }

      public var userType: String {
        get {
          return snapshot["userType"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "userType")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var verified: Bool {
        get {
          return snapshot["verified"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "verified")
        }
      }

      public var following: [String?]? {
        get {
          return snapshot["following"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "following")
        }
      }

      public var followers: [String?]? {
        get {
          return snapshot["followers"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "followers")
        }
      }

      public var savedVideos: [String?]? {
        get {
          return snapshot["savedVideos"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "savedVideos")
        }
      }

      public var followingUsers: FollowingUser? {
        get {
          return (snapshot["FollowingUsers"] as? Snapshot).flatMap { FollowingUser(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "FollowingUsers")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["Videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Videos")
        }
      }

      public var followers: Follower? {
        get {
          return (snapshot["Followers"] as? Snapshot).flatMap { Follower(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Followers")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var userStreamKey: UserStreamKey? {
        get {
          return (snapshot["UserStreamKey"] as? Snapshot).flatMap { UserStreamKey(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "UserStreamKey")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var bioLink: String? {
        get {
          return snapshot["bioLink"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bioLink")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var userUserStreamKeyId: GraphQLID? {
        get {
          return snapshot["userUserStreamKeyId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userUserStreamKeyId")
        }
      }

      public struct FollowingUser: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Follower: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowerConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowerConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct UserStreamKey: GraphQLSelectionSet {
        public static let possibleTypes = ["StreamKey"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("streamKey", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var streamKey: String? {
          get {
            return snapshot["streamKey"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "streamKey")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnUpdateUserSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnUpdateUser($filter: ModelSubscriptionUserFilterInput) {\n  onUpdateUser(filter: $filter) {\n    __typename\n    id\n    name\n    bio\n    birthdate\n    live\n    picture\n    userType\n    username\n    verified\n    following\n    followers\n    savedVideos\n    FollowingUsers {\n      __typename\n      nextToken\n    }\n    Videos {\n      __typename\n      nextToken\n    }\n    Followers {\n      __typename\n      nextToken\n    }\n    Comments {\n      __typename\n      nextToken\n    }\n    UserStreamKey {\n      __typename\n      id\n      streamKey\n      createdAt\n      updatedAt\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    bioLink\n    createdAt\n    updatedAt\n    userUserStreamKeyId\n  }\n}"

  public var filter: ModelSubscriptionUserFilterInput?

  public init(filter: ModelSubscriptionUserFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onUpdateUser", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnUpdateUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onUpdateUser: OnUpdateUser? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onUpdateUser": onUpdateUser.flatMap { $0.snapshot }])
    }

    public var onUpdateUser: OnUpdateUser? {
      get {
        return (snapshot["onUpdateUser"] as? Snapshot).flatMap { OnUpdateUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onUpdateUser")
      }
    }

    public struct OnUpdateUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("bio", type: .nonNull(.scalar(String.self))),
        GraphQLField("birthdate", type: .nonNull(.scalar(String.self))),
        GraphQLField("live", type: .scalar(Bool.self)),
        GraphQLField("picture", type: .scalar(String.self)),
        GraphQLField("userType", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("verified", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("following", type: .list(.scalar(String.self))),
        GraphQLField("followers", type: .list(.scalar(String.self))),
        GraphQLField("savedVideos", type: .list(.scalar(String.self))),
        GraphQLField("FollowingUsers", type: .object(FollowingUser.selections)),
        GraphQLField("Videos", type: .object(Video.selections)),
        GraphQLField("Followers", type: .object(Follower.selections)),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("UserStreamKey", type: .object(UserStreamKey.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("bioLink", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("userUserStreamKeyId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, bio: String, birthdate: String, live: Bool? = nil, picture: String? = nil, userType: String, username: String, verified: Bool, following: [String?]? = nil, followers: [String?]? = nil, savedVideos: [String?]? = nil, followingUsers: FollowingUser? = nil, videos: Video? = nil, followers: Follower? = nil, comments: Comment? = nil, userStreamKey: UserStreamKey? = nil, reactions: Reaction? = nil, bioLink: String? = nil, createdAt: String, updatedAt: String, userUserStreamKeyId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "FollowingUsers": followingUsers.flatMap { $0.snapshot }, "Videos": videos.flatMap { $0.snapshot }, "Followers": followers.flatMap { $0.snapshot }, "Comments": comments.flatMap { $0.snapshot }, "UserStreamKey": userStreamKey.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "bioLink": bioLink, "createdAt": createdAt, "updatedAt": updatedAt, "userUserStreamKeyId": userUserStreamKeyId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var bio: String {
        get {
          return snapshot["bio"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bio")
        }
      }

      public var birthdate: String {
        get {
          return snapshot["birthdate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "birthdate")
        }
      }

      public var live: Bool? {
        get {
          return snapshot["live"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "live")
        }
      }

      public var picture: String? {
        get {
          return snapshot["picture"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "picture")
        }
      }

      public var userType: String {
        get {
          return snapshot["userType"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "userType")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var verified: Bool {
        get {
          return snapshot["verified"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "verified")
        }
      }

      public var following: [String?]? {
        get {
          return snapshot["following"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "following")
        }
      }

      public var followers: [String?]? {
        get {
          return snapshot["followers"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "followers")
        }
      }

      public var savedVideos: [String?]? {
        get {
          return snapshot["savedVideos"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "savedVideos")
        }
      }

      public var followingUsers: FollowingUser? {
        get {
          return (snapshot["FollowingUsers"] as? Snapshot).flatMap { FollowingUser(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "FollowingUsers")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["Videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Videos")
        }
      }

      public var followers: Follower? {
        get {
          return (snapshot["Followers"] as? Snapshot).flatMap { Follower(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Followers")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var userStreamKey: UserStreamKey? {
        get {
          return (snapshot["UserStreamKey"] as? Snapshot).flatMap { UserStreamKey(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "UserStreamKey")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var bioLink: String? {
        get {
          return snapshot["bioLink"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bioLink")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var userUserStreamKeyId: GraphQLID? {
        get {
          return snapshot["userUserStreamKeyId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userUserStreamKeyId")
        }
      }

      public struct FollowingUser: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Follower: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowerConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowerConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct UserStreamKey: GraphQLSelectionSet {
        public static let possibleTypes = ["StreamKey"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("streamKey", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var streamKey: String? {
          get {
            return snapshot["streamKey"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "streamKey")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}

public final class OnDeleteUserSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription OnDeleteUser($filter: ModelSubscriptionUserFilterInput) {\n  onDeleteUser(filter: $filter) {\n    __typename\n    id\n    name\n    bio\n    birthdate\n    live\n    picture\n    userType\n    username\n    verified\n    following\n    followers\n    savedVideos\n    FollowingUsers {\n      __typename\n      nextToken\n    }\n    Videos {\n      __typename\n      nextToken\n    }\n    Followers {\n      __typename\n      nextToken\n    }\n    Comments {\n      __typename\n      nextToken\n    }\n    UserStreamKey {\n      __typename\n      id\n      streamKey\n      createdAt\n      updatedAt\n    }\n    Reactions {\n      __typename\n      nextToken\n    }\n    bioLink\n    createdAt\n    updatedAt\n    userUserStreamKeyId\n  }\n}"

  public var filter: ModelSubscriptionUserFilterInput?

  public init(filter: ModelSubscriptionUserFilterInput? = nil) {
    self.filter = filter
  }

  public var variables: GraphQLMap? {
    return ["filter": filter]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("onDeleteUser", arguments: ["filter": GraphQLVariable("filter")], type: .object(OnDeleteUser.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(onDeleteUser: OnDeleteUser? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "onDeleteUser": onDeleteUser.flatMap { $0.snapshot }])
    }

    public var onDeleteUser: OnDeleteUser? {
      get {
        return (snapshot["onDeleteUser"] as? Snapshot).flatMap { OnDeleteUser(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "onDeleteUser")
      }
    }

    public struct OnDeleteUser: GraphQLSelectionSet {
      public static let possibleTypes = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("bio", type: .nonNull(.scalar(String.self))),
        GraphQLField("birthdate", type: .nonNull(.scalar(String.self))),
        GraphQLField("live", type: .scalar(Bool.self)),
        GraphQLField("picture", type: .scalar(String.self)),
        GraphQLField("userType", type: .nonNull(.scalar(String.self))),
        GraphQLField("username", type: .nonNull(.scalar(String.self))),
        GraphQLField("verified", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("following", type: .list(.scalar(String.self))),
        GraphQLField("followers", type: .list(.scalar(String.self))),
        GraphQLField("savedVideos", type: .list(.scalar(String.self))),
        GraphQLField("FollowingUsers", type: .object(FollowingUser.selections)),
        GraphQLField("Videos", type: .object(Video.selections)),
        GraphQLField("Followers", type: .object(Follower.selections)),
        GraphQLField("Comments", type: .object(Comment.selections)),
        GraphQLField("UserStreamKey", type: .object(UserStreamKey.selections)),
        GraphQLField("Reactions", type: .object(Reaction.selections)),
        GraphQLField("bioLink", type: .scalar(String.self)),
        GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        GraphQLField("userUserStreamKeyId", type: .scalar(GraphQLID.self)),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, name: String, bio: String, birthdate: String, live: Bool? = nil, picture: String? = nil, userType: String, username: String, verified: Bool, following: [String?]? = nil, followers: [String?]? = nil, savedVideos: [String?]? = nil, followingUsers: FollowingUser? = nil, videos: Video? = nil, followers: Follower? = nil, comments: Comment? = nil, userStreamKey: UserStreamKey? = nil, reactions: Reaction? = nil, bioLink: String? = nil, createdAt: String, updatedAt: String, userUserStreamKeyId: GraphQLID? = nil) {
        self.init(snapshot: ["__typename": "User", "id": id, "name": name, "bio": bio, "birthdate": birthdate, "live": live, "picture": picture, "userType": userType, "username": username, "verified": verified, "following": following, "followers": followers, "savedVideos": savedVideos, "FollowingUsers": followingUsers.flatMap { $0.snapshot }, "Videos": videos.flatMap { $0.snapshot }, "Followers": followers.flatMap { $0.snapshot }, "Comments": comments.flatMap { $0.snapshot }, "UserStreamKey": userStreamKey.flatMap { $0.snapshot }, "Reactions": reactions.flatMap { $0.snapshot }, "bioLink": bioLink, "createdAt": createdAt, "updatedAt": updatedAt, "userUserStreamKeyId": userUserStreamKeyId])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return snapshot["name"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "name")
        }
      }

      public var bio: String {
        get {
          return snapshot["bio"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bio")
        }
      }

      public var birthdate: String {
        get {
          return snapshot["birthdate"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "birthdate")
        }
      }

      public var live: Bool? {
        get {
          return snapshot["live"] as? Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "live")
        }
      }

      public var picture: String? {
        get {
          return snapshot["picture"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "picture")
        }
      }

      public var userType: String {
        get {
          return snapshot["userType"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "userType")
        }
      }

      public var username: String {
        get {
          return snapshot["username"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "username")
        }
      }

      public var verified: Bool {
        get {
          return snapshot["verified"]! as! Bool
        }
        set {
          snapshot.updateValue(newValue, forKey: "verified")
        }
      }

      public var following: [String?]? {
        get {
          return snapshot["following"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "following")
        }
      }

      public var followers: [String?]? {
        get {
          return snapshot["followers"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "followers")
        }
      }

      public var savedVideos: [String?]? {
        get {
          return snapshot["savedVideos"] as? [String?]
        }
        set {
          snapshot.updateValue(newValue, forKey: "savedVideos")
        }
      }

      public var followingUsers: FollowingUser? {
        get {
          return (snapshot["FollowingUsers"] as? Snapshot).flatMap { FollowingUser(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "FollowingUsers")
        }
      }

      public var videos: Video? {
        get {
          return (snapshot["Videos"] as? Snapshot).flatMap { Video(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Videos")
        }
      }

      public var followers: Follower? {
        get {
          return (snapshot["Followers"] as? Snapshot).flatMap { Follower(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Followers")
        }
      }

      public var comments: Comment? {
        get {
          return (snapshot["Comments"] as? Snapshot).flatMap { Comment(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Comments")
        }
      }

      public var userStreamKey: UserStreamKey? {
        get {
          return (snapshot["UserStreamKey"] as? Snapshot).flatMap { UserStreamKey(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "UserStreamKey")
        }
      }

      public var reactions: Reaction? {
        get {
          return (snapshot["Reactions"] as? Snapshot).flatMap { Reaction(snapshot: $0) }
        }
        set {
          snapshot.updateValue(newValue?.snapshot, forKey: "Reactions")
        }
      }

      public var bioLink: String? {
        get {
          return snapshot["bioLink"] as? String
        }
        set {
          snapshot.updateValue(newValue, forKey: "bioLink")
        }
      }

      public var createdAt: String {
        get {
          return snapshot["createdAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "createdAt")
        }
      }

      public var updatedAt: String {
        get {
          return snapshot["updatedAt"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "updatedAt")
        }
      }

      public var userUserStreamKeyId: GraphQLID? {
        get {
          return snapshot["userUserStreamKeyId"] as? GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "userUserStreamKeyId")
        }
      }

      public struct FollowingUser: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Video: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowingConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowingConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Follower: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelFollowerConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelFollowerConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct Comment: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelCommentConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelCommentConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }

      public struct UserStreamKey: GraphQLSelectionSet {
        public static let possibleTypes = ["StreamKey"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("streamKey", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(id: GraphQLID, streamKey: String? = nil, createdAt: String, updatedAt: String) {
          self.init(snapshot: ["__typename": "StreamKey", "id": id, "streamKey": streamKey, "createdAt": createdAt, "updatedAt": updatedAt])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return snapshot["id"]! as! GraphQLID
          }
          set {
            snapshot.updateValue(newValue, forKey: "id")
          }
        }

        public var streamKey: String? {
          get {
            return snapshot["streamKey"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "streamKey")
          }
        }

        public var createdAt: String {
          get {
            return snapshot["createdAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "createdAt")
          }
        }

        public var updatedAt: String {
          get {
            return snapshot["updatedAt"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "updatedAt")
          }
        }
      }

      public struct Reaction: GraphQLSelectionSet {
        public static let possibleTypes = ["ModelReactionConnection"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextToken", type: .scalar(String.self)),
        ]

        public var snapshot: Snapshot

        public init(snapshot: Snapshot) {
          self.snapshot = snapshot
        }

        public init(nextToken: String? = nil) {
          self.init(snapshot: ["__typename": "ModelReactionConnection", "nextToken": nextToken])
        }

        public var __typename: String {
          get {
            return snapshot["__typename"]! as! String
          }
          set {
            snapshot.updateValue(newValue, forKey: "__typename")
          }
        }

        public var nextToken: String? {
          get {
            return snapshot["nextToken"] as? String
          }
          set {
            snapshot.updateValue(newValue, forKey: "nextToken")
          }
        }
      }
    }
  }
}