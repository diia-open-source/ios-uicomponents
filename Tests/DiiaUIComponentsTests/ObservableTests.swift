import XCTest
@testable import DiiaUIComponents

final class ObservableTests: XCTestCase {

    // it's pseudo asynchronous test
    func test_observe() {
        // Arrange
        let vm = GalleryVideoViewModel(streamLink: nil, downloadLink: "downloadLink")
        let observerTillEndOfScoupe = Observer()

        let expectation = expectation(description: "state changing arrived")
        vm.state.observe(observer: observerTillEndOfScoupe) { state in
            switch state {
            case .loading: // initial value of vm's state
                break
            case .error(message: _):
                expectation.fulfill()
                break
            case .readyForPlaying(url: _):
                XCTFail("event is not expected here")
                break
            }
        }
        
        // Act
        vm.state.value = .error(message: "error message stub")
        
        // Assert
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_removeObserver() {
        // Arrange
        let vm = GalleryVideoViewModel(streamLink: nil, downloadLink: "downloadLink")
        let observerTillEndOfScoupe = Observer()

        vm.state.observe(observer: observerTillEndOfScoupe) { state in
            switch state {
            case .loading: // initial value of vm's state
                break
            case .error(message: _):
                // Assert
                XCTFail("event is not expected here, once removeObserver is called before changing Observable.value")
                break
            case .readyForPlaying(url: _):
                break
            }
        }
        
        // Act
        vm.state.removeObserver(observer: observerTillEndOfScoupe)
        vm.state.value = .error(message: "error message stub")
    }
    
    func test_observe_subcsribtionIsDiscardedIfNooneHoldsObserver() {
        // Arrange
        let vm = GalleryVideoViewModel(streamLink: nil, downloadLink: "downloadLink")
        // shortLiveObserver, it not allowed to be alive till the end of scope
        vm.state.observe(observer: Observer()) { state in
            switch state {
            case .loading: // initial value of vm's state
                break
            case .error(message: _):
                // Assert
                XCTFail("event is not expected here, once Observation must be called before performing callback")
                break
            case .readyForPlaying(url: _):
                XCTFail("event is not expected here")
                break
            }
        }
        
        // Act
        vm.state.value = .error(message: "error message stub")
    }
}


final class Observer: NSObject {
    
}
