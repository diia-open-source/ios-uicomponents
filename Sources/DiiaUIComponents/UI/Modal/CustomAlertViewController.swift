
import UIKit
import DiiaMVPModule
import DiiaCommonTypes

public enum AlertActionType {
    case normal
    case destructive
}

public struct AlertAction {
    public let title: String
    public let type: AlertActionType
    public let callback: Callback
    
    public init(title: String, type: AlertActionType, callback: @escaping Callback) {
        self.title = title
        self.type = type
        self.callback = callback
    }
}

public final class CustomActionSheetModule: BaseModule {
    private let view: CustomAlertViewController
    
    public init(title: String, message: String) {
        view = CustomAlertViewController(title: title, message: message, actions: [AlertAction(title: R.Strings.general_ok.localized(), type: .normal, callback: {})])
    }
    
    public init(title: String, message: String, actions: [AlertAction]) {
        view = CustomAlertViewController(title: title, message: message, actions: actions)
    }

    public func viewController() -> UIViewController {
        let vc = ChildContainerViewController()
        vc.childSubview = view
        vc.presentationStyle = .actionSheet
        return vc
    }
}

public final class CustomAlertModule: BaseModule {
    private let view: CustomAlertViewController
    
    public init(title: String, message: String) {
        view = CustomAlertViewController(title: title, message: message, actions: [AlertAction(title: R.Strings.general_ok.localized(), type: .normal, callback: {})])
    }
    
    public init(title: String, message: String, actions: [AlertAction]) {
        view = CustomAlertViewController(title: title, message: message, actions: actions)
    }

    public func viewController() -> UIViewController {
        let vc = ChildContainerViewController()
        vc.childSubview = view
        vc.presentationStyle = .fullscreen
        return vc
    }
}

class CustomAlertViewController: UIViewController, ChildSubcontroller {
    weak var container: ContainerProtocol?
    private let alertView = UIView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private var stackView = UIStackView.create(views: [])

    private let titleText: String
    private let message: String
    private var actions: [AlertAction] = [] {
        didSet {
            updateViews()
        }
    }
    
    init(title: String, message: String, actions: [AlertAction] = [AlertAction(title: R.Strings.general_ok.localized(), type: .normal, callback: {})]) {
        self.titleText = title
        self.message = message
        self.actions = actions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.titleText = ""
        self.message = ""
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addAction(action: AlertAction) {
        actions.append(action)
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.15)
        
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.alertWidthMultiplier).isActive = true
        alertView.layer.cornerRadius = Constants.cornerRadius
        alertView.backgroundColor = .white
        alertView.clipsToBounds = true
        
        alertView.addSubview(titleLabel)
        titleLabel.anchor(top: alertView.topAnchor,
                          leading: alertView.leadingAnchor,
                          bottom: nil,
                          trailing: alertView.trailingAnchor,
                          padding: .init(top: Constants.topInset,
                                         left: Constants.horizontalInset,
                                         bottom: 0,
                                         right: Constants.horizontalInset))
        titleLabel.numberOfLines = 0
        titleLabel.font = Constants.titleFont
        titleLabel.textAlignment = .center

        alertView.addSubview(messageLabel)
        messageLabel.anchor(top: titleLabel.bottomAnchor,
                            leading: alertView.leadingAnchor,
                            bottom: nil,
                            trailing: alertView.trailingAnchor,
                            padding: .init(top: Constants.interitemSpacing,
                                           left: Constants.horizontalInset,
                                           bottom: 0,
                                           right: Constants.horizontalInset))
        messageLabel.numberOfLines = 0
        messageLabel.font = Constants.messageFont
        messageLabel.textAlignment = .center
        
        let grayContainer = UIView()
        alertView.addSubview(grayContainer)
        grayContainer.anchor(top: messageLabel.bottomAnchor,
                             leading: alertView.leadingAnchor,
                             bottom: alertView.bottomAnchor,
                             trailing: alertView.trailingAnchor,
                             padding: .init(top: Constants.topInset - Constants.separatorHeight,
                                            left: 0,
                                            bottom: 0,
                                            right: 0))
        grayContainer.backgroundColor = Constants.separatorColor
        
        alertView.addSubview(stackView)
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        stackView.spacing = Constants.separatorHeight
        stackView.anchor(top: messageLabel.bottomAnchor,
                         leading: alertView.leadingAnchor,
                         bottom: alertView.bottomAnchor,
                         trailing: alertView.trailingAnchor,
                         padding: .init(top: Constants.topInset,
                                        left: 0,
                                        bottom: 0,
                                        right: 0))
    }
    
    private func updateViews() {
        titleLabel.text = titleText
        messageLabel.text = message
        
        stackView.safelyRemoveArrangedSubviews()
        
        var axis: NSLayoutConstraint.Axis = .horizontal
        let maxHorizontalButtonTextWidth: CGFloat = UIScreen.main.bounds.width * Constants.alertWidthMultiplier / CGFloat(actions.count) - Constants.horizontalInset
        for action in actions {
            let textWidth = action.title.width(withConstrainedHeight: Constants.buttonHeight, font: Constants.buttonFont)
            if textWidth > maxHorizontalButtonTextWidth {
                axis = .vertical
                break
            }
        }
        
        stackView.axis = axis
        for action in actions {
            let button = ActionButton(action: Action(title: action.title, iconName: nil, callback: { [weak self] in
                action.callback()
                self?.close()
            }), type: .text)
            configureButton(button: button, for: action.type)
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
            stackView.addArrangedSubview(button)
        }
    }
    
    private func configureButton(button: ActionButton, for type: AlertActionType) {
        let color: UIColor = type == .destructive ? Constants.destructiveTextColor : Constants.standartTextColor
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = .white
        button.highlightedColor = Constants.separatorColor
        button.titleLabel?.font = Constants.buttonFont
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
    }
    
    // MARK: - Actions
    @objc func close() {
        container?.close()
    }
}

// MARK: Constants
extension CustomAlertViewController {
    private enum Constants {
        static let alertWidthMultiplier: CGFloat = 0.72
        
        static let cornerRadius: CGFloat = 14
        static let horizontalInset: CGFloat = 16
        static let topInset: CGFloat = 20
        static let interitemSpacing: CGFloat = 20
        static let separatorHeight: CGFloat = 1
        static let buttonHeight: CGFloat = 44
        
        static let titleFont: UIFont = .boldSystemFont(ofSize: 17)
        static let messageFont: UIFont = .systemFont(ofSize: 13)
        static let buttonFont: UIFont = .systemFont(ofSize: 17)

        static let standartTextColor: UIColor = .init("#007AFF")
        static let destructiveTextColor: UIColor = .red
        static let separatorColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.15)
    }
}
