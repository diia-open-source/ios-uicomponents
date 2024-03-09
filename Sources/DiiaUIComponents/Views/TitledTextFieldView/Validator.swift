import UIKit

public protocol Validator {
    associatedtype ValidationType
    
    func isValid(value: ValidationType?) -> Bool
}

public struct TextValidationErrorGenerator {
    public let type: TextValidator
    public let error: String?
    
    public init(type: TextValidator, error: String?) {
        self.type = type
        self.error = error
    }
    
    public init(validationModel: InputValidationModel) {
        let prefix = validationModel.flags?.count ?? 0 > 0 ? "(?\((validationModel.flags ?? []).joined()))" : ""
        self.type = .regEx(regEx: prefix + validationModel.regexp)
        self.error = validationModel.errorMessage
    }
    
    public func validationError(text: String?) -> String? {
        if type.isValid(value: text) {
            return nil
        }
        return error
    }
}

public enum TextValidator: Validator {
    case none
    case length(min: Int, max: Int)
    case number(min: Double?, max: Double?)
    case formattedNumber(min: Double?, max: Double?)
    case regEx(regEx: String)
    
    public func isValid(value: String?) -> Bool {
        guard let value = value else { return false }
        switch self {
        case .none:
            return true
        case .length(let min, let max):
            return value.count >= min && value.count <= max
        case .number(let min, let max):
            guard let doubleValue = Double(value) else { return false }
            return doubleValue >= (min ?? .leastNormalMagnitude)
                && doubleValue <= (max ?? .greatestFiniteMagnitude)
        case .formattedNumber(let min, let max):
            let valueWithoutSpacing = value.replacingOccurrences(of: " ", with: "")
            guard let doubleValue = Double(valueWithoutSpacing) else { return false }
            return doubleValue >= (min ?? .leastNormalMagnitude)
                && doubleValue <= (max ?? .greatestFiniteMagnitude)
        case .regEx(let regEx):
            let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
            return predicate.evaluate(with: value)
        }
    }
    
    public static let realEstateAreaValidator: TextValidator = .number(min: 1, max: 99999)
    public static let yearValidator: TextValidator = .regEx(regEx: "^(19|20)\\d{2}$")
    public static let vehicleNumberValidator: TextValidator = .length(min: 3, max: 10)
    public static let vehicleModelValidator: TextValidator = .length(min: 2, max: 30)
    public static let vehicleVinValidator: TextValidator = .regEx(regEx: "^[A-HJ-NPR-Za-hj-npr-z\\d]{17}$")
    public static let nameValidator: TextValidator = .regEx(regEx: "(?<! )[-a-zA-ZА-ЩЬЮЯҐЄІЇа-щьюяґєії`’'‘\\- ]{1,70}")
    public static let ukrNameValidator: TextValidator = .regEx(regEx: "(?<! )[А-ЩЬЮЯҐЄІЇа-щьюяґєії`’'‘\\- ]{1,70}")
    public static let phoneNumberValidator: TextValidator = .regEx(regEx: "^(((\\+)|(00))?[0-9]{12}$)|([0-9]{10})")
    public static let ukrPhoneNumberMaskedValidator: TextValidator = .regEx(regEx: "^(\\+)?38 \\((039|050|063|066|067|068|073|091|092|093|094|095|096|097|098|099)\\) \\d{3} \\d{2} \\d{2}$")
    public static let passportDepartmentValidator: TextValidator = .regEx(regEx: "^[ а-щА-ЩьюяЮЯґєЄіІїЇ0-9ʼ,-]{0,150}")
    public static let passportNumberValidator: TextValidator = .regEx(regEx: "^[ a-zA-Zа-яА-ЩьюяЮЯґєЄіІїЇ0-9ʼ,-]{0,20}")
}

public enum TextInputValidationHelper {
    public static func stringValidator(maxLength: Int) -> ((String?, NSRange, String) -> Bool) {
        return { originalText, range, string in
            if string.isEmpty { return true }
            var text = originalText ?? ""
            if let range = Range(range, in: text) {
                text = text.replacingCharacters(in: range, with: string)
            }
            
            if text.count < maxLength { return true }
            return false
        }
    }
    
    public static func sumValidator() -> ((String?, NSRange, String) -> Bool) {
        return { originalText, range, string in
            if string.isEmpty { return true }
            var text = originalText ?? ""
            if let range = Range(range, in: text) {
                text = text.replacingCharacters(in: range, with: string)
            }
            
            if text.isValidSum { return true }
            return false
        }
    }
    
    public static func sumValidator(maxDigits: Int) -> ((String?, NSRange, String) -> Bool) {
        return { originalText, range, string in
            if string.isEmpty { return true }
            var text = originalText ?? ""
            if let range = Range(range, in: text) {
                text = text.replacingCharacters(in: range, with: string)
            }
            
            let intPartText = text.components(separatedBy: CharacterSet(charactersIn: ".,")).first ?? ""
            if intPartText.count > maxDigits { return false }
            
            if text.isValidSum { return true }
            return false
        }
    }
    
    public static func doubleValidator(maxValue: Double) -> ((String?, NSRange, String) -> Bool) {
        return { originalText, range, string in
            if string.isEmpty { return true }
            var text = originalText ?? ""
            if let range = Range(range, in: text) {
                text = text.replacingCharacters(in: range, with: string)
            }
            if let number = Double(text) {
                return number <= maxValue
            }
            return false
        }
    }
    
    public static func intValidator(maxValue: Int) -> ((String?, NSRange, String) -> Bool) {
        return { originalText, range, string in
            if string.isEmpty { return true }
            var text = originalText ?? ""
            if let range = Range(range, in: text) {
                text = text.replacingCharacters(in: range, with: string)
            }
            if let number = Int(text) {
                return number <= maxValue
            }
            return false
        }
    }
}

public struct InputValidationModel: Codable {
    public let regexp: String
    public let flags: [String]?
    public let errorMessage: String?
}
