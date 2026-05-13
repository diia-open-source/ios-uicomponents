
import UIKit

/// ds_code: btnIconPlainStrokeMlc
public final class DSBtnIconPlainStrokeMlcView: BaseCodeView {
    private let iconView = DSIconView()
    private let titleLabel = UILabel().withParameters(font: Constants.titleLabelFont)
    private lazy var loadingView: AnimationView<LoadingContainerView> = {
        let loadingContainer = LoadingContainerView()
        loadingContainer.configure(loadingImage: R.image.blackGradientSpinner.image)
        let view = AnimationView(loadingContainer)
        view.withSize(Constants.iconSize)
        return view
    }()
    
    private lazy var mainHStack = UIStackView.create(
        .horizontal,
        views: [iconView, titleLabel, loadingView],
        spacing: Constants.spacing
    )

    //MARK: Lifecycle
    public override func setupSubviews() {
        addSubview(mainHStack)
        withBorder(width: 1, color: Constants.borderColor, cornerRadius: Constants.cornerRadius)

        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        mainHStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainHStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        iconView.withSize(Constants.iconSize)
        self.withHeight(Constants.height)
    }

    //MARK: Public methods
    public func configure(with model: DSBtnIconPlainStrokeMlcModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        accessibilityIdentifier = model.componentId
        titleLabel.text = model.label
        iconView.setIcon(model.iconLeft)

        if let action = model.action {
            self.tapGestureRecognizer { [weak self] in
                guard let self else { return }
                eventHandler(.statefulAction(parameters: action, stateHandler: self))
            }
        }
        
        setState(model.state ?? .enabled)
    }
}

extension DSBtnIconPlainStrokeMlcView: StatefullViewProtocol {
    public func setState(_ state: DSButtonState) {
        loadingView.isHidden = state != .loading
        titleLabel.isHidden = state == .loading
        iconView.isHidden = state == .loading
        switch state {
        case .disabled:
            isUserInteractionEnabled = false
            alpha = Constants.disabledAlpha
        case .loading:
            isUserInteractionEnabled = false
            alpha = Constants.defaultAlpha
        default:
            isUserInteractionEnabled = true
            alpha = Constants.defaultAlpha
        }
    }
}

private extension DSBtnIconPlainStrokeMlcView {
    enum Constants {
        static let spacing: CGFloat = 8
        static let iconSize = CGSize(width: 20, height: 20)
        static let titleLabelFont = FontBook.usualFont.withSize(12)
        static let height: CGFloat = 56
        static let cornerRadius: CGFloat = 16
        static let defaultAlpha: CGFloat = 1
        static let disabledAlpha: CGFloat = 0.54
        static let borderColor = UIColor("#C5D9E9")
    }
}
