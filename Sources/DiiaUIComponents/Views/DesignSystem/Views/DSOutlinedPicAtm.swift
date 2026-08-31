
import UIKit

public struct DSOutlinedPicAtmModel: Codable {
    public let componentId: String
    public let aspectRatio: Double?
    public let image: String?

    public init(
        componentId: String,
        aspectRatio: Double? = nil,
        image: String? = nil
    ) {
        self.componentId = componentId
        self.aspectRatio = aspectRatio
        self.image = image
    }
}

/// design_system_code: outlinedPicAtm
public final class DSOutlinedPicAtmView: BaseCodeView {
    private let imageView = DSIconUrlAtmView()
    private var aspectRatioConstraint: NSLayoutConstraint?

    public override func setupSubviews() {
        backgroundColor = .clear

        addSubview(imageView)
        imageView.fillSuperview()

        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.layer.borderWidth = Constants.borderWidth
        imageView.layer.borderColor = Constants.borderColor.cgColor
    }

    public func configure(with model: DSOutlinedPicAtmModel) {
        accessibilityIdentifier = model.componentId

        imageView.isHidden = model.image == nil
        if let image = model.image {
            imageView.configure(with: DSIconUrlAtmModel(
                componentId: nil,
                url: image,
                accessibilityDescription: nil,
                action: nil))
        }

        let aspectRatio = model.aspectRatio ?? Constants.defaultAspectRatio

        aspectRatioConstraint?.isActive = false
        aspectRatioConstraint = heightAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: 1 / CGFloat(aspectRatio))
        aspectRatioConstraint?.isActive = true
    }
}

private extension DSOutlinedPicAtmView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let borderWidth: CGFloat = 2
        static let borderColor: UIColor = .white
        static let defaultAspectRatio: Double = 16.0 / 9.0
    }
}
