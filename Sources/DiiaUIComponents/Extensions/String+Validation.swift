
import Foundation

public extension String {
    func isValid(regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "^([a-zA-Z0-9_%+-]{1,}\\.){0,}[a-zA-Z0-9_%+-]{1,}@([a-zA-Z0-9_%+-]{1,}\\.){1,}[A-Za-z]{2,64}$"
        return isValid(regex: emailRegEx)
    }
    
    var isValidNonRussianEmail: Bool {
        let emailRegEx = "^([a-zA-Z0-9_%+-]{1,}\\.){0,}[a-zA-Z0-9_%+-]{1,}@([a-zA-Z0-9_%+-]{1,}\\.){1,}(?!ru|su)[A-Za-z]{2,64}$"
        return isValid(regex: emailRegEx)
    }
    
    var isValidSum: Bool {
        let sumRegEx = "\\d+[.,]?\\d{0,2}"
        return isValid(regex: sumRegEx)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneRegEx = "^(((\\+)|(00))?[0-9]{12}$)|([0-9]{10})"
        return isValid(regex: phoneRegEx)
    }
    
    var isValidUkrainianMobileNumber: Bool {
        let phoneRegEx = "^(\\+)?38(077|075|039|050|063|066|067|068|073|091|092|093|094|095|096|097|098|099)\\d{7}$"
        return isValid(regex: phoneRegEx)
    }
    
    func removingPhonePrefix(with possiblePrefixes: [String] = ["38", "+38"]) -> String {
        for phonePrefix in possiblePrefixes {
            if starts(with: phonePrefix) {
                return String(self.dropFirst(phonePrefix.count))
            }
        }
        return self
    }
    
    var isValidPassportNumber: Bool {
        let ukrSymbsRegEx = "^[A-Za-zА-Яа-яЇїІіЄєҐґ0-9`ʼ',-\\\\/()№\\u2019 ]{0,20}"
        return isValid(regex: ukrSymbsRegEx)
    }
    
    var isValidPassportDepartment: Bool {
        let ukrSymbsRegEx = "^[A-Za-zА-Яа-яЇїІіЄєҐґ0-9`ʼ',-\\\\/()№\\u2019 ]{0,150}"
        return isValid(regex: ukrSymbsRegEx)
    }
    
    var isValidName: Bool {
        let ukrSymbsRegEx = "^[ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZабвгґджзклмнпрстфхцчшщйаеєиіїоуюяьАБВГҐДЖЗКЛМНПРСТФХЦЧШЩЙАЕЄИІЇОУЮЯЬЫыЭэЁёъЪ-]+"
        return isValid(regex: ukrSymbsRegEx)
    }
    
    var isValidUkrainianName: Bool {
        let ukrSymbsRegEx = "^[ абвгґджзклмнпрстфхцчшщйаеєиіїоуюяьАБВГҐДЖЗКЛМНПРСТФХЦЧШЩЙАЕЄИІЇОУЮЯЬ-]+"
        return isValid(regex: ukrSymbsRegEx)
    }
    
    var isValidRussianName: Bool {
        let ukrSymbsRegEx = "^[ абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ-]+"
        return isValid(regex: ukrSymbsRegEx)
    }
    
    /// Formats the text according to the provided mask.
    ///
    /// This method takes a mask string and applies it to the current string,
    /// replacing placeholders (`#`) in the mask with corresponding characters from the cleaned text.
    /// Non-alphanumeric characters are removed from the current string before formatting.
    /// Non-placeholder characters in the mask are included as-is in the resulting string.
    ///
    /// - Parameter mask: A `String` containing the desired formatting pattern.
    ///                   Use `#` as a placeholder for number characters from the current string.
    ///                   Use 'A' as a placeholder for any literal characters from current string.
    ///                   Other characters in the mask are treated as literal and included in the output.
    ///
    /// - Returns: A `String` formatted according to the provided mask.
    ///            If the mask contains more placeholders than available characters in the cleaned text,
    ///            the extra placeholders remain unused.
    ///
    /// - Example:
    /// ```swift
    /// let text = "1234567890"
    /// let formatted = text.formattedText(mask: "(###) ###-####")
    /// print(formatted) // Output: "(123) 456-7890"
    /// ```
    ///
    /// - Note:
    /// This method processes only the alphanumeric characters in the original string,
    /// ignoring any special characters, whitespace, or punctuation.
    ///
    /// - Complexity: O(n + m), where `n` is the length of the cleaned text and `m` is the length of the mask.
    func formattedText(mask: String) -> String {
        let cleanText = self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        var result = ""
        var index = cleanText.startIndex
        for ch in mask where index < cleanText.endIndex {
            if ch == "#" {
                result.append(cleanText[index])
                index = cleanText.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    /// Removes the mask from the current string, extracting only the characters
    /// that correspond to placeholders (`#`) in the provided mask.
    ///
    /// This method iterates through the mask and extracts characters from the
    /// current string that align with the `#` placeholders. If the length of the
    /// mask does not match the length of the current string, the method returns `nil`.
    ///
    /// - Parameter mask: A `String` representing the mask used for the current string.
    ///                   The `#` character in the mask indicates positions where
    ///                   number characters should be extracted from the current string.
    ///
    /// - Returns: A `String?` containing the characters extracted from the current string
    ///            based on the `#` placeholders in the mask, or `nil` if the mask's
    ///            length does not match the current string's length.
    ///
    /// - Example:
    /// ```swift
    /// let text = "(123) 456-7890"
    /// let extracted = text.removingMask(mask: "(###) ###-####")
    /// print(extracted ?? "Invalid input") // Output: "1234567890"
    /// ```
    ///
    /// - Note:
    /// This method assumes that the current string was formatted using the same mask
    /// provided as input. Providing a mismatched mask or string may result in `nil` or
    /// unexpected behavior.
    ///
    /// - Complexity: O(n), where `n` is the length of the mask and the current string.
    func removingMask(mask: String) -> String? {
        guard mask.count == self.count else { return nil }
        var result = "".formattedText(mask: "")
        let startIndex = self.startIndex
        for (i, ch) in mask.enumerated() where ch == "#" {
            result.append(self[index(startIndex, offsetBy: i)])
        }
        return result
    }
    
    func formattedPhoneNumber(mask: String = "+XX (XXX) XXX XX XX") -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    var onlyDigits: String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
