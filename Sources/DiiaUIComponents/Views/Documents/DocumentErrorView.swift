
import UIKit
import DiiaCommonTypes

public struct DocumentErrorViewModel {
    public let title: String
    public let description: String
    public let action: Action?
    
    public init(title: String, description: String, action: Action? = nil) {
        self.title = title
        self.description = description
        self.action = action
    }
}

/// design_system_code: docCoverOrg

public class DocumentErrorView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var detailsLabel: UILabel!
    @IBOutlet weak private var actionButton: VerticalRoundButton!
    @IBOutlet weak private var detailsLabelTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    private var onButtonAction: Callback?
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        fromNib(bundle: Bundle.module)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fromNib(bundle: Bundle.module)
        initialSetup()
    }
        
    private func initialSetup() {
        titleLabel.font = FontBook.smallHeadingFont
        detailsLabel.font = FontBook.usualFont
        actionButton.layer.borderColor = UIColor.black.cgColor
        actionButton.layer.borderWidth = Constants.borderWidth
        actionButton.titleLabel?.font = FontBook.usualFont
        actionButton.setTitle(R.Strings.general_retry.localized(), for: .normal)
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DocumentErrorViewModel) {
        titleLabel.text = viewModel.title
        detailsLabel.attributedText = viewModel.description.attributed(font: detailsLabel.font, lineHeightMultiple: 1.25)
        
        onButtonAction = viewModel.action?.callback
        actionButton.setTitle(viewModel.action?.title, for: .normal)
        actionButton.isHidden = viewModel.action == nil
    }
    
    public func setDescriptionTrailing(offset: CGFloat) {
        detailsLabelTrailingConstraint.constant = offset
    }
    
    // MARK: - Private Methods
    @IBAction private func onActionButtonTapped() {
        onButtonAction?()
    }
}

// MARK: - Constants
private enum Constants {
    static let borderWidth: CGFloat = 2
}
