
import UIKit
import DiiaCommonTypes

public final class DSIconCardViewModel {
    public let iconLeft: String
    public let text: String
    public let touchAction: Callback?
    
    public init(model: DSIconCardModel, touchAction: Callback? = nil) {
        self.iconLeft = model.iconLeft
        self.text = model.label
        self.touchAction = touchAction
    }
}

/// design_system_code: iconCardMlc
final public class DSIconCardCell: UICollectionViewCell, Reusable {
    private let iconView: UIImageView = UIImageView().withSize(Constants.iconSize)
    private let titleLabel = UILabel()
    
    private var viewModel: DSIconCardViewModel?
    
    // MARK: - Lifecycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSIconCardViewModel) {
        self.viewModel = viewModel
        iconView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: viewModel.iconLeft)
        titleLabel.text = viewModel.text
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        titleLabel.font = FontBook.usualFont
        contentView.backgroundColor = Constants.backgroundColor
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true
        
        let stackView = UIStackView.create(
            .horizontal,
            views: [iconView, titleLabel],
            spacing: Constants.itemSpacing,
            alignment: .center)
        contentView.addSubview(stackView)
        stackView.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor)
        stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        addTapGestureRecognizer()
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        viewModel?.touchAction?()
    }
}

// MARK: - Constants
extension DSIconCardCell {
    private enum Constants {
        static let backgroundColor = UIColor.white.withAlphaComponent(0.4)
        static let iconSize = CGSize(width: 24, height: 24)
        static let cornerRadius: CGFloat = 16
        static let itemSpacing: CGFloat = 8
    }
}
