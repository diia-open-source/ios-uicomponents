import XCTest
@testable import DiiaUIComponents

final class TextValidationErrorGeneratorTests: XCTestCase {

    private var sut: TextValidationErrorGenerator!
    private let errorString = "TextValidationErrorGeneratorTests.errorString"
    
    func test_validationError_valid() {
        // Arrange
        let validator: TextValidator = TextValidator.none
        sut = TextValidationErrorGenerator(type: validator, error: errorString)
        
        // Act
        let validationErrorWithText = sut.validationError(text: "anytext")
        let validationErrorWithoutText = sut.validationError(text: nil)

        
        // Assert
        XCTAssertNil(validationErrorWithText)
    }

    func test_validationError_invalid() {
        // Arrange
        let validator: TextValidator = TextValidator.none
        sut = TextValidationErrorGenerator(type: validator, error: errorString)
        
        // Act
        let validationErrorWithoutText = sut.validationError(text: nil)

        
        // Assert
        XCTAssertNotNil(validationErrorWithoutText)
    }
    
}
