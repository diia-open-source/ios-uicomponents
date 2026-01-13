
import UIKit
import DiiaCommonTypes

public final class IconedLoadingStateViewModel: NSObject {
    public let name: String
    public let image: UIImage?
    public let componentId: String?
    public var clickHandler: Callback?
    @objc public dynamic var isLoading: Bool
    public let loadingImage: UIImage?
    
    public init(name: String,
                image: UIImage?,
                clickHandler: Callback? = nil,
                isLoading: Bool = false,
                componentId: String? = nil,
                loadingImage: UIImage? = nil) {
        self.name = name
        self.image = image
        self.clickHandler = clickHandler
        self.isLoading = isLoading
        self.componentId = componentId
        self.loadingImage = loadingImage
    }
}

public final class IconedLoadingStateView: BaseCodeView {
    private var mainStack: UIStackView?
    private let imageView: UIImageView = UIImageView().withSize(Constants.iconSize)
    private let label: UILabel = UILabel().withParameters(font: FontBook.usualFont)
    
    private var observation: NSKeyValueObservation?
    private var viewModel: IconedLoadingStateViewModel?
    
    public override func setupSubviews() {
        mainStack = hstack(imageView, label, spacing: Constants.spacing, alignment: .center)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick)))
        isUserInteractionEnabled = true
        
        setupAccessibility()
    }
    
    deinit {
        viewModel = nil
        observation = nil
    }
    
    public func configure(viewModel: IconedLoadingStateViewModel) {
        accessibilityIdentifier = viewModel.componentId
        accessibilityLabel = viewModel.name
        
        self.viewModel = viewModel
        imageView.image = viewModel.image
        imageView.contentMode = .scaleAspectFit
        label.text = viewModel.name
        observation = viewModel.observe(\.isLoading, onChange: { [weak self] isLoading in
            guard let self = self else { return }
            self.updateState(isLoading: isLoading)
        })
    }
    
    public func updateState(isLoading: Bool) {
        self.isUserInteractionEnabled = !isLoading
        self.superview?.isUserInteractionEnabled = !isLoading
        if isLoading {
            imageView.image = viewModel?.loadingImage ?? R.image.gradientCircleWithInsets.image
            imageView.startRotating()
        } else {
            imageView.image = viewModel?.image
            imageView.stopRotation()
        }
    }
    
    public func setupUI(alignment: UIStackView.Alignment, titleFont: UIFont) {
        mainStack?.alignment = alignment
        label.font = titleFont
    }
    
    // MARK: - Private Methods
    @objc private func onClick() {
        if viewModel?.isLoading == true { return }
        viewModel?.clickHandler?()
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
}

private extension IconedLoadingStateView {
    enum Constants {
        static let iconSize: CGSize = .init(width: 24, height: 24)
        static let spacing: CGFloat = 8
    }
}
