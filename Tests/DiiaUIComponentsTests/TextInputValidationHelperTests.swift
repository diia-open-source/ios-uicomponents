import XCTest
@testable import DiiaUIComponents

final class TextInputValidationHelperTests: XCTestCase {

    func test_stringValidator_tooLong() {
        // Arrange
        let stringTooLong = "stringTooLong"
        let closure = TextInputValidationHelper.stringValidator(maxLength: 5)
        
        // Act
        let result: Bool = closure(stringTooLong, NSRange(location: 0, length: 5), "s")
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_stringValidator_validEmptyReplacement() {
        // Arrange
        let string = "srt"
        let closure = TextInputValidationHelper.stringValidator(maxLength: 5)
        
        // Act
        let result: Bool = closure(string, NSRange(location: 0, length: 5), "")
        
        // Assert
        XCTAssertTrue(result)
    }
    
    func test_stringValidator_validReplacement() {
        // Arrange
        let string = "s"
        let closure = TextInputValidationHelper.stringValidator(maxLength: 5)
        
        // Act
        let result: Bool = closure(string, NSRange(location: 0, length: 1), "ttt")
        
        // Assert
        XCTAssertTrue(result)
    }
    
    func test_stringValidator_tooLongReplacement() {
        // Arrange
        let string = "s"
        let closure = TextInputValidationHelper.stringValidator(maxLength: 3)
        
        // Act
        let result: Bool = closure(string, NSRange(location: 0, length: 1), "ttttt")
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_sumValidator_validReplacement() {
        // Arrange
        let string = "sss"
        let closure = TextInputValidationHelper.sumValidator()
        
        // Act
        let result: Bool = closure(string, NSRange(location: 0, length: string.count), "777")
        
        // Assert
        XCTAssertTrue(result)
    }
    
    func test_sumValidator_invalidReplacement() {
        // Arrange
        let string = "sss"
        let closure = TextInputValidationHelper.sumValidator()
        
        // Act
        let result: Bool = closure(string, NSRange(location: 0, length: string.count), "rrr")
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_sumValidatorWithMaxDigits_validReplacement() {
        // Arrange
        let string = "sss"
        let replacement = "777"
        let closure = TextInputValidationHelper.sumValidator(maxDigits: replacement.count)
        
        // Act
        let result: Bool = closure(string, NSRange(location: 0, length: string.count), replacement)
        
        // Assert
        XCTAssertTrue(result)
    }
    
    func test_sumValidatorWithMaxDigits_TooLong() {
        // Arrange
        let string = "sss"
        let replacement = "777"
        let closure = TextInputValidationHelper.sumValidator(maxDigits: replacement.count - 1)
        
        // Act
        let result: Bool = closure(string, NSRange(location: 0, length: string.count), replacement)
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_sumValidatorWithMaxDigits_invalidReplacement() {
        // Arrange
        let string = "sss"
        let replacement = "rrr"
        let closure = TextInputValidationHelper.sumValidator(maxDigits: replacement.count)
        
        // Act
        let result: Bool = closure(string, NSRange(location: 0, length: string.count), "rrr")
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_doubleValidator_validReplacement() {
        // Arrange
        let string = "sss"
        let closure = TextInputValidationHelper.doubleValidator(maxValue: 1.1)
        
        // Act
        let result: Bool = closure(string, NSRange(location: 0, length: string.count), "0.75")
        
        // Assert
        XCTAssertTrue(result)
    }
    
    func test_doubleValidator_validReplacementButTooBig() {
        // Arrange
        let string = "sss"
        let closure = TextInputValidationHelper.doubleValidator(maxValue: 1.1)
        
        // Act
        let result: Bool = closure(string, NSRange(location: 0, length: string.count), "1.75")
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_doubleValidator_invalidReplacement() {
        // Arrange
        let string = "sss"
        let closure = TextInputValidationHelper.doubleValidator(maxValue: 1.1)
        
        // Act
        let result: Bool = closure(string, NSRange(location: 0, length: string.count), "rrr")
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_intValidator_validReplacement() {
        // Arrange
        let originalText = "4"
        let closure = TextInputValidationHelper.intValidator(maxValue: 6)
        
        // Act
        let result: Bool = closure(originalText, NSRange(location: 0, length: 1), "5")
        
        // Assert
        XCTAssertTrue(result)
    }
    
    func test_intValidator_validReplacementAndMaxValueAtTheEdge() {
        // Arrange
        let originalText = "4"
        let closure = TextInputValidationHelper.intValidator(maxValue: 5)
        
        // Act
        let result: Bool = closure(originalText, NSRange(location: 0, length: 1), "5")
        
        // Assert
        XCTAssertTrue(result)
    }
    
    func test_intValidator_validReplacementButMaxValueExceeded() {
        // Arrange
        let originalText = "4"
        let maxvalue: Int = 3
        let closure = TextInputValidationHelper.intValidator(maxValue: maxvalue)
        
        // Act
        let result: Bool = closure(originalText, NSRange(location: 0, length: 1), "5")
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_intValidator_validReplacementButTooLong() {
        // Arrange
        let originalText = "4"
        let closure = TextInputValidationHelper.intValidator(maxValue: 3)
        
        // Act
        let result: Bool = closure(originalText, NSRange(location: 0, length: 1), "5555")
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_intValidator_invalidReplacement() {
        // Arrange
        let originalText = "4"
        let closure = TextInputValidationHelper.intValidator(maxValue: 3)
        
        // Act
        let result: Bool = closure(originalText, NSRange(location: 0, length: 1), "A")
        
        // Assert
        XCTAssertFalse(result)
    }

}
