import XCTest
@testable import DiiaUIComponents

final class StepCounterTests: XCTestCase {
    private var sut: StepCounter!
    
    func test_incrementingCurrentStep() {
        // Arrange
        let total: Int = 5
        let current: Int = 2
        sut = StepCounter(numberOfSteps: total, currentStep: current)
        
        // Act
        let copy = sut.incrementingCurrentStep()
        
        // Assert
        XCTAssertNotEqual(copy.currentStep, current)
        XCTAssertEqual(copy.numberOfSteps, total)
    }
    
    func test_initFirstStepInNumberOfSteps() {
        // Arrange
        let total: Int = 5
        
        // Act
        sut = StepCounter(firstStepInNumberOfSteps: total)
        
        // Assert
        XCTAssertNotEqual(sut.currentStep, sut.numberOfSteps)
    }
    
    func test_initLastStepInNumberOfSteps() {
        // Arrange
        let total: Int = 5
        
        // Act
        sut = StepCounter(lastStepInNumberOfSteps: total)
        
        // Assert
        XCTAssertEqual(sut.numberOfSteps, sut.currentStep)
    }

}
