import XCTest
@testable import DiiaUIComponents

final class Array_ExtensionTests: XCTestCase {

    func test_uniqued_unique() {
        // Arrange
        let expectedNumber: Int = 3
        let sut: [Int] = [1,2,3]
        
        // Act
        let clearCollection = sut.uniqued()
        
        // Assert
        XCTAssertEqual(clearCollection.count, expectedNumber)
    }

    func test_uniqued_notUnique() {
        // Arrange
        let expectedNumber: Int = 3
        let sut: [Int] = [1,2,3,1]
        
        // Act
        let clearCollection = sut.uniqued()
        
        // Assert
        XCTAssertEqual(clearCollection.count, expectedNumber)
    }
}
