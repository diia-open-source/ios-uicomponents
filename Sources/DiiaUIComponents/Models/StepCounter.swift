import Foundation

public struct StepCounter {
    public let numberOfSteps: Int
    public let currentStep: Int
    
    public init(numberOfSteps: Int, currentStep: Int) {
        self.numberOfSteps = numberOfSteps
        self.currentStep = currentStep
    }
    
    public init(firstStepInNumberOfSteps: Int) {
        self.currentStep = 1
        self.numberOfSteps = firstStepInNumberOfSteps
    }
    
    public init(lastStepInNumberOfSteps: Int) {
        self.currentStep = lastStepInNumberOfSteps
        self.numberOfSteps = lastStepInNumberOfSteps
    }
    
    public func incrementingCurrentStep() -> StepCounter {
        return StepCounter(numberOfSteps: self.numberOfSteps,
                           currentStep: self.currentStep+1)
    }
}
