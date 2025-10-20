
import UIKit
import DiiaCommonTypes

public class DSButtonToggleGroupViewModel {
    public let componentId: String?
    public var items: [DSToggleButtonViewModel] = []
    public let toggleAction: (String) -> Void
    
    private var selectedCode: String?
    
    public init(model: DSToggleButtonGroupModel, toggleAction: @escaping (String) -> Void) {
        self.componentId = model.componentId
        self.toggleAction = toggleAction
        
        items = model.items.map { item in
            let buttonVM = DSToggleButtonViewModel(model: item.btnToggleMlc)
            buttonVM.onClick = { [weak self] in
                guard let self else { return }
                self.updateSelectedCode(item.btnToggleMlc.code)
            }
            return buttonVM
        }
        updateSelectedCode(model.preselected)
    }
    
    private func updateSelectedCode(_ code: String) {
        items.forEach { $0.isSelected = ($0.code == code) }
        guard code != self.selectedCode else { return }
        self.selectedCode = code
        toggleAction(code)
    }
}

/// design_system_code: toggleButtonGroupOrg
public class DSButtonToggleGroupView: BaseCodeView {
    private lazy var itemsStackView = UIStackView.create(
        .horizontal,
        spacing: Constants.spacing,
        alignment: .center,
        distribution: .fillEqually,
        in: self,
        padding: Constants.padding)
    
    // MARK: - Properties
    private var viewModel: DSButtonToggleGroupViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        backgroundColor = .clear
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSButtonToggleGroupViewModel) {
        self.viewModel = viewModel
        itemsStackView.safelyRemoveArrangedSubviews()
        viewModel.items.forEach {
            let button = DSButtonToggleView()
            button.configure(with: $0)
            itemsStackView.addArrangedSubview(button)
        }
    }
}

// MARK: - Constants
extension DSButtonToggleGroupView {
    private enum Constants {
        static let spacing: CGFloat = 8
        static let padding = UIEdgeInsets(top: 32, left: 40, bottom: 40, right: 40)
    }
}


