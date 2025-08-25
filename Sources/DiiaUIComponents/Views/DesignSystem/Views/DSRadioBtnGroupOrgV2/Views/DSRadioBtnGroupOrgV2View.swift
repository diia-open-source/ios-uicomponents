
import UIKit
import DiiaCommonTypes

final public class DSRadioBtnGroupOrgV2View: BaseCodeView {
    private let mainStack = UIStackView.create()
    private let radioItemsStack = UIStackView.create()
    private let plainIconButton = IconedLoadingStateView()
    private let centredButtonStack = UIStackView.create(.vertical, alignment: .center)
    private let titleLabel: BoxView<UILabel> = BoxView(subview: UILabel().withParameters(font: FontBook.bigText)).withConstraints(insets: Constants.titleInsets)
    private var itemViewModels: [DSRadioBtnMlcV2ViewModel] = []
    private var selectedItem: DSRadioBtnMlcV2ViewModel?
    private var model: DSRadioBtnGroupOrgV2Model?
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
        radioItemsStack.withMargins(Constants.itemsPadding)
        centredButtonStack.addArrangedSubview(plainIconButton)
        plainIconButton.withHeight(Constants.plainBtnHeight)
        mainStack.addArrangedSubviews([
            titleLabel,
            radioItemsStack,
            centredButtonStack
        ])
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
    }
    
    public func setEventHandler(_ eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }
    
    public func configure(with model: DSRadioBtnGroupOrgV2Model) {
        self.model = model
        accessibilityIdentifier = model.componentId
        titleLabel.isHidden = model.title == nil
        titleLabel.subview.text = model.title
        
        radioItemsStack.safelyRemoveArrangedSubviews()
        itemViewModels.removeAll()
        
        //TODO: - Use viewFabric for different items
        model.items.forEach {
            guard let buttonModel = $0.radioBtnMlcV2 else { return }
            
            let isSelected = buttonModel.isSelected ?? false
            let isAvailable = buttonModel.isEnabled ?? true
            
            let viewModel = DSRadioBtnMlcV2ViewModel(
                componentId: buttonModel.componentId,
                code: buttonModel.id ?? .empty,
                iconRight: buttonModel.iconRight,
                iconLeft: buttonModel.iconLeft,
                label: buttonModel.label,
                status: buttonModel.status,
                details: buttonModel.description,
                isAvailable: isAvailable,
                isSelected: .init(value: isSelected))
            viewModel.onClick = { [weak self, weak viewModel] in
                guard let viewModel = viewModel else { return }
                self?.handleSelection(of: viewModel)
            }
            
            let view = DSRadioBtnMlcV2View()
            view.configure(with: viewModel)
            radioItemsStack.addArrangedSubview(view)
            itemViewModels.append(viewModel)
            
            if isSelected {
                selectedItem = viewModel
            }
        }
        
        centredButtonStack.isHidden = model.btnPlainIconAtm == nil
        if let plainBtn = model.btnPlainIconAtm {
            let viewModel = IconedLoadingStateViewModel(name: plainBtn.label, image: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: plainBtn.icon) ?? UIImage())
            viewModel.clickHandler = { [weak self] in
                guard let action = plainBtn.action else { return }
                self?.eventHandler?(.buttonLoadIconAction(parameters: action, viewModel: viewModel))
            }
            plainIconButton.configure(viewModel: viewModel)
        }
    }
    
    private func handleSelection(of selected: DSRadioBtnMlcV2ViewModel) {
        itemViewModels.forEach {
            let shouldSelect = ($0 === selected)
            if $0.isSelected.value != shouldSelect {
                $0.isSelected.value = shouldSelect
            }
        }
        selectedItem = selected
        eventHandler?(.inputChanged(.init(inputCode: self.inputCode(),
                                          inputData: self.inputData())))
    }
}

//MARK: - DSInputComponentProtocol
extension DSRadioBtnGroupOrgV2View: DSInputComponentProtocol {
    public func isValid() -> Bool {
        guard model?.mandatory != nil else {
            return true
        }
        
        return selectedItem != nil
    }
    
    public func inputCode() -> String {
        return model?.inputCode ?? Constants.defaultInputCode
    }
    
    public func inputData() -> AnyCodable? {
        guard let selectedCode = selectedItem?.code else { return nil }
        return AnyCodable.string(selectedCode)
    }
}

private extension DSRadioBtnGroupOrgV2View {
    enum Constants {
        static let titleInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let itemsPadding: UIEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
        static let cornerRadius: CGFloat = 16
        static let plainBtnHeight: CGFloat = 56
        static let defaultInputCode = "radioBtnGroupOrgV2"
    }
}
