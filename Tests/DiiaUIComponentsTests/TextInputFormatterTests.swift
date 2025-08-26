
import XCTest
@testable import DiiaUIComponents

final class TextInputFormatterTests: XCTestCase {
    private let textfield = UITextField(frame: .zero)
    
    func test_stringFormatter() {
        
        // Arrange
        let originalText = "srt"
        let maxCount = 4
        let closure = TextInputFormatter.stringFormatter(maxCount: maxCount)
        let replacementWithGoodLenght = "d"
        let replacementWithTooBigLenght = "ddddd"
        
        // Act
        let result1: Bool = closure(originalText, NSRange(location: 0, length: 3), replacementWithGoodLenght)
        let result2: Bool = closure(originalText, NSRange(location: 0, length: 3), replacementWithTooBigLenght)

        // Assert
        XCTAssertTrue(result1)
        XCTAssertFalse(result2)
    }
    
    func test_integerFormatter_notAllowedForBadReplacement() {
        
        // Arrange
        let originalText = "srt"
        let maxDigits = 3
        let closure = TextInputFormatter.integerFormatter(maxDigits: maxDigits, textField: textfield)
        let badReplacement1 = "r."
        let badReplacement2 = "r,"
        
        // Act
        let result1: Bool = closure(originalText, NSRange(location: 0, length: 3), badReplacement1)
        let result2: Bool = closure(originalText, NSRange(location: 0, length: 3), badReplacement2)
        
        // Assert
        XCTAssertFalse(result1)
        XCTAssertFalse(result2)
    }

    func test_integerFormatter_replacingAllowed() {
        // Arrange
        var formatterOutput: String? // will be set if callback performed
        let replacementWithGoodLenght = "44"
        let originalText = "srt"
        let validRange = NSRange(location: 0, length: originalText.count)
        let maxDigits = 3
        let closure = TextInputFormatter.integerFormatter(maxDigits: maxDigits, textField: textfield) { output in
            formatterOutput = output
        }
        
        // Act
        let checkResult: Bool = closure(originalText, validRange, replacementWithGoodLenght)

        // Assert
        XCTAssertFalse(checkResult)
        XCTAssertNotNil(formatterOutput)
        XCTAssertNotEqual(formatterOutput, originalText)
        XCTAssertEqual(formatterOutput, replacementWithGoodLenght)
    }
    
    func test_integerFormatter_replacingAllowedWithWhitespace() {
        // Arrange
        var formatterOutput: String? // will be set if callback performed
        let replacementWithWhitespace = "4 4"
        let originalText = "srt"
        let validRange = NSRange(location: 0, length: originalText.count)
        let maxDigits = 3
        let closure = TextInputFormatter.integerFormatter(maxDigits: maxDigits, textField: textfield) { output in
            formatterOutput = output
        }
        
        // Act
        let checkResult: Bool = closure(originalText, validRange, replacementWithWhitespace)

        // Assert
        XCTAssertFalse(checkResult)
        XCTAssertNotNil(formatterOutput)
        XCTAssertNotEqual(formatterOutput, originalText)
        XCTAssertEqual(formatterOutput, "44")
    }
    
    func test_integerFormatter_replacingNotAllowedForWrongRange() {
        // Arrange
        var formatterOutput: String? // will be set if callback performed
        let replacementWithGoodLenght = "44"
        let originalText = "srt"
        let wrongRange = NSRange(location: 0, length: 5)
        let maxDigits = 3
        let closure = TextInputFormatter.integerFormatter(maxDigits: maxDigits, textField: textfield) { output in
            formatterOutput = output
        }
        
        // Act
        _ = closure(originalText, wrongRange, replacementWithGoodLenght)

        // Assert
        XCTAssertNil(formatterOutput)
        XCTAssertNotEqual(replacementWithGoodLenght, originalText)
    }
    
    func test_integerFormatter_replacingAllowedButReplacementIsNotDigit() {
        // Arrange
        var formatterOutput: String? // will be set if callback performed
        let replacementWithGoodLenght = "aaa"
        let originalText = "srt"
        let validRange = NSRange(location: 0, length: originalText.count)
        let maxDigits = 3
        let closure = TextInputFormatter.integerFormatter(maxDigits: maxDigits, textField: textfield) { output in
            formatterOutput = output
        }
        
        // Act
        _ = closure(originalText, validRange, replacementWithGoodLenght)

        // Assert
        XCTAssertNil(formatterOutput)
    }
    
    func test_phoneFormatter_validNumber_outputCallbackCalled() {
        // Arrange
        var formatterOutput: String? // will be set if callback performed
        let replacement = "80661112233"
        let originalText = "aaa aaa aaa a"
        let validRange = NSRange(location: 0, length: originalText.count)
        let closure = TextInputFormatter.phoneFormatter(textField: textfield) { output in
            formatterOutput = output
        }
        
        // Act
        _ = closure(originalText, validRange, replacement)
        
        // Assert
        XCTAssertNotNil(formatterOutput)
        XCTAssertNotEqual(formatterOutput, originalText)
        XCTAssertGreaterThan((formatterOutput ?? "").count, 0)
    }
    
    func test_phoneFormatter_invalidNumber_outputIsEmpty() {
        // Arrange
        var formatterOutput: String? // will be set if callback performed
        let replacementNotDigits = "bbb bb bb"
        let originalText = "aaa aaa aaa a"
        let validRange = NSRange(location: 0, length: originalText.count)
        let closure = TextInputFormatter.phoneFormatter(textField: textfield) { output in
            formatterOutput = output
        }
        
        // Act
        _ = closure(originalText, validRange, replacementNotDigits)
        
        // Assert
        XCTAssertEqual((formatterOutput ?? "").count, 0)
    }
    
    func test_phoneFormatter_emptyString_outputCallbackNotCalled() {
        // Arrange
        var formatterOutput: String? // will be set if callback performed
        let replacement = "80661112233"
        let originalText: String? = nil
        let validRange = NSRange(location: 0, length: 1)
        let closure = TextInputFormatter.phoneFormatter(textField: textfield) { output in
            formatterOutput = output
        }
        
        // Act
        _ = closure(originalText, validRange, replacement)
        
        // Assert
        XCTAssertNil(formatterOutput)
    }
}
