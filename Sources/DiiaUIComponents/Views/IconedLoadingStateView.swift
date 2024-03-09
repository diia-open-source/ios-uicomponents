import UIKit
import DiiaCommonTypes

public class IconedLoadingStateViewModel: NSObject {
    public let name: String
    public let image: UIImage?
    public var clickHandler: Callback?
    @objc public dynamic var isLoading: Bool
    
    public init(name: String,
                image: UIImage?,
                clickHandler: Callback? = nil,
                isLoading: Bool = false) {
        self.name = name
        self.image = image
        self.clickHandler = clickHandler
        self.isLoading = isLoading
    }
    
}

public class IconedLoadingStateView: BaseCodeView {
    private var mainStack: UIStackView?
    private let imageView: UIImageView = UIImageView().withSize(Constants.iconSize)
    private let label: UILabel = UILabel().withParameters(font: FontBook.usualFont)
    
    private var observation: NSKeyValueObservation?
    private weak var viewModel: IconedLoadingStateViewModel?
    
    public override func setupSubviews() {
        mainStack = hstack(imageView, label, spacing: Constants.spacing, alignment: .center)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick)))
        isUserInteractionEnabled = true
    }
    
    deinit {
        viewModel = nil
        observation = nil
    }
    
    public func configure(viewModel: IconedLoadingStateViewModel) {
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
        if isLoading {
            imageView.image = R.image.gradientCircleWithInsets.image
            imageView.startRotating()
        } else {
            imageView.image = viewModel?.image
            imageView.stopRotation()
        }
    }
    
    public func setupUI(alignment: UIStackView.Alignment) {
        mainStack?.alignment = alignment
    }
    
    @objc private func onClick() {
        if viewModel?.isLoading == true { return }
        viewModel?.clickHandler?()
    }
}

private extension IconedLoadingStateView {
    enum Constants {
        static let iconSize: CGSize = .init(width: 24, height: 24)
        static let spacing: CGFloat = 8
    }
}
