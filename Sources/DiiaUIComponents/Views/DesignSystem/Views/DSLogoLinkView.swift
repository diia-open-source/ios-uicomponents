
import UIKit
import Lottie
import DiiaCommonTypes

public struct DSLogoAtm: Codable {
    let componentId: String?
    let logo: String
    let accessibilityDescription: String?
    let action: DSActionParameter?
}

/// design_system_code: logoAtm
class DSLogoLinkView: BaseCodeView {
    private let imageView = UIImageView()
    private lazy var loadingView: AnimationView = {
        let loadingContainer = LoadingContainerView()
        loadingContainer.configure(size: Constants.placeholderSize, loadingImage: R.image.blackGradientSpinner.image)
        return AnimationView(loadingContainer)
    }()
    
    public override func setupSubviews() {
        initialSetup()
        imageView.isHidden = true
    }
    
    public func configure(with link: String) {
        let finishCallback: Callback = { [weak self] in
            self?.imageView.isHidden = false
            self?.loadingView.isHidden = true
        }
        imageView.loadImage(imageURL: link, placeholder: R.image.defaultIconLarge.image, completion: finishCallback, onError: finishCallback)
    }
    
    public func configure(data: DSLogoAtm) {
        accessibilityIdentifier = data.componentId
        accessibilityLabel = data.accessibilityDescription
        configure(with: data.logo)
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
    }
}

private extension DSLogoLinkView {
    enum Constants {
        static let placeholderSize: CGSize = .init(width: 18, height: 18)
    }
}
