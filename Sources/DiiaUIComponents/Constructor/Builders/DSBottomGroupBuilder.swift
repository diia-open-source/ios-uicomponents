
import UIKit
import DiiaCommonTypes

public struct DSBottomGroupBuilder: DSViewBuilderProtocol {
    public let modelKey = "bottomGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let bottomGroup: DSBottomGroupOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        let stack = setupButtons(with: bottomGroup, withPadding: paddingType, eventHandler: eventHandler)
        let paddingBox = BoxView(subview: stack).withConstraints(insets: Constants.defaultPaddings)
        return paddingBox
    }
    
    private func setupButtons(with model: DSBottomGroupOrg,
                              withPadding paddingType: DSViewPaddingType,
                              eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView {
        let buttonStack = UIStackView.create(.vertical, alignment: .center)
        buttonStack.accessibilityIdentifier = model.componentId

        if let btnLoadIconPlainGroupMlc = model.btnLoadIconPlainGroupMlc {
            let iconPlainButton = createIconPlainButton(with: btnLoadIconPlainGroupMlc,
                                                        eventHandler: eventHandler)
            buttonStack.addArrangedSubview(iconPlainButton)
        }
        
        if let primaryButton = model.btnPrimaryDefaultAtm {
            let primaryButton = createPrimaryDefaultButton(with: primaryButton,
                                                           eventHandler: eventHandler)
            buttonStack.addArrangedSubview(primaryButton)
        }
        
        if let primaryWideButtonAtm = model.btnPrimaryWideAtm {
            let primaryWideButton = createPrimaryWideButton(with: primaryWideButtonAtm,
                                                     eventHandler: eventHandler)
            buttonStack.addArrangedSubview(primaryWideButton)
        }
        
        if let btnStrokeDefaultAtm = model.btnStrokeDefaultAtm {
            let strokeDefaultButton = createStrokeDefaultButton(with: btnStrokeDefaultAtm,
                                                                eventHandler: eventHandler)
            buttonStack.addArrangedSubview(strokeDefaultButton)
        }
        
        if let btnPrimaryLargeAtm = model.btnPrimaryLargeAtm {
            let btnPrimaryLargeBtn = createPrimaryLargeButton(with: btnPrimaryLargeAtm,
                                                              eventHandler: eventHandler)
            buttonStack.addArrangedSubview(btnPrimaryLargeBtn)
        }
        
        if let checkBoxBtnOrg = model.checkboxBtnOrg {
            buttonStack.alignment = .fill
            let checkBoxBtn = createCheckboxBtn(with: checkBoxBtnOrg, eventHandler: eventHandler)
            buttonStack.addArrangedSubview(checkBoxBtn)
        }
        
        if let btnPlainAtm = model.btnPlainAtm {
            let plainButton = createPlainButton(with: btnPlainAtm,
                                                eventHandler: eventHandler)
            buttonStack.addArrangedSubview(plainButton)
        }
        
        return buttonStack
    }
    
    private func createCheckboxBtn(with model: DSCheckboxBtnOrg, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> DSCheckboxButtonView {
        return DSCheckboxButtonOrgBuilder().makeView(model: model, eventHandler: eventHandler)
    }
    
    private func createPrimaryDefaultButton(with model: DSButtonModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> DSPrimaryDefaultButton {
        let button = DSPrimaryDefaultButton()
        button.titleLabel?.font = FontBook.bigText
        button.accessibilityIdentifier = model.componentId
        configureEdgeInset(in: button, for: model.label)
        button.withHeight(Constants.buttonHeight)
        let vm = DSLoadingButtonViewModel(title: model.label, state: .enabled)
        vm.callback = { [weak vm] in
            guard let action = model.action, let vm = vm else { return }
            eventHandler(.buttonAction(parameters: action, viewModel: vm))
        }
        button.configure(viewModel: vm)
        return button
    }
    
    private func createPrimaryWideButton(with model: DSButtonModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> DSPrimaryDefaultButton {
        let button = DSPrimaryDefaultButton()
        button.titleLabel?.font = FontBook.bigText
        button.accessibilityIdentifier = model.componentId
        button.contentEdgeInsets = .init(top: .zero,
                                         left: Constants.buttonEdgeInsets.left,
                                         bottom: .zero,
                                         right: Constants.buttonEdgeInsets.right)
        button.withHeight(Constants.buttonHeight)
        let vm = DSLoadingButtonViewModel(title: model.label, state: .enabled)
        vm.callback = { [weak vm] in
            guard let action = model.action, let vm = vm else { return }
            eventHandler(.buttonAction(parameters: action, viewModel: vm))
        }
        button.configure(viewModel: vm)
        return button
    }
    
    private func createPlainButton(with model: DSButtonModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> DSLoadingButton {
        let button = DSLoadingButton()
        button.titleLabel?.font = FontBook.bigText
        button.titleEdgeInsets = UIEdgeInsets(top: Constants.plainTopPadding,
                                              left: .zero,
                                              bottom: Constants.spacing,
                                              right: .zero)
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        button.withHeight(Constants.plainButtonHeight)
        button.setStyle(style: .plain)
        let vm = DSLoadingButtonViewModel(title: model.label, state: .enabled)
        vm.callback = { [weak vm] in
            guard let vm = vm else { return }
            guard let action = model.action else { return }
            eventHandler(.buttonAction(parameters: action, viewModel: vm))
        }
        button.configure(viewModel: vm)
        return button
    }
    
    private func createStrokeDefaultButton(with model: DSButtonModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> ActionLoadingStateButton {
        let button = ActionLoadingStateButton()
        button.setStyle(style: .light)
        button.setLoadingState(.enabled, withTitle: model.label)
        button.titleLabel?.font = FontBook.bigText
        configureEdgeInset(in: button, for: model.label)
        button.withHeight(Constants.buttonHeight)
        button.onClick = {
            guard let action = model.action else { return }
            eventHandler(.action(action))
        }
        return button
    }
    
    private func createIconPlainButton(with model: DSBtnLoadPlainGroupMlc, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> BorderedActionsView {
        let view = BorderedActionsView()
        view.setupUI(stackSpacing: Constants.spacing)
        let iconVMs = model.items.map { item in
            let viewModel = IconedLoadingStateViewModel(
                name: item.btnLoadPlainIconAtm.label,
                image: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: item.btnLoadPlainIconAtm.icon) ?? UIImage())
            viewModel.clickHandler = { [weak viewModel] in
                guard let viewModel = viewModel else { return }
                if let action = item.btnLoadPlainIconAtm.action {
                    eventHandler(.buttonLoadIconAction(parameters: action, viewModel: viewModel))
                }
            }
            return viewModel
        }
        view.configureView(with: iconVMs)
        return view
    }
    
    private func createPrimaryLargeButton(with model: DSButtonModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> DSPrimaryDefaultButton {
        let button = DSPrimaryDefaultButton()
        button.accessibilityIdentifier = model.componentId
        button.titleLabel?.font = FontBook.smallHeadingFont
        configureEdgeInset(in: button, for: model.label, with: FontBook.smallHeadingFont)
        button.withHeight(Constants.buttonLargeHeight)
        let vm = DSLoadingButtonViewModel(title: model.label, state: .enabled)
        vm.callback = { [weak vm] in
            guard let action = model.action, let vm = vm else { return }
            eventHandler(.buttonAction(parameters: action, viewModel: vm))
        }
        button.configure(viewModel: vm)
        return button
    }
    
    private func configureEdgeInset(in button: UIButton, for text: String, with font: UIFont = FontBook.bigText) {
        let textWidth = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: font]).width
        var additionInset: CGFloat = .zero
        if textWidth < Constants.minTextWidth {
            additionInset = (Constants.minTextWidth - textWidth) / 2
        }
        button.contentEdgeInsets = .init(top: .zero,
                                         left: Constants.buttonEdgeInsets.left + additionInset ,
                                         bottom: .zero,
                                         right: Constants.buttonEdgeInsets.right + additionInset)
    }
    
    private enum Constants {
        static let defaultPaddings = UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 24)
        static let buttonEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        static let buttonHeight: CGFloat = 48
        static let minTextWidth: CGFloat = 80
        static let buttonLargeHeight: CGFloat = 56
        static let plainButtonHeight: CGFloat = 56
        static let buttonBorder: CGFloat = 2
        static let spacing: CGFloat = 16
        static let plainTopPadding: CGFloat = 24
        static let padding: CGFloat = 8
    }
}

extension DSBottomGroupBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let btnModel = DSButtonModel(
            label: "label",
            state: DSButtonState.enabled,
            action: DSActionParameter(
                type: "type",
                subtype: "subtype",
                resource: "resource",
                subresource: "subresource"),
            componentId: "componentId"
        )
        let model = DSBottomGroupOrg(
            componentId: "componentId",
            checkboxBtnOrg: DSCheckboxBtnOrg(
                items: [
                    DSCheckboxBtnItem(
                        checkboxSquareMlc: DSCheckboxSquareMlc(
                            id: "id",
                            label: "label",
                            isSelected: true,
                            isEnabled: true,
                            componentId: "componentId",
                            blocker: true,
                            options: [
                                DSCheckboxOption(id: "id", isSelected: true)
                            ]
                        )
                    )
                ],
                btnPrimaryDefaultAtm: btnModel,
                btnPrimaryWideAtm: btnModel,
                btnStrokeWideAtm: btnModel,
                btnPlainAtm: btnModel,
                componentId: "componentId"
            ),
            btnPrimaryDefaultAtm: btnModel,
            btnPrimaryWideAtm: btnModel,
            btnPlainAtm: btnModel,
            btnStrokeDefaultAtm: btnModel,
            btnLoadIconPlainGroupMlc: DSBtnLoadPlainGroupMlc(
                items: [DSBtnLoadPlainIconAtm(
                    btnLoadPlainIconAtm: DSBtnPlainIconModel(
                        id: "id",
                        state: .enabled,
                        label: "label",
                        icon: "icon",
                        action: DSActionParameter(
                            type: "type",
                            subtype: "subtype",
                            resource: "resource",
                            subresource: "subresource"),
                        componentId: "componentId"
                    )
                )],
                componentId: "componentId"
            ),
            btnPrimaryLargeAtm: btnModel
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
