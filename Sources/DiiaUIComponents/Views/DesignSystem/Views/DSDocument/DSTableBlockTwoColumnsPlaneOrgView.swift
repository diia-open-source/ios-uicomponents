import UIKit

/// design_system_code: tableBlockTwoColumnsPlaneOrg

public class DSTableBlockTwoColumnsPlaneOrgView: BaseCodeView {
    
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
                          imagesContent: [DSDocumentContentData: UIImage],
                          eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        if let headingData = models.headingWithSubtitlesMlc {
            let headingView = DSHeadingWithSubtitleView()
            headingView.configure(model: headingData)
            mainStackView.addArrangedSubview(headingView)
        }
        if let photoItem = models.photo, imagesContent[photoItem] != nil {
            let photoItemView = DSDocPhotoView()
            photoItemView.configure(content: imagesContent[photoItem])
            photoItemView.withBorder(width: 1, color: Constants.borderColor)
            tableStackView.addArrangedSubview(photoItemView)
        }
        let verticalStackView = UIStackView.create(.vertical, views: [], spacing: Constants.verticalStackSpace)
        if let itemsData = models.items {
            for item in itemsData {
                let view = DSTableItemVerticalView()
                if let valueImage = item.tableItemVerticalMlc.valueImage, let image = imagesContent[valueImage] {
                    view.configure(model: item.tableItemVerticalMlc, image: image, eventHandler: eventHandler)
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
