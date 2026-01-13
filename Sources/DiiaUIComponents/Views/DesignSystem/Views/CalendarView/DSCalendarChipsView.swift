
import Foundation
import DiiaCommonTypes
import UIKit

public final class DSCalendarChipViewModel: NSObject {
    let chipsViewModels: [DSChipTimeViewModel]?
    let chipSelectedCallback: ((AnyCodable) -> Void)?
    
    public init(chipsViewModels: [DSChipTimeViewModel]?, chipSelectedCallback: ((AnyCodable) -> Void)? = nil) {
        self.chipsViewModels = chipsViewModels
        self.chipSelectedCallback = chipSelectedCallback
    }
}

public final class DSCalendarChipsView: BaseCodeView {
    
    private let chipsStack = UIStackView.create(spacing: Constants.spacing,
                                                distribution: .fillEqually)
    private let stubMessage = StubMessageViewV2()
    private let label = UILabel()
    private let viewStack = UIStackView.create()
    
    private var chipsViewModels: DSCalendarChipViewModel?
    private var selectedChipModel: DSChipTimeViewModel?
    
    public override func setupSubviews() {
        viewStack.addArrangedSubviews([stubMessage, chipsStack])
        addSubview(viewStack)
        addSubview(label)
        
        label.font = FontBook.usualFont
        
        label.anchor(top: topAnchor,
                     leading: leadingAnchor,
                     padding: .allSides(Constants.spacing))
        viewStack.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: .init(top: Constants.bigSpacing * 2,
                                        left: Constants.spacing,
                                        bottom: Constants.stubOffset,
                                        right: Constants.spacing))
        stubMessage.withHeight(Constants.stubHeight)
        
        let chipsConstr = chipsStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        chipsConstr.priority = .defaultHigh
        chipsConstr.isActive = true
        let stubConstr = stubMessage.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                             constant: -Constants.stubOffset)
        stubConstr.priority = .defaultHigh
        stubConstr.isActive = true
    }
    public func configure(for chipOrg: DSChipGroupOrg? = nil,
                          chipSelectedCallback: ((AnyCodable) -> Void)? = nil) {
        guard let chipOrg = chipOrg else {
            chipsStack.isHidden = true
            label.isHidden = true
            stubMessage.isHidden = false
            stubMessage.configure(with: .init(icon: Constants.stubEmoji,
                                              title: Constants.stubMessage),
                                  titleFont: FontBook.usualFont)
            return
        }
        
        label.isHidden = false
        chipsStack.isHidden = false
        stubMessage.isHidden = true
        
        label.text = chipOrg.label
        var viewModels = [DSChipTimeViewModel]()
        chipsStack.safelyRemoveArrangedSubviews()
        var index = 0
        while index < chipOrg.items.count {
            let horizontalStack = UIStackView.create(.horizontal,
                                                     spacing: Constants.bigSpacing,
                                                     distribution: .fillEqually)
            for _ in 0..<Constants.rowInLine where index < chipOrg.items.count {
                let chipTimeView = DSChipTimeMlcView()
                if let chipTimeMlc = chipOrg.items[index].chipTimeMlc {
                    let chipViewModel = DSChipTimeViewModel(chipMlc: chipTimeMlc)
                    chipViewModel.onChange = {[weak self, weak chipViewModel] isSelected in
                        guard isSelected, let chipViewModel = chipViewModel, self?.selectedChipModel != chipViewModel else { return }
                        self?.selectedChipModel?.isSelected = false
                        self?.selectedChipModel = chipViewModel
                        self?.chipsViewModels?.chipSelectedCallback?(chipViewModel.chipMlc.dataJson)
                    }
                    chipTimeView.configure(for: chipViewModel)
                    horizontalStack.addArrangedSubview(chipTimeView)
                    viewModels.append(chipViewModel)
                }
                index += 1
            }
            chipsStack.isHidden = false
            if horizontalStack.arrangedSubviews.count < Constants.rowInLine {
                let rowAfter = Constants.rowInLine - horizontalStack.arrangedSubviews.count
                (0..<rowAfter).forEach({_ in horizontalStack.addArrangedSubview(UIView())})
            }
            chipsStack.addArrangedSubview(horizontalStack)
        }
        self.chipsViewModels = DSCalendarChipViewModel(chipsViewModels: viewModels,
                                                       chipSelectedCallback: chipSelectedCallback)
    }
}

extension DSCalendarChipsView {
    enum Constants {
        static let spacing: CGFloat = 8
        static let bigSpacing: CGFloat = 16
        static let rowInLine: Int = 3
        static let stubOffset: CGFloat = 40
        static let stubHeight: CGFloat = 168
        static let stubMessage = "Спочатку оберіть дату реєстрації шлюбу"
        static let stubEmoji = "🗓️"
    }
}
