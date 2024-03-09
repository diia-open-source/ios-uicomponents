import XCTest
@testable import DiiaUIComponents

final class String_ValidationTests: XCTestCase {
  
    func test_isValidEmail_valid() {
        // Arrange
        let sut = "test@test.com"
        
        // Act
        let isValid = sut.isValidEmail
        
        // Assert
        XCTAssertTrue(isValid)
    }
    
    func test_isValidEmail_invalid() {
        // Arrange
        let sut = "test.com"
        
        // Act
        let isValid = sut.isValidEmail
        
        // Assert
        XCTAssertFalse(isValid)
    }
    
    func test_isValidPhoneNumber_valid() {
        // Arrange
        let sut = "1234567890"
        
        // Act
        let isValid = sut.isValidPhoneNumber

        // Assert
        XCTAssertTrue(isValid)
    }
    
    func test_isValidPhoneNumber_invalid() {
        // Arrange
        let sut = "+86660000006"
        let sutTooLong = "37229876541"
        let sutTooShort = "+37259100"
        
        // Act
        let isValid = sut.isValidPhoneNumber
        let isValid2 = sutTooLong.isValidPhoneNumber
        let isValid3 = sutTooShort.isValidPhoneNumber
        
        // Assert
        XCTAssertFalse(isValid)
        XCTAssertFalse(isValid2)
        XCTAssertFalse(isValid3)
    }
    
    func test_isValidUkrainianMobileNumber_valid() {
        // Arrange
        let sut = "380663304455"
        let sut2 = "+380663304455"

        // Act
        let isValid = sut.isValidUkrainianMobileNumber
        let isValid2 = sut2.isValidUkrainianMobileNumber

        // Assert
        XCTAssertTrue(isValid)
        XCTAssertTrue(isValid2)
    }
    
    func test_isValidUkrainianMobileNumber_invalid() {
        // Arrange
        let wrongPrefix = "+310663304455"
        let goodPrefixButTooLong = "+38066330445577"
        let goodPrefixButTooShort = "+3806633044"
        
        // Act
        let isValid = wrongPrefix.isValidUkrainianMobileNumber
        let isValid2 = goodPrefixButTooLong.isValidUkrainianMobileNumber
        let isValid3 = goodPrefixButTooShort.isValidUkrainianMobileNumber

        // Assert
        XCTAssertFalse(isValid)
        XCTAssertFalse(isValid2)
        XCTAssertFalse(isValid3)
    }
    
    func test_removingPhonePrefix_success() {
        // Arrange
        let customPrefix = "+14"
        let sutWithUaPrefix = "+380663304455"
        let sutWithCustomPrefix = "+140663304455"

        // Act
        let withoutPrefix = sutWithUaPrefix.removingPhonePrefix()
        let withoutPrefixArrayWithSingleElement = sutWithCustomPrefix.removingPhonePrefix(with: [customPrefix])
        let withoutPrefixArrayWithFewElements = sutWithCustomPrefix.removingPhonePrefix(with: ["56", customPrefix])
        
        // Assert
        XCTAssertFalse(withoutPrefix.contains("+38"))
        XCTAssertFalse(withoutPrefixArrayWithSingleElement.contains(customPrefix))
        XCTAssertFalse(withoutPrefixArrayWithFewElements.contains(customPrefix))
    }
    
    func test_removingPhonePrefix_edgeCases() {
        // Arrange
        let customPrefix = "14"
        let sutWithCustomStringInside = "+380663301455"
        let sutWithCustomStringAtTail = "+380663304414"
        let sutWithoutCustomString = "+380663304455"

        // Act
        let result = sutWithCustomStringInside.removingPhonePrefix(with: [customPrefix])
        let result2 = sutWithCustomStringAtTail.removingPhonePrefix(with: [customPrefix])
        let result3 = sutWithoutCustomString.removingPhonePrefix(with: [customPrefix])

        // Assert
        XCTAssertTrue(result.contains(customPrefix)) // not a prefix, so expected to be left
        XCTAssertTrue(result2.contains(customPrefix)) // not a prefix, so expected to be left
        XCTAssertFalse(result3.contains(customPrefix)) // not a prefix, so expected to be left
        XCTAssertEqual(result3, sutWithoutCustomString) // expected to be not changed
    }
    
    func test_isValidPassportNumber_valid() {
        // Arrange
        let sut = "ДД230230"
        let sut2 = "DD230230"

        
        // Act
        let isValid = sut.isValidPassportNumber
        let isValid2 = sut2.isValidPassportNumber

        // Assert
        XCTAssertTrue(isValid)
        XCTAssertTrue(isValid2)
    }
    
    func test_isValidPassportNumber_invalid() {
        // Arrange
        let sutTooLong = "ааабббвввгггддд111222333444555"
        
        // Act
        let isValid = sutTooLong.isValidPassportNumber
        
        // Assert
        XCTAssertFalse(isValid)
    }
    
    func test_isValidName_valid() {
        // Arrange
        let sut = "Катерина"
        let notAName2 = "1233456"
        let notAName3 = "1Катерина"
        
        // Act
        let isValid = sut.isValidName
        let isValid2 = notAName2.isValidName
        let isValid3 = notAName3.isValidName

        // Assert
        XCTAssertTrue(isValid)
        XCTAssertFalse(isValid2)
        XCTAssertFalse(isValid3)
    }
    
    func test_isValidName_invalid() {
        // Arrange
        let notAName1 = "1233456"
        let notAName2 = "1Катерина"
        let notAName3 = "Кате&ина"

        
        // Act
        let isValid1 = notAName1.isValidName
        let isValid2 = notAName2.isValidName
        let isValid3 = notAName3.isValidName

        // Assert
        XCTAssertFalse(isValid1)
        XCTAssertFalse(isValid2)
        XCTAssertFalse(isValid3)
    }
    
    func test_isValidUkrainianName_valid() {
        // Arrange
        let sut = "Катерина"
        
        // Act
        let isValid = sut.isValidUkrainianName
        
        // Assert
        XCTAssertTrue(isValid)
    }
    
    func test_isValidUkrainianName_invalid() {
        // Arrange
        let sut1 = "Katrin"
        let sut2 = "АлЁна"
        let sut3 = "Катерина123"
        
        // Act
        let isValid1 = sut1.isValidUkrainianName
        let isValid2 = sut2.isValidUkrainianName
        let isValid3 = sut3.isValidUkrainianName
        
        // Assert
        XCTAssertFalse(isValid1)
        XCTAssertFalse(isValid2)
        XCTAssertFalse(isValid3)
    }
    
    func test_isValidRussianName_valid() {
        // Arrange
        let sut = "АлЁна"
        
        // Act
        let isValid = sut.isValidRussianName
        
        // Assert
        XCTAssertTrue(isValid)
    }
    
    func test_isValidRussianName_invalid() {
        // Arrange
        let sut1 = "Katrin"
        let sut2 = "Катерина123"
        
        // Act
        let isValid1 = sut1.isValidRussianName
        let isValid2 = sut2.isValidRussianName
        
        // Assert
        XCTAssertFalse(isValid1)
        XCTAssertFalse(isValid2)
    }
    
    func test_onlyDigits_canMakeItClean() {
        // Arrange
        let sutWithLetters = "+38abc5557788"
        
        // Act
        let result = sutWithLetters.onlyDigits
        
        // Assert
        XCTAssertFalse(result.contains("a"))
        XCTAssertFalse(result.contains("b"))
        XCTAssertFalse(result.contains("c"))
        XCTAssertGreaterThan(result.count, 0)
        XCTAssertNotEqual(result.count, sutWithLetters.count)
    }
    
    func test_formattedPhoneNumber_canMakeItClean() {
        // Arrange
        let sutWithLetters = "+38abc5557788"

        // Act
        let result = sutWithLetters.formattedPhoneNumber()
        
        // Assert
        XCTAssertFalse(result.contains("a"))
        XCTAssertFalse(result.contains("b"))
        XCTAssertFalse(result.contains("c"))
        XCTAssertGreaterThan(result.count, 0)
    }
    
    func test_formattedPhoneNumber_canFormat() {
        // Arrange
        let sutWithPlus = "+380635557788"
        let sutWithoutPlus = "380635557788"

        // Act
        let result = sutWithPlus.formattedPhoneNumber()
        let result2 = sutWithoutPlus.formattedPhoneNumber()
        
        // Assert
        XCTAssertNotEqual(result.count, sutWithPlus.count)
        XCTAssertTrue(result.contains(" ")) // formatted and whitespaces where added
        XCTAssertTrue(result.contains("(") && result.contains(")")) // formatted and ( ) where added
        XCTAssertTrue(result2.contains("+")) // formatted and plus was added
    }
}
