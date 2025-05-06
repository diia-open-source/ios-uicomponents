
import UIKit
import DiiaCommonTypes

public struct DSSearchBarModel: Codable {
    public let componentId: String?
    public let searchInputMlc: DSSearchModel
    public let btnWhiteAdditionalIconAtm: DSButtonWhiteAdditionalIconAtm
}

//ds code: - searchBarOrg
public class DSSearchBarView: BaseCodeView {
    private let searchView = DSSearchInputView()
    private let filterButton = DSWhiteAdditionalIconButton()
    private let mainStack = UIStackView.create(.horizontal, spacing: Constants.spacing)
    private var eventHandler: ((ConstructorItemEvent) -> Void) = { _ in }
    private var filterButtonViewModel: DSWhiteAdditionalIconButtonViewModel?
    
    public override func setupSubviews() {
        initialSetup()
    }
    
    private func initialSetup() {
        addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.insets)
        mainStack.addArrangedSubviews([searchView, filterButton])
    }
    
    public func configure(with model: DSSearchBarModel) {
        searchView.setup(placeholder: model.searchInputMlc.label,
        textChangeCallback: { [weak self] in
            self?.eventHandler(.inputChanged(.init(
                inputCode: DSSearchInputViewBuilder.modelKey,
                inputData: .string(self?.searchView.searchText ?? .empty))))
        })
        filterButtonViewModel = .init(
            name: model.btnWhiteAdditionalIconAtm.label,
            image: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: model.btnWhiteAdditionalIconAtm.icon) ?? UIImage(),
            badgeCount: .init(value: model.btnWhiteAdditionalIconAtm.badgeCounterAtm?.count ?? 0),
            accessibilityDescription: model.btnWhiteAdditionalIconAtm.accessibilityDescription)
        filterButtonViewModel?.clickHandler = { [weak self] in
            guard let action = model.btnWhiteAdditionalIconAtm.action,
            let viewModel = self?.filterButtonViewModel else { return }
            self?.eventHandler(.filterButtonAction(action: action, viewModel: viewModel))
        }
        filterButton.configure(with: filterButtonViewModel!)
    }
    
    func set(eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }
}
extension DSSearchBarView {
    private enum Constants {
        static let spacing: CGFloat = 24
        static let insets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 8, right: 0)
    }
}
