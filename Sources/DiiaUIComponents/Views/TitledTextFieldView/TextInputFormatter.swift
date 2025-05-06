import UIKit

public enum TextInputFormatter {
    public static func integerFormatter(
        maxDigits: Int,
        textField: UITextField,
        onChange: ((String) -> Void)? = nil
    ) -> ((String?, NSRange, String) -> Bool) {
        return { [weak textField] originalText, range, string in
            if string.contains(".") || string.contains(",") || (originalText?.first == "0" && !string.isEmpty) { return false }
            var text = originalText ?? ""
            if let range = Range(range, in: text) {
                let formattedText = text.replacingCharacters(in: range, with: string)
                text = formattedText.replacingOccurrences(of: " ", with: "")
            }
        
            if text.isEmpty { return true }
            
            if text.isValidSum, text.count <= maxDigits {
                let maskedText = text.separateNumber()
                textField?.text = maskedText
                onChange?(maskedText)
            }

            return false
        }
    }
    
    public static func sumFormatter(
        textField: UITextField,
        onChange: ((String) -> Void)? = nil
    ) -> ((String?, NSRange, String) -> Bool) {
        return { [weak textField] originalText, range, string in
            if string.isEmpty { return true }
            let string = string.replacingOccurrences(of: ",", with: ".")
            var text = originalText ?? ""
            if let range = Range(range, in: text) {
                text = text.replacingCharacters(in: range, with: string)
            }
            
            if text.isValidSum {
                textField?.text = text
                onChange?(text)
            }
            return false
        }
    }
    
    public static func phoneFormatter(
        textField: UITextField,
        mask: String? = nil,
        onChange: ((String) -> Void)? = nil
    ) -> ((String?, NSRange, String) -> Bool) {
        return { [weak textField] originalText, range, string in
            guard let newString = (originalText as? NSString)?
                .replacingCharacters(in: range, with: string)
                .formattedPhoneNumber(mask: mask ?? "+XX (XXX) XXX XX XX")
            else {
                return false
            }
            textField?.text = newString
            onChange?(newString)
            
            return false
        }
    }
    
    public static func textFormatter(
        textField: UITextField,
        mask: String,
        onChange: ((String) -> Void)? = nil
    ) -> ((String?, NSRange, String) -> Bool) {
        return { [weak textField] originalText, range, string in
            guard let newString = (originalText as? NSString)?
                .replacingCharacters(in: range, with: string)
                .formattedText(mask: mask)
            else {
                return false
            }
            textField?.text = newString
            onChange?(newString)
            return false
        }
    }
    
    public static func phoneWithHintFormatter(
        attributedPrefix: NSAttributedString,
        attributedHint: NSAttributedString,
        textField: UITextField,
        onChange: ((String) -> Void)? = nil
    ) -> ((String?, NSRange, String) -> Bool) {
        return { [weak textField] originalText, range, string in
            guard let textField = textField,
                  var newString = (originalText as? NSString)?
                    .replacingCharacters(in: range, with: string)
                    .formattedPhoneNumber()
            else {
                return false
            }
            
            if newString == attributedPrefix.string {
                textField.text = .empty
                let attributedPlaceholder = NSMutableAttributedString()
                attributedPlaceholder.append(attributedPrefix)
                attributedPlaceholder.append(attributedHint)
                textField.attributedPlaceholder = attributedPlaceholder
                onChange?(.empty)
            } else {
                if originalText == "" {
                    newString = (attributedPrefix.string + " " + newString).formattedPhoneNumber()
                }
                textField.text = newString
                onChange?(newString)
            }
    
            return false
        }
    }
    
    public static func stringFormatter(
        maxCount: Int
    ) -> ((String?, NSRange, String) -> Bool) {
        return { originalText, range, string in
            guard let newString = (originalText as? NSString)?.replacingCharacters(in: range, with: string), newString.count <= maxCount
            else {
                return false
            }
            return true
        }
    }
}
