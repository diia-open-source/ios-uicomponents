
import UIKit
import Foundation
import DiiaCommonTypes

public final class DSChipGroupOrgV2View: BaseCodeView {
    
    private let chipsStack = UIStackView.create(spacing: Constants.viewPadding,
                                                distribution: .fillEqually)
    private let mainHeaderView = DSTableMainHeadingView()
    private let secondaryHeadingView = TableSecondaryHeadingView()
    
    private let viewStack = UIStackView.create(spacing: Constants.viewPadding)
    
    private var viewModels = [DSChipBlackMlcViewModel]()
    private var selectedChipModel: DSChipBlackMlcViewModel?
    
    public override func setupSubviews() {
        viewStack.addArrangedSubviews([mainHeaderView, secondaryHeadingView, chipsStack])
        
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        
        addSubview(viewStack)
        
        viewStack.fillSuperview(padding: .allSides(Constants.viewPadding))
        
        let chipsConstr = chipsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        chipsConstr.priority = .defaultHigh
        chipsConstr.isActive = true
    }
    
    public func configure(for chipsGroup: DSChipGroupOrgV2,
                          chipSelectedCallback: ((AnyCodable) -> Void)? = nil) {
        mainHeaderView.isHidden = chipsGroup.tableMainHeadingMlc == nil
        if let mainHeaderMlc = chipsGroup.tableMainHeadingMlc {
            let viewModel = DSTableMainHeadingViewModel(headingModel: mainHeaderMlc)
            mainHeaderView.configure(with: viewModel)
        }
        if let secondaryHeaderMlc = chipsGroup.tableSecondaryHeadingMlc {
            let viewModel = TableSecondaryHeadingViewModel(headingModel: secondaryHeaderMlc)
            secondaryHeadingView.configure(with: viewModel)
        }
        secondaryHeadingView.isHidden = chipsGroup.tableSecondaryHeadingMlc == nil
        
        chipsStack.isHidden = chipsGroup.items.isEmpty
        
        var viewModels = [DSChipBlackMlcViewModel]()
        chipsStack.safelyRemoveArrangedSubviews()
        self.viewModels = []
        var index = 0
        while index < chipsGroup.items.count {
            let horizontalStack = UIStackView.create(.horizontal,
                                                     spacing: Constants.viewPadding,
                                                     distribution: .fillEqually)
            for _ in 0..<Constants.rowInLine where index < chipsGroup.items.count {
                let chipTimeView = DSChipBlackMlcView()
                let chipBlackMlc = chipsGroup.items[index].chipBlackMlc
                let chipViewModel = DSChipBlackMlcViewModel(model: chipBlackMlc)
                
                chipViewModel.onClick = {[weak self, weak chipViewModel] event in
                    guard let chipViewModel, self?.selectedChipModel != chipViewModel else { return }
                    self?.selectedChipModel?.state.value = .unselected
                    chipViewModel.state.value = .selected
                    self?.selectedChipModel = chipViewModel
                    if let data = chipViewModel.dataJson {
                        chipSelectedCallback?(data)
                    }
                }
                chipTimeView.configure(with: chipViewModel)
                horizontalStack.addArrangedSubview(chipTimeView)
                viewModels.append(chipViewModel)
                
                index += 1
            }
            chipsStack.isHidden = false
            if horizontalStack.arrangedSubviews.count < Constants.rowInLine {
                let rowAfter = Constants.rowInLine - horizontalStack.arrangedSubviews.count
                (0..<rowAfter).forEach({_ in horizontalStack.addArrangedSubview(UIView())})
            }
            chipsStack.addArrangedSubview(horizontalStack)
        }
        self.viewModels = viewModels
    }
    
}

private extension DSChipGroupOrgV2View {
    enum Constants {
        static let rowInLine = 3
        static let cornerRadius: CGFloat = 16
        static let viewPadding: CGFloat = 16
    }
}
