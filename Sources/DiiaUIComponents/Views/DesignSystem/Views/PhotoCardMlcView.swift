
import UIKit
import DiiaCommonTypes

public final class PhotoCardMlcViewModel {
    public let componentId: String
    public let iconRight: DSIconModel?
    public let photo: DSIconUrlAtmModel
    public var tableItemCheckboxViewModel: DSTableItemCheckboxItemViewModel?
    public var radioBtnViewModel: DSTableItemCheckboxItemViewModel?
    public let action: DSActionParameter?
    
    public let isEnable = Observable<Bool>(value: true)
    public let eventHandler: ((ConstructorItemEvent) -> Void)?

    public init(photoCardMlc: PhotoCardMlc,
                eventHandler: ((ConstructorItemEvent) -> Void)?) {
        self.componentId = photoCardMlc.componentId
        self.iconRight = photoCardMlc.iconRight
        self.photo = DSIconUrlAtmModel(
            componentId: nil,
            url: photoCardMlc.photo,
            accessibilityDescription: photoCardMlc.accessibilityDescription,
            action: nil)
        if let tableItemCheckboxMlc = photoCardMlc.tableItemCheckboxMlc {
            self.tableItemCheckboxViewModel = DSTableItemCheckboxItemViewModel(model: tableItemCheckboxMlc)
        }
        if let radioBtnMlcV2 = photoCardMlc.radioBtnMlcV2 {
            self.radioBtnViewModel = DSTableItemCheckboxItemViewModel(model: radioBtnMlcV2)
        }
        self.eventHandler = eventHandler
        self.action = photoCardMlc.action
    }
}

/// design_system_code: photoCardMlc
public final class PhotoCardMlcView: BaseCodeView {
    
    // MARK: - Subviews
    private let topIcon = UIImageView().withSize(Constants.topIconSize)
    private let photoImage = DSIconUrlAtmView()
    private let tableItemCheckbox = DSTableItemCheckboxView()
    
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
        
        let checkBoxView = BoxView(subview: tableItemCheckbox)
            .withConstraints(insets: .allSides(Constants.padding))
        let stack = UIStackView.create(views: [photoImage, checkBoxView])
        addSubview(stack)
        stack.fillSuperview()
        
        topIcon.anchor(
            top: topAnchor,
            trailing: trailingAnchor,
            padding: .allSides(Constants.padding))
    }
    
    public func configure(viewModel: PhotoCardMlcViewModel) {
        topIcon.image = UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: viewModel.iconRight?.code)
        photoImage.configure(with: viewModel.photo)
        
        if let tableItemCheckboxViewModel = viewModel.tableItemCheckboxViewModel {
            tableItemCheckbox.configure(with: tableItemCheckboxViewModel)
            tableItemCheckbox.setupUI(titleFont: FontBook.bigText)
            
            tableItemCheckboxViewModel.isSelected.observe(observer: self) { [weak self] selected in
                self?.viewModel?.eventHandler?(.inputChanged(.init(inputCode: self?.viewModel?.componentId ?? "photoCardMlc",
                                                                   inputData: .bool(selected))))
            }
        }
        
        self.viewModel = viewModel
        
        self.viewModel?.isEnable.observe(observer: self) { [weak self] isEnabled in
            self?.viewModel?.tableItemCheckboxViewModel?.isEnabled.value = isEnabled
        }
        
        photoImage.tapGestureRecognizer {[weak self] in
            guard let viewModel = self?.viewModel else { return }
            if let actionParameters = viewModel.action {
                viewModel.eventHandler?(.action(actionParameters))
            }
        }
    }
}

extension PhotoCardMlcView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        return tableItemCheckbox.isValid()
    }
    public func inputData() -> AnyCodable? {
        return tableItemCheckbox.inputData()
    }
    public func inputCode() -> String {
        return tableItemCheckbox.inputCode()
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
