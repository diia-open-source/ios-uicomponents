
import UIKit
import DiiaCommonTypes

public class DSCheckboxGroupOrgView: BaseCodeView {
    private lazy var stackView = UIStackView.create(in: self)

    private(set) var viewModel: DSCheckboxGroupOrgViewModel?

    public override func setupSubviews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.cornerRadius
    }

    // MARK: - Public Methods
    public func configure(with viewModel: DSCheckboxGroupOrgViewModel, eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        self.viewModel = viewModel
        stackView.safelyRemoveArrangedSubviews()

        if let titleText = viewModel.model.title {
            addTitleLabel(text: titleText)
        }

        for checkboxMlcViewModel in viewModel.items {
            appendItemView(with: checkboxMlcViewModel)
        }

        eventHandler?(.onComponentConfigured(with: .resetStateComponent(component: self)))
    }

    // MARK: - Private Methods
    private func addTitleLabel(text: String) {
        let titleLabelBox = BoxView(subview: UILabel().withParameters(font: FontBook.bigText))
        titleLabelBox.subview.text = text
        titleLabelBox.withConstraints(insets: Constants.titleInsets)
        stackView.addArrangedSubview(titleLabelBox)
    }

    private func appendItemView(with checkboxMlcViewModel: DSCheckboxMlcViewModel) {
        accessibilityIdentifier = checkboxMlcViewModel.model.componentId

        guard let viewModel else { return }

        checkboxMlcViewModel.onClick = { [weak viewModel, weak checkboxMlcViewModel] in
            guard let checkboxMlcViewModel else { return }
            checkboxMlcViewModel.isSelected.value.toggle()
            viewModel?.updateSelectionState(forItem: checkboxMlcViewModel)
        }

        let itemView = DSCheckboxMlcView()
        itemView.configure(with: checkboxMlcViewModel)

        stackView.addArrangedSubview(itemView)
    }
}

//MARK: - DSInputComponentProtocol
extension DSCheckboxGroupOrgView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        if viewModel?.model.mandatory == false {
            return true
        } else {
            return !(viewModel?.selectedItems().isEmpty ?? true)
        }
    }

    public func inputCode() -> String {
        return viewModel?.model.inputCode ?? "checkboxGroupOrg"
    }

    public func inputData() -> AnyCodable? {
        guard let viewModel else { return nil }
        let idsList: [AnyCodable] = viewModel.selectedItems().map { .string($0.model.id) }
        return .array(idsList)
    }

    public func setOnChangeHandler(_ handler: @escaping () -> Void) {
        viewModel?.onClick = handler
    }
}

// MARK: - DSResetStateComponentProtocol
extension DSCheckboxGroupOrgView: DSResetStateComponentProtocol {
    public func clearState() {
        viewModel?.deselectAll()
    }
}

// MARK: - Constants
extension DSCheckboxGroupOrgView {
    private enum Constants {
        static let cornerRadius: CGFloat = 16.0
        static let titleInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
