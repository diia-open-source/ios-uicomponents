
import XCTest
@testable import DiiaUIComponents
    
final class TextValidatorTests: XCTestCase {
    
    private var sut: TextValidator!
    
    func test_caseLength_tooLong() {
        // Arrange
        let stringTooLong = "stringTooLong"
        sut = TextValidator.length(min: 2, max: 5)
        
        // Act
        let result = sut.isValid(value: stringTooLong)
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_caseLength_tooShort() {
        // Arrange
        let stringTooShort = "s"
        sut = TextValidator.length(min: 2, max: 5)
        
        // Act
        let result = sut.isValid(value: stringTooShort)
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_caseLength_valid() {
        // Arrange
        let string = "str"
        sut = TextValidator.length(min: 2, max: 5)
        
        // Act
        let result = sut.isValid(value: string)
        
        // Assert
        XCTAssertTrue(result)
    }
    
    func test_caseNumber_valid() {
        // Arrange
        let string = "0.5"
        sut = TextValidator.number(min: 0.3, max: 1.1)
        
        // Act
        let result = sut.isValid(value: string)
        
        // Assert
        XCTAssertTrue(result)
    }
    
    func test_caseNumber_invalid() {
        // Arrange
        let string = "0.2"
        sut = TextValidator.number(min: 0.3, max: 1.1)
        
        // Act
        let result = sut.isValid(value: string)
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_caseNumber_notDouble() {
        // Arrange
        let string = "string"
        sut = TextValidator.number(min: 0.3, max: 1.1)
        
        // Act
        let result = sut.isValid(value: string)
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_caseRegex_yearInvalid() {
        // Arrange
        let string = "string"
        sut = TextValidator.yearValidator
        
        // Act
        let result = sut.isValid(value: string)
        
        // Assert
        XCTAssertFalse(result)
    }
    
    func test_caseRegex_yearValid() {
        // Arrange
        let string = "1999"
        sut = TextValidator.yearValidator
        
        // Act
        let result = sut.isValid(value: string)
        
        // Assert
        XCTAssertTrue(result)
    }
    
    func test_caseRegex_passportNumberInvalid() {
        // Arrange
        let string = "stringMoreThan20Symbols"
        sut = TextValidator.passportNumberValidator
        
        // Act
        let result = sut.isValid(value: string)
        
        // Assert
        XCTAssertFalse(result)
    }

}
