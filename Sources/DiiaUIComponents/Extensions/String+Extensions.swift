import UIKit
import NaturalLanguage

public extension String {
    
    static let empty = ""
    
    func attributed(font: UIFont,
                    color: UIColor = .black,
                    backgroundColor: UIColor = .clear,
                    lineHeightMultiple: CGFloat? = nil,
                    lineHeight: CGFloat? = nil,
                    lineSpacing: CGFloat? = nil,
                    textAlignment: NSTextAlignment = .natural,
                    lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString? {
        
        let attributeString = NSMutableAttributedString(string: self)
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        style.lineBreakMode = lineBreakMode
        
        if let heightMultiple = lineHeightMultiple {
            style.lineHeightMultiple = heightMultiple
        } else if let lineHeight = lineHeight {
            let heightMultiple = (lineHeight - (lineSpacing ?? 0)) / font.lineHeight
            style.lineHeightMultiple = heightMultiple
        }
        if let lineSpacing = lineSpacing {
            attributeString.addAttribute(NSAttributedString.Key.baselineOffset, value: lineSpacing/2, range: NSRange(location: 0, length: attributeString.length))
            style.lineSpacing = lineSpacing/2
        }
        
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .backgroundColor: backgroundColor,
            .paragraphStyle: style,
            .font: font
        ]
        attributeString.addAttributes(textAttributes, range: NSRange(location: 0, length: self.count))
        
        return attributeString
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func percentEncodedUrl() -> String? {
        if let nsUrl = NSURL(string: self) {
            return nsUrl.absoluteString
        }
        return nil
    }
    
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
    
    func cleanedFromQuery() -> String {
        return self.replacingOccurrences(of: "+", with: " ")
    }
    
    func isEscaped() -> Bool {
        return self.removingPercentEncoding != self
    }
    
    private func mod97() -> Int {
        let symbols: [Character] = Array(self)
        let swapped = symbols.dropFirst(4) + symbols.prefix(4)
        
        let mod: Int = swapped.reduce(0) { (previousMod, char) in
            let value = Int(String(char), radix: 36) ?? 0 // "0" => 0, "A" => 10, "Z" => 35
            let factor = value < 10 ? 10 : 100
            return (factor * previousMod + value) % 97
        }
        
        return mod
    }
    
    func passesMod97Check() -> Bool {
        guard self.count >= 4 else {
            return false
        }
        
        let uppercase = self.uppercased()
        
        guard uppercase.range(of: "^[0-9A-Z]*$", options: .regularExpression) != nil else {
            return false
        }

        return (uppercase.mod97() == 1)
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    var withPhoneSpaces: String {
        // When on entry we get phone in the next format - 380998887766
        // And we want to present it as - +380 99 888 77 66

        let insertIndexes = [3, 6, 10, 13]
        var phoneNumberCharacters = Array(self)
        insertIndexes.forEach({ index in
            phoneNumberCharacters.insert(Character(" "), at: index)
        })
        phoneNumberCharacters.insert(Character("+"), at: 0)
        
        return String(phoneNumberCharacters)
    }
    
    var withoutSpaces: String {
        components(separatedBy: .whitespaces).joined()
    }
    
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

    func separateNumber(every stride: Int = 3, with separator: Character = " ") -> String {
        return String(reversedStr.enumerated().map {$0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined()).reversedStr
    }
    
    var reversedStr: String {
        return String(self.reversed())
    }
    
    var isNumberOrEmpty: Bool {
        return isEmpty || rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    var digits: String {
        return String(unicodeScalars.filter(CharacterSet.decimalDigits.contains))
    }
    
    var letters: String {
        return String(unicodeScalars.filter(CharacterSet.letters.contains))
    }
    
    var textLocale: NLLanguage {
        if let language = NLLanguageRecognizer.dominantLanguage(for: self), language == .english {
            return language
        }
        
        return .ukrainian
    }
    
    func replacingMatches(regexPattern: String, with value: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive) else {
            return self
        }
        let range = NSRange(location: 0, length: count)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: value)
    }

    func character(at index: Int) -> String? {
        if index >= 0 && index < self.count {
            let strIndex = self.index(self.startIndex, offsetBy: index)
            return String(self[strIndex])
        }
        return nil
    }
    
    func parseDecodable<T>(decoder: JSONDecoder) -> T? where T: Decodable {
        let data = Data(self.utf8)
        return try? decoder.decode(T.self, from: data)
    }
    
    func parseDecodable<T>() -> T? where T: Decodable {
        return parseDecodable(decoder: UIComponentsConfiguration.shared.defaultDecoder)
    }
}

public extension NSString {
    var isNumber: Bool {
        let str =  self as String
        return str.isNumberOrEmpty
    }
}

public extension String {
    var withPDFExtension: String {
        return hasSuffix(".pdf") ? self : self.appending(".pdf")
    }
}
