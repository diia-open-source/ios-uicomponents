
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
        imageView.isHidden = true
    }
    
    public func configure(with model: DSIconUrlAtmModel) {
        self.action = model.action
        let finishCallback: Callback = { [weak self] in
            self?.imageView.isHidden = false
            self?.loadingView.isHidden = true
        }
        imageView.loadImage(imageURL: model.url, placeholder: R.image.defaultLoadingIcon.image, completion: finishCallback, onError: finishCallback)
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
        addSubview(imageView)
        
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFit
        handleSelection()
    }
    
    private func handleSelection() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
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
