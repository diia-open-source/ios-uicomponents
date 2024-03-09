import XCTest
import DiiaCommonTypes
@testable import DiiaUIComponents

final class String_TextParameterTests: XCTestCase {

    private let numberOfAttributesBeforeEnrichment: Int = 2

    func test_asTextParameter() {
        // Arrange
        let sut = "teststring"
        
        // Act
        let newString = sut.asTextParameter()
        
        // Assert
        XCTAssertEqual(newString, "{" + sut + "}")
    }
    
    func test_attributedTextWithParameters_noParams() {
        // Arrange
        let sut = "test {toBeReplaced}"

        // Act
        let attributedString = sut.attributedTextWithParameters(parameters: nil)
        let dict = attributedString?.attributes(at: (attributedString?.string ?? "").count - 1, effectiveRange: nil)

        // Assert
        XCTAssertEqual(attributedString?.string, sut)
        XCTAssertEqual(numberOfAttributesBeforeEnrichment, dict?.count)
    }
    
    func test_attributedTextWithParameters_forTypeLink() {
        // Arrange
        let sut = "test {toBeReplaced}"
        let linkText = "linkText"
        let expectedText = linkText
        let expectedNumberOfAttributesAfterEnrichment: Int = numberOfAttributesBeforeEnrichment + 1
        let parameterData = TextParameterData(name: "toBeReplaced", alt: linkText, resource: "https://www.google.com")
        let textParameterLink = TextParameter(type: TextParameterType.link, data: parameterData)
        
        // Act
        let attributedString = sut.attributedTextWithParameters(parameters: [textParameterLink])
        let pureString = attributedString?.string
        let dict = attributedString?.attributes(at: (pureString ?? "").count - 1, effectiveRange: nil)

        // Assert
        XCTAssertNotEqual(pureString, sut)
        XCTAssertEqual(pureString, "test \(expectedText)")
        XCTAssertEqual(expectedNumberOfAttributesAfterEnrichment, dict?.count)
    }
    
    func test_attributedTextWithParameters_forTypeLinkIgnoredIfWrongReplacement() {
        // Arrange
        let sut = "test {toBeReplaced}"
        let linkText = "linkText"
        let expectedText = linkText
        let parameterData = TextParameterData(name: "_WrongReplacement_", alt: linkText, resource: "https://www.google.com")
        let textParameterLink = TextParameter(type: TextParameterType.link, data: parameterData)
        
        // Act
        let attributedString = sut.attributedTextWithParameters(parameters: [textParameterLink])
        let pureString = attributedString?.string
        let dict = attributedString?.attributes(at: (pureString ?? "").count - 1, effectiveRange: nil)

        // Assert
        XCTAssertEqual(pureString, sut) // nothing changed
        XCTAssertNotEqual(pureString, "test \(expectedText)")
        XCTAssertEqual(numberOfAttributesBeforeEnrichment, dict?.count)
    }
    
    func test_attributedTextWithParameters_forTypePhoneAndValidNumber() {
        // Arrange
        let sut = "test {toBeReplaced}"
        let phoneNumber = "phoneNumber"
        let expectedText = phoneNumber
        let expectedNumberOfAttributesAfterEnrichment: Int = numberOfAttributesBeforeEnrichment + 1
        let parameterData = TextParameterData(name: "toBeReplaced", alt: phoneNumber, resource: "380998887766")
        let textParameterLink = TextParameter(type: TextParameterType.phone, data: parameterData)
        
        // Act
        let attributedString = sut.attributedTextWithParameters(parameters: [textParameterLink])
        let pureString = attributedString?.string
        let dict = attributedString?.attributes(at: (pureString ?? "").count - 1, effectiveRange: nil)

        // Assert
        XCTAssertNotEqual(pureString, sut)
        XCTAssertEqual(pureString, "test \(expectedText)")
        XCTAssertEqual(expectedNumberOfAttributesAfterEnrichment, dict?.count)
    }
    
    func test_attributedTextWithParameters_forTypePhoneAndInvalidNumber() {
        // Arrange
        let sut = "test {toBeReplaced}"
        let phoneNumber = "phoneNumber"
        let expectedText = phoneNumber
        let parameterData = TextParameterData(name: "toBeReplaced", alt: phoneNumber, resource: "notAPhoneNumber")
        let textParameterLink = TextParameter(type: TextParameterType.phone, data: parameterData)
        
        // Act
        let attributedString = sut.attributedTextWithParameters(parameters: [textParameterLink])
        let pureString = attributedString?.string
        let dict = attributedString?.attributes(at: (pureString ?? "").count - 1, effectiveRange: nil)

        // Assert
        XCTAssertNotEqual(pureString, sut)
        XCTAssertEqual(pureString, "test \(expectedText)")
        XCTAssertEqual(numberOfAttributesBeforeEnrichment, dict?.count)
    }
    
    func test_attributedTextWithParameters_forTypeEmailAndValidEmail() {
        // Arrange
        let sut = "test {toBeReplaced}"
        let emailText = "emailText"
        let expectedText = emailText
        let expectedNumberOfAttributesAfterEnrichment: Int = numberOfAttributesBeforeEnrichment + 1
        let parameterData = TextParameterData(name: "toBeReplaced", alt: emailText, resource: "myemail@test.com")
        let textParameterLink = TextParameter(type: TextParameterType.email, data: parameterData)
        
        // Act
        let attributedString = sut.attributedTextWithParameters(parameters: [textParameterLink])
        let pureString = attributedString?.string
        let dict = attributedString?.attributes(at: (pureString ?? "").count - 1, effectiveRange: nil)

        // Assert
        XCTAssertNotEqual(pureString, sut)
        XCTAssertEqual(pureString, "test \(expectedText)")
        XCTAssertEqual(expectedNumberOfAttributesAfterEnrichment, dict?.count)
    }
    
    func test_attributedTextWithParameters_forTypeEmailAndInvalidEmail() {
        // Arrange
        let sut = "test {toBeReplaced}"
        let emailText = "emailText"
        let expectedText = emailText
        let parameterData = TextParameterData(name: "toBeReplaced", alt: emailText, resource: "email")
        let textParameterLink = TextParameter(type: TextParameterType.email, data: parameterData)
        
        // Act
        let attributedString = sut.attributedTextWithParameters(parameters: [textParameterLink])
        let pureString = attributedString?.string
        let dict = attributedString?.attributes(at: (pureString ?? "").count - 1, effectiveRange: nil)
        
        // Assert
        XCTAssertNotEqual(pureString, sut)
        XCTAssertEqual(pureString, "test \(expectedText)")
        XCTAssertEqual(numberOfAttributesBeforeEnrichment, dict?.count)
    }
}
