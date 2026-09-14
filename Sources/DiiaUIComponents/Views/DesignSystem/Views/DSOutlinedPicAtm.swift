
import UIKit
import DiiaCommonTypes

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
    private let imageView = UIImageView()
    private let errorPlaceholderView = UIImageView()
    private var aspectRatioConstraint: NSLayoutConstraint?
    private var errorPlaceholderWidthConstraint: NSLayoutConstraint!
    private var errorPlaceholderHeightConstraint: NSLayoutConstraint!

    public override func setupSubviews() {
        backgroundColor = .clear

        addSubview(imageView)
        imageView.fillSuperview()

        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        imageView.layer.borderWidth = Constants.borderWidth
        imageView.layer.borderColor = Constants.borderColor.cgColor
        imageView.backgroundColor = Constants.backgroundColor

        addSubview(errorPlaceholderView)
        errorPlaceholderView.contentMode = .scaleAspectFit
        errorPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        errorPlaceholderView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        errorPlaceholderView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        errorPlaceholderWidthConstraint = errorPlaceholderView.widthAnchor.constraint(equalToConstant: Constants.errorPlaceholderSize.width)
        errorPlaceholderHeightConstraint = errorPlaceholderView.heightAnchor.constraint(equalToConstant: Constants.errorPlaceholderSize.height)
        errorPlaceholderWidthConstraint.isActive = true
        errorPlaceholderHeightConstraint.isActive = true
        errorPlaceholderView.image = R.image.largePlaceholder.image
        errorPlaceholderView.isHidden = true
    }

    public func configure(with model: DSOutlinedPicAtmModel) {
        accessibilityIdentifier = model.componentId

        errorPlaceholderView.isHidden = true
        imageView.isHidden = model.image == nil

        if let image = model.image {
            let finishCallback: Callback = { [weak self] in
                self?.imageView.isHidden = false
                self?.errorPlaceholderView.isHidden = true
            }
            let errorCallback: Callback = { [weak self] in
                self?.imageView.isHidden = true
                self?.errorPlaceholderView.isHidden = false
            }
            imageView.loadImage(imageURL: image, placeholder: nil, completion: finishCallback, onError: errorCallback)
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
        static let backgroundColor = UIColor("#F0F3F7")
        static let defaultAspectRatio: Double = 16.0 / 9.0
        static let errorPlaceholderSize: CGSize = .init(width: 112, height: 112)
    }
}
