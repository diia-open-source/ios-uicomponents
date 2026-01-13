
import Foundation
import DiiaCommonTypes
import UIKit

public struct DSPhotoGroupOrg: Codable {
    public let componentId: String?
    public let pictures: [DSImageData]
    
    public init(componentId: String?, pictures: [DSImageData]) {
        self.componentId = componentId
        self.pictures = pictures
    }
}

//ds_code: photoGroupOrg
public final class DSPhotoGroupOrgView: BaseCodeView {
    private let mainStack = UIStackView.create()
    private let picturesHStack = UIStackView.create(.horizontal, spacing: Constants.spacing, alignment: .center, distribution: .fill)
    
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
        mainStack.addArrangedSubview(picturesHStack)
        picturesHStack.fillSuperview()
    }
    
    public func configure(with model: DSPhotoGroupOrg) {
        guard model.pictures.count >= 2 else { return }
        accessibilityIdentifier = model.componentId
        picturesHStack.safelyRemoveArrangedSubviews()
        model.pictures.enumerated().forEach { (index, imageData) in
            let view = DSImageContainerView()
            view.configure(data: imageData)
            view.layer.cornerRadius = Constants.cornerRadius
            view.clipsToBounds = true
            view.backgroundColor = .onboardingBottomColor
            picturesHStack.addArrangedSubview(view)
        }
    }
}


private extension DSPhotoGroupOrgView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let spacing: CGFloat = 24
    }
}
