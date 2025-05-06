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
    
    func test_percentEncodedUrl_returnsCorrectResult_forUrlString_withOneWhiteSpace() {
        checkIsPercentEncodedUrlStringCorrect(
            string: "https://www.example.com/start end",
            expectedResult: "https://www.example.com/start%20end"
        )
    }
    
    func test_percentEncodedUrl_returnsCorrectResult_forUrlString_withMultipleSpaces() {
        checkIsPercentEncodedUrlStringCorrect(
            string: "https://example.com/some path with spaces",
            expectedResult: "https://example.com/some%20path%20with%20spaces"
        )
    }
    
    func test_percentEncodedUrl_returnsCorrectResult_forUrlString_withoutWhitespace() {
        checkIsPercentEncodedUrlStringCorrect(
            string: "https://www.example.com",
            expectedResult: "https://www.example.com"
        )
    }
    
    func test_percentEncodedUrl_returnsCorrectResult_forUrlString_withEmptyQueryParameter() {
        checkIsPercentEncodedUrlStringCorrect(
            string: "https://example.com/anyPath?parameter=",
            expectedResult: "https://example.com/anyPath?parameter="
        )
    }
    
    func test_percentEncodedUrl_returnsCorrectResult_forUrlString_withMultipleQueryParameters() {
        checkIsPercentEncodedUrlStringCorrect(
            string: "https://example.com/anyPath?param1=value1&param2=value with space",
            expectedResult: "https://example.com/anyPath?param1=value1&param2=value%20with%20space"
        )
    }
    
    func test_percentEncodedUrl_returnsCorrectResult_forUrlString_withArrayQueryParameter() {
        checkIsPercentEncodedUrlStringCorrect(
            string: "https://example.com/anyPath?array[]=item1&array[]=item2",
            expectedResult: "https://example.com/anyPath?array%5B%5D=item1&array%5B%5D=item2"
        )
    }
    
    func test_percentEncodedUrl_returnsCorrectResult_forUrlString_withUnicodeCharacters() {
        checkIsPercentEncodedUrlStringCorrect(
            string: "https://example.com/emojiPath/😀",
            expectedResult: "https://example.com/emojiPath/%F0%9F%98%80"
        )
    }

    func test_percentEncodedUrl_returnsCorrectResult_forEmptyUrlString() {
        checkIsPercentEncodedUrlStringCorrect(
            string: "",
            expectedResult: ""
        )
    }
    
    func test_percentEncodedUrl_returnsNil_ifUrlStringIsInvalid() {
        let invalidUrlString = "ht!tp://any invalid url string"
        let errorMessage = "Given url string: \"\(invalidUrlString)\" - is valid. Should be invalid"
        
        let urlFromInvalidString = URL(string: invalidUrlString)
        XCTAssertNil(urlFromInvalidString, errorMessage)

        let nsurlFromInvalidString = NSURL(string: invalidUrlString)
        XCTAssertNil(nsurlFromInvalidString, errorMessage)

        checkIsPercentEncodedUrlStringCorrect(
            string: invalidUrlString,
            expectedResult: nil
        )
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
    
    // MARK: - Private
    private func checkIsPercentEncodedUrlStringCorrect(string: String,
                                                    expectedResult: String?,
                                                    file: StaticString = #filePath,
                                                    line: UInt = #line) {
        let result = string.percentEncodedUrl()
        XCTAssertEqual(result, expectedResult, file: file, line: line)
    }
}
