import UIKit
@testable import DiiaUIComponents

final class RoundedTabSwitcherCollectionCellMirror: ReflectionObject {
    init(tableCell: RoundedTabSwitcherCollectionCell) {
        super.init(reflecting: tableCell)
    }
    
    var titleLabel: UILabel? {
        extractVariable()
    }
}
