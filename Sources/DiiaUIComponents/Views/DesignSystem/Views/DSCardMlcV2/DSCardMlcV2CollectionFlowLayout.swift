
import UIKit

final public class DSCardMlcV2CollectionFlowLayout: UICollectionViewFlowLayout {
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                var frame = layoutAttribute.frame
                frame.origin.x = leftMargin
                layoutAttribute.frame = frame
                leftMargin += frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        
        return attributes
    }
}
