
import UIKit

public protocol ScrollingPageControlDelegate: AnyObject {
    //    If delegate is nil or the implementation returns nil for a given dot, the default
    //    circle will be used. Returned views should react to having their tint color changed
    func viewForDot(at index: Int) -> UIView?
}

/// A delegate that defines methods for handling accessibility scrolling actions in a scrolling page control.
public protocol ScrollingPageControlAccessibilityActionsDelegate: AnyObject {
    /// Called when accessibility increment/decrement action is performed.
    /// - Parameter direction: The direction of the scrolling action.
    func onScroll(direction: UIAccessibilityScrollDirection)
}

open class ScrollingPageControl: UIView {
    open weak var delegate: ScrollingPageControlDelegate? {
        didSet {
            createViews()
        }
    }
    open weak var accessibilityActionsDelegate: ScrollingPageControlAccessibilityActionsDelegate?
    
    //    The number of dots
    open var pages: Int = 0 {
        didSet {
            guard pages != oldValue else { return }
            pages = max(0, pages)
            invalidateIntrinsicContentSize()
            createViews()
        }
    }
    private func createViews() {
        dotViews = (0..<pages).map { index in
            delegate?.viewForDot(at: index) ?? CircularView(frame: CGRect(origin: .zero, size: CGSize(width: dotSize, height: dotSize)))
        }
    }
    //    The index of the currently selected page
    open var selectedPage: Int = 0 {
        didSet {
            guard selectedPage != oldValue else { return }
            selectedPage = max(0, min(selectedPage, pages - 1))
            updateColors()
            if (0..<centerDots).contains(selectedPage - pageOffset) {
                centerOffset = selectedPage - pageOffset
            } else {
                pageOffset = selectedPage - centerOffset
            }
            updatePositions()
        }
    }
    //    The maximum number of dots that will show in the control
    open var maxDots = 7 {
        didSet {
            maxDots = max(3, maxDots)
            invalidateIntrinsicContentSize()
            updatePositions()
        }
    }
    //    The number of dots that will be centered and full-sized
    open var centerDots = 3 {
        didSet {
            centerDots = max(1, centerDots)
            updatePositions()
        }
    }
    //    The duration, in seconds, of the dot slide animation
    open var slideDuration: TimeInterval = 0.15
    private var centerOffset = 0
    private var pageOffset = 0 {
        didSet {
            UIView.animate(withDuration: slideDuration, delay: 0.15, options: [], animations: self.updatePositions, completion: nil)
        }
    }
    
    internal var dotViews: [UIView] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            dotViews.forEach(addSubview)
            updateColors()
            updatePositions()
        }
    }
    
    //    The color of all the unselected dots
    open var dotColor = UIColor.lightGray { didSet { updateColors() } }
    //    The color of the currently selected dot
    open var selectedColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) { didSet { updateColors() } }
    
    //    The size of the dots
    open var dotSize: CGFloat = 8 {
        didSet {
            dotSize = max(1, dotSize)
            dotViews.forEach { $0.frame = CGRect(origin: .zero, size: CGSize(width: dotSize, height: dotSize)) }
            updatePositions()
        }
    }
    //    The space between dots
    open var spacing: CGFloat = 8 {
        didSet {
            spacing = max(1, spacing)
            updatePositions()
        }
    }
    
    public init() {
        super.init(frame: .zero)
        isOpaque = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }
    
    private var lastSize = CGSize.zero
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.size != lastSize else { return }
        lastSize = bounds.size
        updatePositions()
    }
    
    private func updateColors() {
        dotViews.enumerated().forEach { page, dot in
            dot.tintColor = page == selectedPage ? selectedColor : dotColor
        }
    }
    
    internal func updatePositions() {
        let sidePages = (maxDots - centerDots) / 2
        let horizontalOffset = CGFloat(-pageOffset + sidePages) * (dotSize + spacing) + (bounds.width - intrinsicContentSize.width) / 2
        let centerPage = centerDots / 2 + pageOffset
        dotViews.enumerated().forEach { page, dot in
            let center = CGPoint(x: horizontalOffset + bounds.minX + dotSize / 2 + (dotSize + spacing) * CGFloat(page),
                                 y: bounds.midY)
            let scale: CGFloat = page == self.selectedPage ? Constants.selectedPageScale : {
                let distance = abs(page - centerPage)
                let middleDot = maxDots / 2 + maxDots % 2
                if distance > middleDot || (distance == middleDot && page <= distance && maxDots >= 6) { return 0 }
                return Constants.pageScales[max(0, min(2, distance - centerDots / 2))]
            }()
            dot.frame = CGRect(origin: .zero, size: CGSize(width: dotSize * scale, height: dotSize * scale))
            dot.center = center
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        let pages = min(maxDots, self.pages)
        let width = CGFloat(pages) * dotSize + CGFloat(pages - 1) * spacing
        let height = dotSize
        return CGSize(width: width, height: height)
    }
    
    open override func accessibilityIncrement() {
        if selectedPage >= .zero && selectedPage < pages {
            accessibilityActionsDelegate?.onScroll(direction: .left)
        }
    }
    
    open override func accessibilityDecrement() {
        if selectedPage > .zero && selectedPage <= pages {
            accessibilityActionsDelegate?.onScroll(direction: .right)
        }
    }
}

// MARK: - Constants
extension ScrollingPageControl {
    private enum Constants {
        static var selectedPageScale: CGFloat = 1
        static var pageScales: [CGFloat] = [1, 0.75, 0.5]
    }
}
