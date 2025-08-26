
import UIKit
@testable import DiiaUIComponents

final class RoundedTabSwitcherViewMirror: ReflectionObject {
    init(view: RoundedTabSwitcherView) {
        super.init(reflecting: view)
    }
    
    var collectionView: UICollectionView? {
        extractVariable()
    }
}
