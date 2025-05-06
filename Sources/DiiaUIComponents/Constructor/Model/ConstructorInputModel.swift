
import Foundation
import DiiaCommonTypes

public struct ConstructorInputModel {
    public let inputCode: String
    public let inputData: AnyCodable?
    
    public init(inputCode: String, inputData: AnyCodable?) {
        self.inputCode = inputCode
        self.inputData = inputData
    }
}
