
import UIKit

/// design_system_code: inputPhoneMlc
public class PhoneCodeSelectorViewV2: BaseCodeView {
    
    // MARK: - Subviews
    private let flagLabel = UILabel().withParameters(font: FontBook.bigText)
    private let phoneCodeLabel = UILabel().withParameters(font: FontBook.bigText, numberOfLines: 1)
    private let arrowImageView = UIImageView().withSize(Constants.arrowImageSize)
    
    // MARK: - Init
    public override func setupSubviews() {
        arrowImageView.image = UIImage(named: "right_arrow")?.withRenderingMode(.alwaysTemplate)
        flagLabel.setContentHuggingPriority(.required, for: .horizontal)
        phoneCodeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        phoneCodeLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let stack = hstack(
            flagLabel, phoneCodeLabel, arrowImageView,
            spacing: Constants.contentSpacing,
            alignment: .center)
        
        stack.setCustomSpacing(Constants.codeIconSpacing,
                               after: phoneCodeLabel)
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSPhoneCodeSelectorViewModel) {
        flagLabel.text = viewModel.icon
        phoneCodeLabel.text = viewModel.value
        arrowImageView.tintColor = viewModel.isEditable ? .black : .lightGray
    }
    
    public func setupUI(textColor: UIColor = .black, imageColor: UIColor = .black) {
        phoneCodeLabel.textColor = textColor
        arrowImageView.tintColor = imageColor
    }
}

// MARK: - Constants
private extension PhoneCodeSelectorViewV2 {
    enum Constants {
        static let arrowImageSize = CGSize(width: 8, height: 8)
        static let contentSpacing: CGFloat = 4
        static let codeIconSpacing: CGFloat = 16
    }
}
