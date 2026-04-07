
import UIKit

/// design_system_code: tableBlockTwoColumnsPlaneOrg

public final class DSTableBlockTwoColumnsPlaneOrgView: BaseCodeView {
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.verticalStackSpace
        return stackView
    }()
    
    private lazy var tableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.spacing
        return stackView
    }()
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.fillSuperview(padding: Constants.padding)
    }
    
    public func configure(models: DSTableBlockTwoColumnPlaneOrg,
                          imageProvider: DSImageNameProvider?,
                          eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        if let headingData = models.headingWithSubtitlesMlc {
            let headingView = DSHeadingWithSubtitleView()
            headingView.configure(model: headingData)
            mainStackView.addArrangedSubview(headingView)
        }
        if let attentionIconMessageMlc = models.attentionIconMessageMlc {
            let attentionView = DSAttentionIconMessageView()
            attentionView.configure(with: attentionIconMessageMlc)
            mainStackView.addArrangedSubview(attentionView)
        }
        if let imageProvider {
            setupPhotoView(image: imageProvider.imageForCode(imageCode: models.photo), photoURL: models.photoUrl)
        }
        let verticalStackView = UIStackView.create(.vertical, spacing: Constants.verticalStackSpace)
        if let itemsData = models.items {
            for item in itemsData {
                let view = DSTableItemVerticalView()
                if let valueImage = item.tableItemVerticalMlc.valueImage,
                   let imageProvider,
                   let image = imageProvider.imageForCode(imageCode: valueImage.rawValue)
                {
                    let imageAltText: String?
                    switch valueImage {
                    case .photo:
                        imageAltText = R.Strings.document_accessibility_doc_photo.localized()
                    case .signature:
                        imageAltText = R.Strings.document_accessibility_signature_photo.localized()
                    }
                    
                    view.configure(model: item.tableItemVerticalMlc, image: image, imageAltText: imageAltText, eventHandler: eventHandler)
                } else {
                    view.configure(model: item.tableItemVerticalMlc, image: nil, eventHandler: eventHandler)
                }
                verticalStackView.addArrangedSubview(view)
            }
            tableStackView.addArrangedSubview(verticalStackView)
        }
        mainStackView.addArrangedSubview(tableStackView)
    }
    
    private func setupUI() {}
    
    private func setupPhotoView(image: UIImage? = nil, photoURL: String? = nil) {
        let photoItemView = DSDocPhotoView()
        if let photoURL {
            photoItemView.configure(
                imageURL: photoURL,
                accessibilityDescription: R.Strings.accessibility_photo_url.localized(),
                placeholder: image
            )
        } else {
            photoItemView.configure(content: image)
        }
        photoItemView.withBorder(width: 1, color: Constants.borderColor)
        tableStackView.addArrangedSubview(photoItemView)
    }
}

extension DSTableBlockTwoColumnsPlaneOrgView {
    enum Constants {
        static let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let spacing: CGFloat = 20
        static let borderColor: UIColor = UIColor.black.withAlphaComponent(0.1)
        
        static var verticalStackSpace: CGFloat {
            switch UIScreen.main.bounds.width {
            case 320:
                return 6
            default:
                return 16
            }
        }
    }
}
