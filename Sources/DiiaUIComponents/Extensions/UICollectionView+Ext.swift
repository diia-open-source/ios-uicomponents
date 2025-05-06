
import UIKit

extension UICollectionView {
    final func isCellFullyVisible(at indexPath: IndexPath) -> Bool {
        guard let cellLayoutAttributes = layoutAttributesForItem(at: indexPath)
        else { return false }
        return bounds.contains(cellLayoutAttributes.frame)
    }
}
