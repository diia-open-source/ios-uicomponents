
import UIKit

public protocol ZoomAndSnapFlowLayoutDelegate: AnyObject {
    func didChangeIndexPathInTheMiddle(_ indexPath: IndexPath?)
}

public final class ZoomAndSnapFlowLayout: UICollectionViewFlowLayout {
    public var startCenterX: CGFloat?
    public var isCalculatedInsets = false
    public var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    public weak var delegate: ZoomAndSnapFlowLayoutDelegate?

    public init(itemSize: CGSize, minimumSpacing: CGFloat) {
        super.init()

        self.scrollDirection = .horizontal
        self.minimumLineSpacing = minimumSpacing
        self.itemSize = itemSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepare() {
        guard let collectionView = collectionView else { fatalError() }
        if !isCalculatedInsets {
            let verticalInsets = (collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom - itemSize.height) / 2
            let horizontalInsets = (collectionView.frame.width - collectionView.contentInset.right - collectionView.contentInset.left - itemSize.width) / 2
            sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
        }

        super.prepare()
        if cachedAttributes.isEmpty {
            for item in 0..<collectionView.numberOfItems(inSection: 0) {
                if let attributes = layoutAttributesForItem(at: IndexPath(item: item, section: 0)) {
                    cachedAttributes.append(attributes)
                }
            }
        }
    }

    public func indexPathOfItemAt(point: CGPoint) -> IndexPath? {
        for (index, attribute) in cachedAttributes.enumerated() {
            if attribute.frame.contains(point) {
                return IndexPath(item: index, section: 0)
            }
        }

        return nil
    }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard
            let collectionView = collectionView
        else { return nil }
        let copyRectAttributes = cachedAttributes
            .map { $0.copy() as? UICollectionViewLayoutAttributes }
            .compactMap { $0 }
            .filter { $0.frame.intersects(rect) }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        delegate?.didChangeIndexPathInTheMiddle(indexPathOfItemAt(point: CGPoint(x: visibleRect.midX, y: visibleRect.midY)))

        // Make the cells be zoomed when they reach the center of the screen
        for attributes in copyRectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / Constants.activeDistance
            
            let zoom: CGFloat
            if distance.magnitude < Constants.activeDistance {
                zoom = 1 - Constants.zoomFactor * normalizedDistance.magnitude
                attributes.zIndex = Int(zoom.rounded())
            } else {
                zoom = 1 - Constants.zoomFactor
            }
            let offset = attributes.bounds.width * (1 - zoom) / 2 * (normalizedDistance > 0 ? 1 : -1)
            
            attributes.transform = CGAffineTransform(scaleX: zoom, y: zoom).concatenating(CGAffineTransform(translationX: offset, y: 0))
        }

        return copyRectAttributes
    }

    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }

        // Add some snapping behaviour so that the zoomed cell is always centered
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }

        let velocityDirection = VelocityDirection(velocity: velocity.x)
        let collectionVisibleFrame: CGRect = .init(x: collectionView.contentOffset.x, y: 0, width: collectionView.bounds.width, height: 0)
        let isOldCenterGone = (startCenterX ?? collectionVisibleFrame.midX) < collectionVisibleFrame.minX || (startCenterX ?? collectionVisibleFrame.midX) > collectionVisibleFrame.maxX
        
        var offsetAdjustment: CGFloat = (isOldCenterGone || velocityDirection == .slow) ? .greatestFiniteMagnitude : .leastNormalMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2

        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            
            if isOldCenterGone || velocityDirection == .slow {
                if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                    offsetAdjustment = itemHorizontalCenter - horizontalCenter
                }
            } else if velocityDirection == .right {
                if itemHorizontalCenter > horizontalCenter {
                    offsetAdjustment = itemHorizontalCenter - horizontalCenter
                }
            } else if velocityDirection == .left {
                if itemHorizontalCenter < horizontalCenter {
                    offsetAdjustment = itemHorizontalCenter - horizontalCenter
                }
            }
        }
        
        startCenterX = nil
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }

    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }

    public override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        guard let context = super.invalidationContext(forBoundsChange: newBounds) as? UICollectionViewFlowLayoutInvalidationContext
        else { return UICollectionViewLayoutInvalidationContext() }
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        if context.invalidateFlowLayoutDelegateMetrics {
            cachedAttributes.removeAll()
        }
        return context
    }
    
    enum VelocityDirection {
        case fastLeft
        case left
        case slow
        case right
        case fastRight
        
        init(velocity: CGFloat) {
            switch velocity {
            case ..<(-Constants.velocityFastLimit):
                self = .fastLeft
            case -Constants.velocityFastLimit ..< -Constants.velocityLimit:
                self = .left
            case -Constants.velocityLimit ..< Constants.velocityLimit:
                self = .slow
            case Constants.velocityLimit ..< Constants.velocityFastLimit:
                self = .right
            case Constants.velocityFastLimit...:
                self = .fastRight
            default:
                self = .slow
            }
        }
    }
}

private extension ZoomAndSnapFlowLayout {
    enum Constants {
        static let velocityLimit: CGFloat = 0.2
        static let velocityFastLimit: CGFloat = 7.0
        static let minimumLineSpacing: CGFloat = 40
        static let activeDistance: CGFloat = 200
        static let zoomFactor: CGFloat = 0.12
        static let itemSize = CGSize(width: 150, height: 150)
    }
}
