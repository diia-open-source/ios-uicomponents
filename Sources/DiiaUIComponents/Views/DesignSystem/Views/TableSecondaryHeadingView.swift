
import UIKit
import DiiaCommonTypes

struct TableSecondaryHeadingViewModel {
    let headingModel: DSTableHeadingItemModel
    var onClickAction: Callback?
}

class TableSecondaryHeadingView: BaseCodeView {
    private let label = UILabel().withParameters(font: FontBook.bigText, textColor: .black)
    private let headingButton = ActionButton(type: .icon)
    private var viewModel: TableSecondaryHeadingViewModel?
    
    override func setupSubviews() {
        headingButton.tintColor = .black
        headingButton.isHidden = true
        headingButton.withSize(Constants.buttonSize)
        
        let stackView = UIStackView(arrangedSubviews: [label, headingButton])
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackSpacing
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    func configure(with viewModel: TableSecondaryHeadingViewModel, onClickAction: Callback? = nil) {
        self.viewModel = viewModel
        self.viewModel?.onClickAction = onClickAction
        
        label.text = viewModel.headingModel.label
        if let iconModel = viewModel.headingModel.icon, let callback = onClickAction {
            let imageProvider = UIComponentsConfiguration.shared.imageProvider
            headingButton.action = Action(iconName: imageProvider?.imageNameForCode(imageCode: iconModel.code),
                                          callback: callback)
        }
        headingButton.isHidden = viewModel.headingModel.icon == nil
    }
}

private extension TableSecondaryHeadingView {
    enum Constants {
        static let buttonSize = CGSize(width: 24, height: 24)
        static let stackSpacing: CGFloat = 16
    }
}
