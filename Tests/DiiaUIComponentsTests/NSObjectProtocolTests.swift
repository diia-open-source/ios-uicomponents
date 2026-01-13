
import XCTest
@testable import DiiaUIComponents

private final class MockObject: NSObject {
    @objc dynamic var isSelected: Bool
    
    init(isSelected: Bool = false) {
        self.isSelected = isSelected
        super.init()
    }
}

final class NSObjectProtocolTests: XCTestCase {
    func test_observe() {
        // given
        let sut = MockObject()
        var isObserved = false
        
        // when
        let isSelectedObservation = sut.observe(\.isSelected) { value in
            isObserved  = value
        }
        sut.isSelected = true
        
        // then
        XCTAssertNotNil(isSelectedObservation)
        XCTAssertTrue(isObserved)
    }
}
