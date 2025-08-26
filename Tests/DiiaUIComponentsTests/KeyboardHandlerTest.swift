
import XCTest
@testable import DiiaUIComponents

final class KeyboardHandlerTest: XCTestCase {
    private var sut: KeyboardHandler!
    private var superView: UIView = UIView(frame: .init(x: 10, y: 10, width: 20, height: 10))
    private var isOnShowKeyboardCalled = false
    private var isOnHideKeyboardCalled = false
    private let withoutInsetValue: CGFloat = 5.0
    private var keyboardConstraint: NSLayoutConstraint = .init()

    override func setUp() {
        sut = KeyboardHandler(type: .constraint(constraint: keyboardConstraint, withoutInset: withoutInsetValue, keyboardInset: 0.0, superview: superView))
        sut.onShowKeyboard = { [weak self] in
            self?.isOnShowKeyboardCalled = true
        }
        
        sut.onHideKeyboard = { [weak self] in
            self?.isOnHideKeyboardCalled = true
        }
    }

    // MARK: - KeyboardHandlingType is KeyboardHandlingType.constraint
    func test_handleKeyboard_tokensNumber() {
        // Arrange
        let expectedNumber: Int = 3
        
        // Act
        // init > handleKeyboard()
        
        // Assert
        XCTAssertEqual(sut.tokens.count, expectedNumber)
    }
    
    func test_keyboardWillShow_invalidNotification() {
        // Arrange
        let keyboardFrame = CGRect(x: 10.0, y: 10.0, width: 10.0, height: .zero)
        let stub = Notification(name: .stubNotification, userInfo: ["unexpectedKey": keyboardFrame])
        // Act
        sut.keyboardWillShow(stub)
        
        // Assert
        // checks that method type.implement(keyboardFrame: keyboardFrame) wasn't called
        XCTAssertFalse(isOnShowKeyboardCalled)
        XCTAssertFalse(isOnHideKeyboardCalled)
        XCTAssertNotEqual(keyboardConstraint.constant, withoutInsetValue)
    }
    
    func test_keyboardWillShow_validNotificationWithZeroHeightFrame() {
        // Arrange
        let keyboardFrame = CGRect(x: 10.0, y: 10.0, width: 10.0, height: .zero)
        let stub = Notification(name: .stubNotification, userInfo: [UIResponder.keyboardFrameEndUserInfoKey: keyboardFrame])
        // Act
        sut.keyboardWillShow(stub)
        
        // Assert
        XCTAssertTrue(isOnShowKeyboardCalled)
        XCTAssertFalse(isOnHideKeyboardCalled)
        XCTAssertEqual(keyboardConstraint.constant, withoutInsetValue)
    }
    
    func test_keyboardWillShow_validNotificationWithNotZeroHeightFrame() {
        // Arrange
        let keyboardFrame = CGRect(x: 10.0, y: 10.0, width: 10.0, height: 15.0)
        let stub = Notification(name: .stubNotification, userInfo: [UIResponder.keyboardFrameEndUserInfoKey: keyboardFrame])
        // Act
        sut.keyboardWillShow(stub)
        
        // Assert
        XCTAssertTrue(isOnShowKeyboardCalled)
        XCTAssertFalse(isOnHideKeyboardCalled)
        XCTAssertNotEqual(keyboardConstraint.constant, withoutInsetValue)
    }
    
    func test_keyboardWillHide_frameGoesToZero() {
        // Arrange
        let keyboardFrame = CGRect(x: 10.0, y: 10.0, width: 10.0, height: 15.0)
        let stub = Notification(name: .stubNotification, userInfo: [UIResponder.keyboardFrameEndUserInfoKey: keyboardFrame])
        // Act
        sut.keyboardWillHide(stub)
        
        // Assert
        XCTAssertFalse(isOnShowKeyboardCalled)
        XCTAssertTrue(isOnHideKeyboardCalled)
        XCTAssertEqual(keyboardConstraint.constant, withoutInsetValue)
    }
    
    // MARK: - KeyboardHandlingType is KeyboardHandlingType.scroll
    /*
    func test_keyboardWillShow_scrollTypeWithValidNotification() {
        // Arrange
        let offset: CGFloat = 17.0
        let keyboardFrame = CGRect(x: 10.0, y: 10.0, width: 10.0, height: 15.0)
        let stub = Notification(name: .stubNotification, userInfo: [UIResponder.keyboardFrameEndUserInfoKey: keyboardFrame])
        let scrollView = UIScrollView(frame: .zero)
        superView.addSubview(scrollView)
        sut = KeyboardHandler(type: .scroll(scrollView: UIScrollView(frame: .zero), offset: offset))
        
        // Act
        sut.keyboardWillShow(stub)
        
        // Assert
        let howMany = scrollView.contentInset
        
        
        print("howMany: \(howMany)")
        print("------")
    }
     */
}

private extension Notification.Name {
    static let stubNotification: NSNotification.Name = NSNotification.Name(rawValue: "KeyboardHandlerTest.stubNotification")
}
