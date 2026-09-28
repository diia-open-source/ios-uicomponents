
import UIKit
import DiiaCommonTypes

///ds_code: photoUploadMlc
public struct DSPhotoUploadMlcModel: Codable {
    public let componentId: String
    public let inputCode: String?
    public let iconCenter: DSIconModel?
    public let mandatory: Bool?
    public let title: String?
    public let description: String?
    public let iconRight: DSIconModel?
    public let action: DSActionParameter?
}

final class DSPhotoUploadMlcView: BaseCodeView {
    private let mainStack = UIStackView.create(spacing: Constants.mainStackSpacing, alignment: .center)
    private let textLabelsStack = UIStackView.create(spacing: Constants.textLabelsStackSpacing, alignment: .center)
    private let addPhotoIcon = DSIconView()
    private let deleteIcon = DSIconView()
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont.withSize(Constants.titleLabelFontSize), textColor: .black)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont.withSize(Constants.descriptionLabelFontSize), textColor: .black.withAlphaComponent(0.3), textAlignment: .center)
    private let loadingView = UIImageView(image: R.image.blackGradientSpinner.image)
    private let photoImageView = UIImageView()
    private var dashLayer: CAShapeLayer?
    private var viewModel: DSPhotoUploadMlcViewModel?
        
    override func setupSubviews() {
        addSubview(loadingView)
        loadingView.withSize(Constants.loadingSpinnerSize)
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubviews([photoImageView, deleteIcon])
        photoImageView.fillSuperview()
        deleteIcon.anchor(
            top: topAnchor,
            leading: nil,
            bottom: nil,
            trailing: trailingAnchor,
            padding: Constants.deleteIconInsets,
            size: Constants.iconSize)
        deleteIcon.tapArea = .expanded(size: Constants.deleteIconTapArea)
        addSubview(mainStack)
        mainStack.anchor(leading: leadingAnchor, trailing: trailingAnchor)
        mainStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textLabelsStack.addArrangedSubviews([
            titleLabel,
            descriptionLabel
        ])
        mainStack.addArrangedSubviews([
            addPhotoIcon,
            textLabelsStack
        ])
        
        addPhotoIcon.withSize(Constants.iconSize)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = Constants.cornerRadius
        photoImageView.layer.masksToBounds = true
        
        photoImageView.tapGestureRecognizer { [weak self] in
            self?.viewModel?.onTap?()
        }
       
        self.withHeight(Constants.cardHeight)
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateDashBorder()
    }

    public func configure(with viewModel: DSPhotoUploadMlcViewModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.viewModel?.state.removeObserver(observer: self)
        self.viewModel?.image.removeObserver(observer: self)
        self.viewModel = viewModel
        
        accessibilityIdentifier = viewModel.componentId
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.descriptionText
        
        if let iconCenter = viewModel.iconCenter {
            self.addPhotoIcon.setIcon(iconCenter)
            addPhotoIcon.onClick = { action in
                guard let action else { return }
                eventHandler(.action(action))
            }
        }
       
        if let deleteIcon = viewModel.iconRight {
            self.deleteIcon.setIcon(deleteIcon)
            self.deleteIcon.onClick = { action in
                guard let action else { return }
                eventHandler(.action(action))
            }
        }
    
        viewModel.state.observe(observer: self) { [weak self] state in
            self?.applyState(state)
        }
        
        viewModel.image.observe(observer: self) { [weak self] image in
            self?.photoImageView.image = image
        }
        
        if let action = viewModel.action {
            self.tapGestureRecognizer {
                eventHandler(.action(action))
            }
        }
    }
    
    private func applyState(_ state: DSPhotoUploadState) {
        switch state {
        case .normal:
            mainStack.isHidden = false
            photoImageView.isHidden = true
            deleteIcon.isHidden = true
            loadingView.isHidden = true
            loadingView.stopRotation()
            applyStyle(.initial)
        case .loading:
            mainStack.isHidden = true
            photoImageView.isHidden = true
            deleteIcon.isHidden = true
            loadingView.isHidden = false
            loadingView.startRotating()
            applyStyle(.initial)
        case .preview:
            mainStack.isHidden = true
            photoImageView.isHidden = false
            deleteIcon.isHidden = false
            loadingView.isHidden = true
            loadingView.stopRotation()
            applyStyle(.clear)
        case .error(let message):
            mainStack.isHidden = false
            photoImageView.isHidden = true
            deleteIcon.isHidden = true
            descriptionLabel.text = message
            loadingView.isHidden = true
            loadingView.stopRotation()
            applyStyle(.error)
        }
    }
    
    private func updateDashBorder() {
        guard bounds != .zero else { return }
        
        if dashLayer == nil {
            let shape = CAShapeLayer()
            shape.strokeColor = Constants.borderColor.cgColor
            shape.fillColor = UIColor.clear.cgColor
            shape.lineWidth = Constants.borderWidth
            shape.lineDashPattern = Constants.dashPattern
            layer.addSublayer(shape)
            dashLayer = shape
        }
        
        dashLayer?.path = UIBezierPath(roundedRect: bounds, cornerRadius: Constants.cornerRadius).cgPath
    }
    
    private func applyStyle(_ style: BorderStyle) {
        dashLayer?.strokeColor = style.borderColor.cgColor
        backgroundColor = style.backgroundColor
    }
}

extension DSPhotoUploadMlcView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        guard viewModel?.mandatory == true else { return true }
        return viewModel?.uploadedId != nil
    }
    
    public func inputCode() -> String {
        viewModel?.inputCode ?? ""
    }
    
    public func inputData() -> AnyCodable? {
        guard let uploadedId = viewModel?.uploadedId else { return nil }
        return .string(uploadedId)
    }
}

private extension DSPhotoUploadMlcView {
    enum Constants {
        static let mainStackSpacing: CGFloat = 8
        static let textLabelsStackSpacing: CGFloat = 4
        static let titleLabelFontSize: CGFloat = 16
        static let descriptionLabelFontSize: CGFloat = 12
        static let mainStackInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let deleteIconInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
        static let iconSize = CGSize(width: 24, height: 24)
        static let loadingSpinnerSize = CGSize(width: 18, height: 18)
        static let backgroundColor = UIColor("#F0F3F7")
        static let errorBackgroundColor = UIColor("#FEF5F6")
        static let cornerRadius: CGFloat = 16
        static let borderColor: UIColor = .black.withAlphaComponent(0.3)
        static let errorBorderColor = UIColor("#EC0312")
        static let borderWidth: CGFloat = 1
        static let dashPattern: [NSNumber] = [4, 4]
        static let cardHeight: CGFloat = 146
        static let deleteIconTapArea = CGSize(width: 44, height: 44)
    }
    
    enum BorderStyle {
        case initial
        case error
        case clear
        
        var borderColor: UIColor {
            switch self {
            case .initial:
                return Constants.borderColor
            case .error:
                return Constants.errorBorderColor
            case .clear:
                return .clear
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .initial:
                return Constants.backgroundColor
            case .error:
                return Constants.errorBackgroundColor
            case .clear:
                return .clear
            }
        }
    }
}
