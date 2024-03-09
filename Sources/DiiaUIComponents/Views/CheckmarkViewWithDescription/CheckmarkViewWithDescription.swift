import UIKit

@objc public protocol CheckmarkViewWithDescriptionDelegate {
    func didSelect(id: String)
}

@objc public protocol CheckBoxViewWithDescriptionDelegate {
    func didSelect(index: String, status: Bool)
}

public class CheckmarkViewWithDescription: UIView {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var checkedImageView: UIImageView!
    
    @IBOutlet weak private var bottomSeparatorView: UIView!
    public weak var delegate: CheckmarkViewWithDescriptionDelegate?
    public weak var checkMarkDelegate: CheckBoxViewWithDescriptionDelegate?
    public var id: String = "-1"
    
    private var useRoundButton: Bool = true
    private var isChecked: Bool = false {
        didSet {
            if useRoundButton {
                self.checkedImageView.image = isChecked ? R.image.radioCheckbox.image : R.image.roundButton_disabled.image
            } else {
                self.checkedImageView.image = isChecked ? R.image.checkbox_enabled.image : R.image.checkbox_disabled.image
            }
        }
    }
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib(bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fromNib(bundle: Bundle.module)
    }
    
    // MARK: - Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setUpUI() {
        self.titleLabel.font = FontBook.usualFont
        self.descriptionLabel.font = FontBook.usualFont
    }
    
    public func setUp(id: String,
                      title: String,
                      description: String? = nil,
                      isChecked: Bool = false,
                      userRoundButton: Bool = true,
                      isSeparatorHidden: Bool = false
    ) {
        setUpUI()
        self.useRoundButton = userRoundButton
        self.id = id
        self.titleLabel.text = title
        if let description = description {
            self.descriptionLabel.text = description
        }
        self.isChecked = isChecked
        self.bottomSeparatorView.isHidden = isSeparatorHidden
    }
    
    public func toggleCheck(status: Bool) {
        self.isChecked = status
    }
    
    public func toggleSingleCheckBox() {
        self.isChecked = !self.isChecked
    }
    
    @IBAction func didTapOnView(_ sender: Any) {
        delegate?.didSelect(id: self.id)
        if let checkMarkDelegate = checkMarkDelegate {
            self.toggleSingleCheckBox()
            checkMarkDelegate.didSelect(index: self.id, status: self.isChecked)
        }
    }
}
