
import XCTest
@testable import DiiaUIComponents

class RoundedTabSwitcherViewTests: XCTestCase {
    private var viewModel: TabSwitcherViewModelMock!
    
    override func setUp() {
        super.setUp()
        
        viewModel = TabSwitcherViewModelMock(items: TabSwitcherModelStub.data)
    }
    
    override func tearDown() {
        viewModel = nil
        
        super.tearDown()
    }
    
    func test_tabsSwitcher_awakeFromNib() {
        // Arrange
        let sut = makeSUT()
        let viewMirror = RoundedTabSwitcherViewMirror(view: sut)
        
        // Act
        sut.awakeFromNib()
        
        // Assert
        XCTAssertNotNil(viewMirror.collectionView?.dataSource)
        XCTAssertNotNil(viewMirror.collectionView?.delegate)
    }
    
    func test_tabsSwitcher_configure_numberOfItems() {
        // Arrange
        let sut = makeSUT()
        let viewMirror = RoundedTabSwitcherViewMirror(view: sut)
        let expectedValue = viewModel.items.count
        
        // Act
        sut.awakeFromNib()
        sut.configure(viewModel: viewModel)
        let actualValue = viewMirror.collectionView?.numberOfItems(inSection: .zero)
        
        // Assert
        XCTAssertEqual(actualValue, expectedValue)
    }
    
    func test_tabsSwitcher_configure_cellForItems() {
        // Arrange
        let sut = makeSUT()
        let viewMirror = RoundedTabSwitcherViewMirror(view: sut)
        let expectedValue = viewModel.itemAt(index: .zero)
        
        // Act
        sut.awakeFromNib()
        sut.configure(viewModel: viewModel)
        guard let cell = viewMirror.collectionView?.dataSource?.collectionView(viewMirror.collectionView ?? UICollectionView(),
                                                                 cellForItemAt: .init(item: .zero, section: .zero)) as? RoundedTabSwitcherCollectionCell else {
            XCTFail("Cell doesn't exist")
            return
        }
        let cellMirror = RoundedTabSwitcherCollectionCellMirror(tableCell: cell)
        let actualNameValue = cellMirror.titleLabel?.text
        
        // Assert
        XCTAssertEqual(actualNameValue, expectedValue?.title)
    }
    
    func test_tabsSwitcher_configure_selectItem() {
        // Arrange
        let sut = makeSUT()
        let viewMirror = RoundedTabSwitcherViewMirror(view: sut)
        let indexPath = IndexPath(row: .zero, section: .zero)
        
        // Act
        sut.awakeFromNib()
        sut.configure(viewModel: viewModel)
        viewMirror.collectionView?.delegate?.collectionView!(viewMirror.collectionView!, didSelectItemAt: indexPath) // swiftlint:disable:this force_unwrapping
        
        // Assert
        XCTAssertTrue(viewModel.isTabSelected)
    }
    
    // MARK: - Helpers
    private func makeSUT() -> RoundedTabSwitcherView {
        return .init()
    }
}
