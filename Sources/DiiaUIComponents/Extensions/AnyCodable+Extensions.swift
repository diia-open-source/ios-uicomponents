
import Foundation
import DiiaCommonTypes

extension AnyCodable {
    public func parseValue<T: Decodable>(forKey key: String) -> T? {
        return parseValue(forKey: key, decoder: UIComponentsConfiguration.shared.defaultDecoder)
    }
    
    public func parse<T: Decodable>() -> T? {
        return parse(decoder: UIComponentsConfiguration.shared.defaultDecoder)
    }
    
    public static func fromEncodable(encodable: Encodable) -> AnyCodable {
        return .fromEncodable(encodable: encodable, decoder: UIComponentsConfiguration.shared.defaultDecoder)
    }
    
    public func keys() -> [String] {
        switch self {
        case .dictionary(let dict):
            return Array(dict.keys)
        default:
            return []
        }
    }
    
    public func stringValue() -> String? {
        switch self {
        case .string(let string):
            return string
        default:
            return nil
        }
    }
}
