import UIKit
import DiiaCommonTypes

public struct StubMessageViewModel {
    public let icon: String
    public let title: String?
    public let descriptionText: String?
    public let repeatAction: Callback?
    
    public init(icon: String, title: String? = nil, descriptionText: String? = nil, repeatAction: Callback? = nil) {
        self.icon = icon
        self.title = title
        self.descriptionText = descriptionText
        self.repeatAction = repeatAction
    }
}

/// design_system_code: stubMessageMlc
public class StubMessageViewV2: BaseCodeView {
    // MARK: - UI Elements
    private let emojiLabel = UILabel().withParameters(font: FontBook.stubEmoji)
    private let titleLabel = UILabel().withParameters(font: FontBook.emptyStateTitleFont)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let repeatButton = VerticalRoundButton()
    
    private var viewModel: StubMessageViewModel?
    
    // MARK: - Life Cycle
    public override func setupSubviews() {
        setupView()
        setupButton()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: StubMessageViewModel,
                          titleFont: UIFont = FontBook.emptyStateTitleFont,
                          emojiFont: UIFont = FontBook.stubEmoji,
                          buttonFont: UIFont = FontBook.usualFont) {
        self.viewModel = viewModel
        emojiLabel.text = viewModel.icon
        titleLabel.isHidden = viewModel.title?.count ?? 0 == 0
        titleLabel.text = viewModel.title
        descriptionLabel.isHidden = viewModel.descriptionText?.count ?? 0 == 0
        descriptionLabel.text = viewModel.descriptionText
        repeatButton.isHidden = viewModel.repeatAction == nil
        titleLabel.font = titleFont
        emojiLabel.font = emojiFont
        repeatButton.titleLabel?.font = buttonFont
    }
    
    public func configure(btnTitle: String,
                          titleFont: UIFont = FontBook.emptyStateTitleFont,
                          emojiFont: UIFont = FontBook.stubEmoji,
                          buttonFont: UIFont = FontBook.usualFont) {
        repeatButton.setTitle(btnTitle, for: .normal)
        titleLabel.font = titleFont
        emojiLabel.font = emojiFont
        repeatButton.titleLabel?.font = buttonFont
    }
    
    // MARK: - Private Methods
    private func setupView() {
        backgroundColor = .clear
        
        let textStack = UIStackView.create(
            views: [
                titleLabel,
                descriptionLabel
            ],
            spacing: Constants.descriptionSpacing,
            alignment: .center)
        
        let stack = UIStackView.create(
            views: [
                emojiLabel,
                textStack,
                repeatButton
            ],
            spacing: Constants.stackSpacing,
            alignment: .center)
        
        addSubview(stack)
        stack.fillSuperview()
        stack.setCustomSpacing(Constants.buttonSpacing, after: textStack)
        
        emojiLabel.textAlignment = .center
        titleLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
    }
    
    private func setupButton() {
        repeatButton.titleLabel?.font = FontBook.usualFont
        repeatButton.setTitleColor(.black, for: .normal)
        repeatButton.setTitle(R.Strings.general_retry.localized(), for: .normal)
        repeatButton.backgroundColor = .clear
        repeatButton.layer.borderWidth = Constants.buttonBorderWidth
        repeatButton.layer.borderColor = UIColor.black.cgColor
        repeatButton.contentEdgeInsets = Constants.buttonInsets
        repeatButton.addTarget(self, action: #selector(repeatTapped), for: .touchUpInside)
        repeatButton.withHeight(Constants.buttonHeight)
    }
    
    // MARK: - Actions
    @objc private func repeatTapped() {
        viewModel?.repeatAction?()
    }
}

extension StubMessageViewV2 {
    private enum Constants {
        static let buttonInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        static let buttonHeight: CGFloat = 36
        static let buttonBorderWidth: CGFloat = 2
        static let stackSpacing: CGFloat = 16
        static let buttonSpacing: CGFloat = 20
        static let descriptionSpacing: CGFloat = 8
    }
}
