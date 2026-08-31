
import UIKit
import DiiaCommonTypes

public final class PhotoCardMlcViewModel {
    public let componentId: String
    public let id: String
    public let iconRight: DSIconModel?
    public let photo: DSIconUrlAtmModel
    public var checkboxViewModel: DSCheckboxMlcViewModel?
    public var radioBtnViewModel: DSRadioBtnElementMlcViewModel?
    public let action: DSActionParameter?

    public let isSelected = Observable<Bool>(value: false)
    public let isEnable = Observable<Bool>(value: true)
    public let eventHandler: ((ConstructorItemEvent) -> Void)?

    public init(photoCardMlc: PhotoCardMlc,
                eventHandler: ((ConstructorItemEvent) -> Void)?) {
        self.componentId = photoCardMlc.componentId
        self.id = photoCardMlc.id ?? photoCardMlc.componentId
        self.iconRight = photoCardMlc.iconRight
        self.photo = DSIconUrlAtmModel(
            componentId: nil,
            url: photoCardMlc.photo,
            accessibilityDescription: photoCardMlc.accessibilityDescription,
            action: nil)

        if let checkboxMlc = photoCardMlc.checkBoxMlc {
            self.checkboxViewModel = DSCheckboxMlcViewModel(model: checkboxMlc)
        }

        if let radioBtnModel = photoCardMlc.radioBtnElementMlc {
            self.radioBtnViewModel = DSRadioBtnElementMlcViewModel(
                model: radioBtnModel,
                isSelected: Observable(value: radioBtnModel.isSelected ?? false),
                isEnabled: Observable(value: radioBtnModel.isEnabled ?? true))
        }

        self.eventHandler = eventHandler
        self.action = photoCardMlc.action

        selectionState()
    }

    public func deselect() {
        radioBtnViewModel?.isSelected.value = false
    }

    private func selectionState() {
        if let checkboxViewModel {
            isSelected.value = checkboxViewModel.isSelected.value
            checkboxViewModel.isSelected.observe(observer: self) { [weak self] selected in
                self?.isSelected.value = selected
            }
        }

        if let radioBtnViewModel {
            isSelected.value = radioBtnViewModel.isSelected.value
            radioBtnViewModel.isSelected.observe(observer: self) { [weak self] selected in
                self?.isSelected.value = selected
            }
        }
    }
}

/// design_system_code: photoCardMlc
public final class PhotoCardMlcView: BaseCodeView {
    
    // MARK: - Subviews
    private let topIcon = UIImageView().withSize(Constants.topIconSize)
    private let photoImage = DSIconUrlAtmView()
    private let checkbox = DSCheckboxMlcView()
    private let radioBtn = DSRadioBtnElementMlcView()
    
    private(set) var viewModel: PhotoCardMlcViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
                
        photoImage.addSubview(topIcon)
        photoImage.clipsToBounds = true
        photoImage.layer.cornerRadius = Constants.cornerRadius
        photoImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        photoImage.withHeight(Constants.viewHeight * Constants.topProportion)
        
        let selectionStack = UIStackView.create(views: [checkbox, radioBtn])
        let selectionBox = BoxView(subview: selectionStack)
            .withConstraints(insets: .allSides(Constants.padding))
        let stack = UIStackView.create(views: [photoImage, selectionBox])
        addSubview(stack)
        stack.fillSuperview()
        
        topIcon.anchor(
            top: topAnchor,
            trailing: trailingAnchor,
            padding: .allSides(Constants.padding))
    }
    
    public func configure(viewModel: PhotoCardMlcViewModel) {
        self.viewModel = viewModel

        topIcon.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: viewModel.iconRight?.code)
        photoImage.configure(with: viewModel.photo)

        checkbox.isHidden = viewModel.checkboxViewModel == nil
        radioBtn.isHidden = viewModel.radioBtnViewModel == nil

        if let checkboxViewModel = viewModel.checkboxViewModel {
            checkbox.configure(with: checkboxViewModel)
        }

        if let radioBtnViewModel = viewModel.radioBtnViewModel {
            radioBtn.configure(with: radioBtnViewModel)
        }

        viewModel.isEnable.removeObserver(observer: self)
        viewModel.isEnable.observe(observer: self) { [weak self] isEnabled in
            self?.viewModel?.checkboxViewModel?.isEnabled.value = isEnabled
            self?.viewModel?.radioBtnViewModel?.isEnabled.value = isEnabled
        }

        photoImage.tapGestureRecognizer { [weak self] in
            guard let viewModel = self?.viewModel else { return }
            if let actionParameters = viewModel.action {
                viewModel.eventHandler?(.action(actionParameters))
            }
        }
    }
}

extension PhotoCardMlcView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        if viewModel?.checkboxViewModel != nil {
            return checkbox.isValid()
        }
        return true
    }

    public func inputData() -> AnyCodable? {
        if viewModel?.checkboxViewModel != nil {
            return checkbox.inputData()
        }
        return .bool(viewModel?.radioBtnViewModel?.isSelected.value ?? false)
    }

    public func inputCode() -> String {
        return "photoCardMlc"
    }
}

private extension PhotoCardMlcView {
    enum Constants {
        static let topIconSize = CGSize(width: 32, height: 32)
        static let bottomProportion = CGFloat(0.35)
        static let topProportion = CGFloat(0.65)
        static let viewHeight = (UIScreen.main.bounds.width - 48) * 11/9
        static let cornerRadius: CGFloat = 16
        static let padding: CGFloat = 16
    }
}
