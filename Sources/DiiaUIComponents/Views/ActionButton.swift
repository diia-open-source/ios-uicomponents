
import UIKit
import DiiaCommonTypes

public class ActionButton: UIButton {
    public enum ActionButtonType {
        case icon
        case text
        case full
    }
    
    public var action: Action? {
        didSet {
            update()
        }
    }
    
    public var type: ActionButtonType = .icon {
        didSet {
            update()
        }
    }
    
    public var iconRenderingMode: UIImage.RenderingMode = .alwaysTemplate {
        didSet {
            update()
        }
    }
        
    // MARK: - Initialise
    public init(action: Action = Action(title: nil, image: nil, callback: {}),
                type: ActionButtonType = .full) {
        self.type = type
        self.action = action
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    // MARK: - Configuration
    public func configure() {
        update()
        contentHorizontalAlignment = .left
        addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    
    public func update() {
        updateTitle()
        updateImage()
    }
    
    private func updateTitle() {
        let title: String
        
        switch type {
        case .text, .full:
            title = action?.title ?? ""
        default:
            title = ""
        }
        
        setTitle(title, for: .normal)

    }
    
    private func updateImage() {
        var image: UIImage?
        
        switch type {
        case .icon, .full:
            image = action?.image?.withRenderingMode(iconRenderingMode)
        default:
            break
        }
        
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
    }
    
    // MARK: - Actions
    @objc private func click() {
        action?.callback()
    }
    
    public func setupUI(
        font: UIFont = FontBook.smallHeadingFont,
        cornerRadius: CGFloat = Constants.defaultCorner,
        bordered: Bool = false,
        textColor: UIColor = .black,
        secondaryColor: UIColor = .white,
        imageRenderingMode: UIImage.RenderingMode = .alwaysTemplate,
        contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .center
    ) {
        setTitleColor(textColor, for: .normal)
        imageView?.tintColor = textColor
        tintColor = textColor
        titleLabel?.font = font
        backgroundColor = secondaryColor
        self.contentHorizontalAlignment = contentHorizontalAlignment

        iconRenderingMode = imageRenderingMode

        layer.cornerRadius = cornerRadius
        layer.borderWidth = bordered ? Constants.defaultBorder : Constants.emptyBorder
        layer.borderColor = textColor.cgColor
    }
}

public extension ActionButton {
    enum Constants {
        public static let defaultCorner: CGFloat = 5
        public static let defaultBorder: CGFloat = 2
        public static let emptyBorder: CGFloat = 0
    }
}
