import XCTest
@testable import DiiaUIComponents

final class String_ExtensionsTests: XCTestCase {

    func test_attributed_defaultValues() {
        // Arrange
        let sut = "baseString"
        let expectedNumberOfAttributes = 4 // NSFont, NSParagraphStyle, NSBackgroundColor, NSColor
        
        // Act
        let attributedString = sut.attributed(font: .systemFont(ofSize: 12.0))
        let dict = attributedString?.attributes(at: (attributedString?.string ?? "").count - 1, effectiveRange: nil)
        let howMany = dict?.count
        
        // Assert
        XCTAssertEqual(howMany, expectedNumberOfAttributes)
    }
    
    func test_attributed_withLineSpacing() {
        // Arrange
        let sut = "baseString"
        let expectedNumberOfAttributes = 5 // NSFont, NSParagraphStyle, NSBackgroundColor, NSColor, NSBaselineOffset
        
        // Act
        let attributedString = sut.attributed(font: .systemFont(ofSize: 12.0),
                                              lineSpacing: 5.0)
        let dict = attributedString?.attributes(at: (attributedString?.string ?? "").count - 1, effectiveRange: nil)
        let howMany = dict?.count
        
        // Assert
        XCTAssertEqual(howMany, expectedNumberOfAttributes)
    }
    
    func test_capitalizingFirstLetter() {
        // Arrange
        let sut = "allInLowerCase"
        let sut2 = "Firstiscapital"
        let sut3 = "manyCapitalLetters"
        let expectedForSut3 = "Manycapitalletters"
        
        // Act
        let result = sut.capitalizingFirstLetter()
        let result2 = sut2.capitalizingFirstLetter()
        let result3 = sut3.capitalizingFirstLetter()
        
        // Assert
        XCTAssertNotEqual(sut, result)
        XCTAssertEqual(sut2, result2) // nothing changed
        XCTAssertEqual(result3, expectedForSut3)
    }
    
    func test_cleanedFromQuery() {
        // Arrange
        let sut = "aaa+ bbb+ccc"
        let expected = "aaa  bbb ccc"
        
        // Act
        let cleaned = sut.cleanedFromQuery()
        
        // Assert
        XCTAssertNotEqual(sut, cleaned)
        XCTAssertEqual(cleaned, expected)
    }
    
    func test_passesMod97Check_passed() {
        // Arrange
        let sut = "GB33BUKB20201555555555" // official source https://www.iban.com/testibans

        // Act
        let isValid = sut.passesMod97Check()
        
        // Assert
        XCTAssertTrue(isValid)
    }
    
    func test_passesMod97Check_notPassed() {
        
        // Arrange
        let sutWrong = "sd1234abcd78965"
        let sutTooShort = "sd1"
        let sutBadSymbol = "sd1234a&cd78965h"
        
        // Act
        let isValid1 = sutWrong.passesMod97Check()
        let isValid2 = sutTooShort.passesMod97Check()
        let isValid3 = sutBadSymbol.passesMod97Check()
        
        // Assert
        XCTAssertFalse(isValid1)
        XCTAssertFalse(isValid2)
        XCTAssertFalse(isValid3)
    }
    
    func test_deletingPrefix() {
        // Arrange
        let prefix = "38"
        let sut = "38string"
        let sutWithoutPrefix = "secondString"

        let expectedResult = "string"
        
        // Act
        let result = sut.deletingPrefix(prefix)
        let valueNotChanged = sutWithoutPrefix.deletingPrefix(prefix)
        
        // Assert
        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(sutWithoutPrefix, valueNotChanged)
    }
    
    func test_withPhoneSpaces() {
        // Arrange
        let phone = "380998887766"

        XCTAssertFalse(phone.contains(" "))
        XCTAssertFalse(phone.contains("+"))
        
        // Act
        let modifiedPhone = phone.withPhoneSpaces
        
        // Assert
        XCTAssertTrue(modifiedPhone.contains(" "))
        XCTAssertTrue(modifiedPhone.contains("+"))
        XCTAssertNotEqual(phone.count, modifiedPhone.count)
    }
    
    func test_percentEncodedUrl() {
        // Arrange
        let sutWithoutGaps = "https://www.google.com"
        let sutWithGaps = "https://www.google.com/start end"

        // Act
        let modifiedWithoutGaps = sutWithoutGaps.percentEncodedUrl()
        let modifiedWithGaps = sutWithGaps.percentEncodedUrl()
        
        // Assert
        XCTAssertEqual(sutWithoutGaps, modifiedWithoutGaps)
        XCTAssertNotEqual(sutWithGaps, modifiedWithGaps)
    }
    
    
    func test_withoutSpaces() {
        // Arrange
        let sutWithGaps = "https start end"

        // Act
        let modifiedWithGaps = sutWithGaps.withoutSpaces
        
        // Assert
        XCTAssertNotEqual(sutWithGaps, modifiedWithGaps)
        XCTAssertGreaterThan(sutWithGaps.count, modifiedWithGaps.count)
        XCTAssertFalse(modifiedWithGaps.contains(" "))
    }
    
    func test_condenseWhitespace() {
        // Arrange
        let sut = "sta   r t"
        let expected = "sta r t"
        
        // Act
        let modified = sut.condenseWhitespace()
        
        // Assert
        XCTAssertEqual(modified, expected)
    }
    
    func test_reversedStr() {
        // Arrange
        let sut = "end"
        let expected = "dne"
        
        // Act
        let modified = sut.reversedStr
        
        // Assert
        XCTAssertEqual(modified, expected)
    }
    
    func test_digits() {
        // Arrange
        let sut = "3e7nd5"
        let expected = "375"
        
        // Act
        let modified = sut.digits
        
        // Assert
        XCTAssertEqual(modified, expected)
    }
    
    func test_letters() {
        // Arrange
        let sut = "3e7nd5"
        let expected = "end"
        
        // Act
        let modified = sut.letters
        
        // Assert
        XCTAssertEqual(modified, expected)
    }
    
    func test_characterAtIndex() {
        // Arrange
        let sut = "start"
        let first = "s"
        let last = "t"

        // Act
        let result1 = sut.character(at: 0)
        let result2 = sut.character(at: 4)
        let resultForOutOfBounds = sut.character(at: sut.count + 1)
        
        // Assert
        XCTAssertEqual(result1, first)
        XCTAssertEqual(result2, last)
        XCTAssertNil(resultForOutOfBounds)
    }
    
    func test_isNumberOrEmpty() {
        
        // Arrange
        let string = "start"
        let number = "123"
        let empty = ""
        
        // Act
        let resultString = string.isNumberOrEmpty
        let resultNumber = number.isNumberOrEmpty
        let resultEmpty = empty.isNumberOrEmpty

        // Assert
        XCTAssertFalse(resultString)
        XCTAssertTrue(resultNumber)
        XCTAssertTrue(resultEmpty)
    }
    
    func test_isNumber() {
        
        // Arrange
        let string = "start"
        let number = "123"
        
        // Act
        let resultString = string.isNumber
        let resultNumber = number.isNumber

        // Assert
        XCTAssertFalse(resultString)
        XCTAssertTrue(resultNumber)
    }
    
    func test_withPDFExtension() {
        
        // Arrange
        let stringWith = "start.pdf"
        let stringWithout = "start"
        
        // Act
        let resultStringWith = stringWith.withPDFExtension
        let resultStringWithout = stringWithout.withPDFExtension

        // Assert
        XCTAssertTrue(resultStringWith.contains(".pdf"))
        XCTAssertTrue(resultStringWithout.contains(".pdf"))
    }
}
