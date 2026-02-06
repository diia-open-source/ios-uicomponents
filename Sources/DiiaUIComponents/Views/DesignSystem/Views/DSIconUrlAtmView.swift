
import UIKit
import Lottie
import DiiaCommonTypes

public struct DSIconUrlAtmModel: Codable {
    public let componentId: String?
    public let url: String
    public let accessibilityDescription: String?
    public let action: DSActionParameter?
    
    public init(componentId: String?, url: String, accessibilityDescription: String?, action: DSActionParameter?) {
        self.componentId = componentId
        self.url = url
        self.accessibilityDescription = accessibilityDescription
        self.action = action
    }
    
    static let mock = DSIconUrlAtmModel(
        componentId: "componentId(optional)",
        url: "url",
        accessibilityDescription: "accessibilityDescription(optional)",
        action: .mock
    )
}

/// design_system_code: iconUrlAtm, smallIconUrlAtm
public final class DSIconUrlAtmView: BaseCodeView {
    private let imageView = UIImageView()
    private var eventHandler: ((ConstructorItemEvent) -> Void) = { _ in }
    private var action: DSActionParameter?
    private lazy var loadingView: AnimationView = {
        let loadingContainer = LoadingContainerView()
        loadingContainer.configure(size: Constants.placeholderSize, loadingImage: R.image.blackGradientSpinner.image)
        return AnimationView(loadingContainer)
    }()
   
    public override func setupSubviews() {
        initialSetup()
        setupAccessibility()
        imageView.isHidden = true
    }
    
    public func configure(with model: DSIconUrlAtmModel) {
        self.action = model.action
        let finishCallback: Callback = { [weak self] in
            self?.imageView.isHidden = false
            self?.loadingView.isHidden = true
        }
        imageView.accessibilityLabel = model.accessibilityDescription
        imageView.loadImage(imageURL: model.url, placeholder: R.image.defaultImagePlaceholder.image, completion: finishCallback, onError: finishCallback)
    }
    
    public func configure(with image: UIImage?) {
        imageView.isHidden = false
        loadingView.isHidden = true
        imageView.image = image
    }
    
    public func set(eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }
    
    private func initialSetup() {
        backgroundColor = .clear
        addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loadingView.withSize(Constants.placeholderSize)
        addSubview(imageView)
        
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        handleSelection()
    }
    
    private func handleSelection() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    private func setupAccessibility() {
        imageView.isAccessibilityElement = true
        imageView.accessibilityTraits = .image
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        guard let action = self.action else { return }
        eventHandler(.action(action))
    }
}

private extension DSIconUrlAtmView {
    enum Constants {
        static let placeholderSize: CGSize = .init(width: 18, height: 18)
    }
}
