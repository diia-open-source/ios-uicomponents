
import UIKit
import DiiaCommonTypes

public class DSRadioBtnWithAltViewModel {
    public let eventHandler: ((ConstructorItemEvent) -> Void)
    public let items: [DSRadioBtnGroupItem]
    public var itemViewModels = [ChecklistViewModel]()
    
    public init(eventHandler: @escaping (ConstructorItemEvent) -> Void, items: [DSRadioBtnGroupItem]) {
        self.eventHandler = eventHandler
        self.items = items
    }
}

public class DSRadioBtnWithAltView: BaseCodeView, DSInputComponentProtocol {
    
    private var radioBtnStack = UIStackView.create(spacing: Constants.altGroupSpacing)
    private var viewModel: DSRadioBtnWithAltViewModel?
    private var observations = [NSKeyValueObservation]()
    
    public override func setupSubviews() {
        super.setupSubviews()
        addSubview(radioBtnStack)
        radioBtnStack.fillSuperview()
    }
    
    public func configure(with viewModel: DSRadioBtnWithAltViewModel) {
        self.viewModel = viewModel
        let radioGroupBuilder = DSRadioButtonGroupBuilder()
        for item in viewModel.items {
            if let groupView = radioGroupBuilder.makeView(from: item.radioBtnGroupOrg,
                                                          withPadding: .custom(paddings: .zero),
                                                          eventHandler: viewModel.eventHandler) as? BoxView<ChecklistView> {
                radioBtnStack.addArrangedSubview(groupView)
                guard let itemViewModel = groupView.subview.viewModel else { return }
                viewModel.itemViewModels.append(itemViewModel)
            }
        }
        viewModel.itemViewModels.forEach({itemsViewModel in
            itemsViewModel.items.forEach({[weak self] itemVM in
                self?.observations.append(itemVM.observe(\.isSelected, onChange: { [weak self] isSelected in
                    guard let self = self else { return }
                    guard isSelected else { return }
                    self.viewModel?.itemViewModels.forEach({$0.deselectAll(except: itemVM.code)})
                }))
            })
        })
        
        viewModel.itemViewModels.forEach({$0.deselectAll()})
    }
    
    // DSInputComponentProtocol
    
    public func isValid() -> Bool {
        viewModel?.itemViewModels.first(where: {$0.selectedItems().first != nil}) != nil
    }
    
    public func inputCode() -> String {
        return viewModel?.itemViewModels.first(where: {$0.selectedItems().first != nil})?.inputCode ?? "radioBtnWithAltOrg"
    }
    
    public func inputData() -> AnyCodable? {
        return viewModel?.itemViewModels.first(where: {$0.selectedItems().first != nil})?.selectedItems().first?.getInputData()
    }
        
}

extension DSRadioBtnWithAltView {
    enum Constants {
        static let altGroupSpacing: CGFloat = 16
    }
}
