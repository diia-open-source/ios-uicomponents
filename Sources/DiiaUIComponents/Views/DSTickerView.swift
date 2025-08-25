
import UIKit
import DiiaCommonTypes

/// design_system_code: tickerAtm
public class DSTickerView: BaseCodeView, AnimatedViewProtocol {
    
    private let scrollView = UIScrollView()
    private let backgroundView = UIImageView()
    private let label = UILabel().withParameters(font: FontBook.usualFont)
    
    // MARK: - Properties
    private var originalTextWidth: CGFloat = .zero
    private var isAnimating = false
    private var text: String = .empty {
        didSet {
            label.text = text
        }
    }
    
    // MARK: - Init
    public override func setupSubviews() {
        initialSetup()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !text.isEmpty else { return }
        adjustLabelSize()
        startAnimation()
    }
    
    // MARK: - Public Methods
    public func configure(with model: DSTickerAtom) {
        accessibilityIdentifier = model.componentId
        withHeight(model.usage.height)
        
        backgroundView.image = model.type.backgroundImage
        label.textColor = model.type.textColor
        text = model.value
        
        accessibilityLabel = model.value
    }
    
    public func startAnimation() {
        if isAnimating {
            stopAnimation()
        }
        resetLabelFrame()
        animateLabel()
        isAnimating = true
    }
    
    public func stopAnimation() {
        label.layer.removeAllAnimations()
        isAnimating = false
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        
        addSubviews([backgroundView, scrollView])
        scrollView.addSubview(label)
        
        backgroundView.fillSuperview()
        scrollView.fillSuperview()
        
        setupAccessibility()
    }
    
    private func animateLabel() {
        UIView.animate(
            withDuration: TimeInterval(text.count / Constants.animationSpeed),
            delay: Constants.animationDelay,
            options: [.curveLinear, .repeat],
            animations: {
                self.label.frame.origin.x = -self.originalTextWidth + Constants.leadingPadding
            })
    }
    
    private func resetLabelFrame() {
        label.frame.origin.x = Constants.leadingPadding
    }
    
    private func adjustLabelSize() {
        while label.intrinsicContentSize.width < frame.width {
            text += text
        }
        
        if originalTextWidth == .zero {
            originalTextWidth = label.intrinsicContentSize.width
            text += text
        }
        
        label.frame = CGRect(
            x: Constants.leadingPadding,
            y: .zero,
            width: label.intrinsicContentSize.width,
            height: frame.size.height)
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .staticText
    }
}

// MARK: - Constants
extension DSTickerView {
    private enum Constants {
        static let animationDelay: CGFloat = 0.5
        static let animationSpeed = 10
        static let leadingPadding: CGFloat = 16
    }
}
