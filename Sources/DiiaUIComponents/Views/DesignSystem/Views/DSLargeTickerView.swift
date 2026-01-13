
import UIKit
import DiiaCommonTypes

public final class DSLargeTickerViewModel {
    public let usage: DSTickerUsage
    public var type: Observable<DSTickerType>
    public var text: Observable<String>
    public let action: DSActionParameter?
    public let componentId: String?
    
    public init(usage: DSTickerUsage, type: Observable<DSTickerType> = .init(value: .neutral), text: Observable<String>, action: DSActionParameter?, componentId: String?) {
        self.usage = usage
        self.type = type
        self.text = text
        self.action = action
        self.componentId = componentId
    }
}

//ds_code: largeTickerAtm
public final class DSLargeTickerView: BaseCodeView, AnimatedViewProtocol {
    
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
    public func configure(with viewModel: DSLargeTickerViewModel) {
        viewModel.type.removeObserver(observer: self)
        viewModel.text.removeObserver(observer: self)
        accessibilityIdentifier = viewModel.componentId
        withHeight(viewModel.usage.height)
        viewModel.type.observe(observer: self) { [weak self] type in
            self?.setupBackground(with: viewModel.type.value)
        }
        viewModel.text.observe(observer: self) { [weak self] newText in
            guard let self = self else { return }
            guard self.text != newText else { return }
            self.stopAnimation()
            self.text = newText
            self.adjustLabelSize()
            self.startAnimation()
        }
        
        label.textColor = viewModel.type.value.textColor
        
    }
    
    public func configure(with model: DSTickerAtom) {
        accessibilityIdentifier = model.componentId
        withHeight(model.usage.height)
        setupBackground(with:  model.type)
        label.textColor = model.type.textColor
        text = model.value
        setupBackground(with: model.type)
    }
    
    public func startAnimation() {
        if isAnimating {
            stopAnimation()
        }
        
        resetLabelFrame()
        guard label.frame.width > scrollView.frame.width else {
               return
           }

        let animationDistance = label.frame.width / 2
        let animationDuration = TimeInterval(animationDistance / CGFloat(Constants.animationSpeed))

        UIView.animate(
            withDuration: animationDuration,
            delay: 0.5,
            options: [.curveLinear, .repeat],
            animations: {
                self.label.frame.origin.x = -animationDistance
            }
        )

        isAnimating = true
    }
    
    private func calculateTextWidth(font: UIFont, text: String) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width
    }

    private func resetLabelFrame() {
        label.frame.origin.x = Constants.leadingPadding
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
        label.numberOfLines = 1
        backgroundView.fillSuperview()
        scrollView.fillSuperview()
    }
    
    private func setupBackground(with type: DSTickerType) {
        backgroundView.image = type.backgroundImage
    }
            
    private func adjustLabelSize() {
        var repeatedText = text
        let containerWidth = frame.width

        while calculateTextWidth(font: label.font, text: repeatedText) < containerWidth * 3 {
            repeatedText += text
        }

        label.text = repeatedText
        label.sizeToFit()
        label.frame = CGRect(
            x: Constants.leadingPadding,
            y: .zero,
            width: label.intrinsicContentSize.width,
            height: frame.size.height
        )
    }

}

extension DSLargeTickerView {
    private enum Constants {
        static let animationDelay: CGFloat = 0.5
        static let animationSpeed = 50
        static let leadingPadding: CGFloat = 16
    }
}
