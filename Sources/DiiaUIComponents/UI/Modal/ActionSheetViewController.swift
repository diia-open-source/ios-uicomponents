import UIKit
import DiiaMVPModule
import DiiaCommonTypes

public struct SeparatorParameters {
    public let padding: CGFloat
    public let height: CGFloat
    
    public init(padding: CGFloat, height: CGFloat) {
        self.padding = padding
        self.height = height
    }
}

public final class ActionSheetModule: BaseModule {
    private let view: ActionSheetViewController
    
    public init(actions: [[Action]], separatorColorStr: String = AppConstants.Colors.separatorColor) {
        view = ActionSheetViewController()
        view.actions = actions
        view.lastAction = Action(title: R.Strings.general_close.localized(), iconName: nil, callback: {})
        view.separatorColorStr = AppConstants.Colors.separatorColor
        view.separatorParams = SeparatorParameters(
            padding: ActionSheetViewController.Constants.spacing,
            height: ActionSheetViewController.Constants.separatorHeight
        )
    }
    
    public init(
        actions: [[Action]],
        lastAction: Action,
        separatorColorStr: String = AppConstants.Colors.separatorColor,
        separatorParams: SeparatorParameters
    ) {
        view = ActionSheetViewController()
        view.actions = actions
        view.lastAction = lastAction
        view.separatorColorStr = separatorColorStr
        view.separatorParams = separatorParams
    }
    
    public func viewController() -> UIViewController {
        let vc = ChildContainerViewController()
        vc.childSubview = view
        vc.presentationStyle = .actionSheet
        return vc
    }
}

open class ActionSheetViewController: UIViewController, ChildSubcontroller {
    
    // MARK: - Properties
    public weak var container: ContainerProtocol?
    
    private let containerView = UIView()
    private let scrollView = UIScrollView()
    private let actionStackView = UIStackView.create(views: [])
    private var lastButtonSeparatorHeightConstraint: NSLayoutConstraint?
    private let lastButton = ActionButton()
    
    public var actions: [[Action]] = [] {
        didSet {
            updateViews()
        }
    }
    
    public var lastAction: Action = Action(title: R.Strings.general_close.localized(),
                                           image: nil,
                                           callback: {}) {
        didSet {
            updateViews()
        }
    }
    
    public var separatorColorStr: String = AppConstants.Colors.separatorColor {
        didSet {
            updateViews()
        }
    }
    
    public var separatorParams = SeparatorParameters.init(padding: Constants.spacing,
                                                          height: Constants.separatorHeight) {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - LifeCycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupAccessibility()
    }
    
    // MARK: - Private Methods
    private func setupSubviews() {
        view.backgroundColor = .clear
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        
        view.addSubview(containerView)
        containerView.backgroundColor = .clear
        scrollView.backgroundColor = .white
        scrollView.layer.cornerRadius = Constants.cornerRadius
        
        containerView.anchor(top: nil,
                             leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor,
                             padding: .init(top: .zero,
                                            left: Constants.spacing,
                                            bottom: Constants.spacing,
                                            right: Constants.spacing)
        )
                
        containerView.addSubview(lastButton)
        lastButton.anchor(top: nil, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor)
        configureButton(button: lastButton, align: .center)
        
        containerView.addSubview(scrollView)
        scrollView.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            bottom: lastButton.topAnchor,
            trailing: containerView.trailingAnchor,
            padding: .init(top: .zero, left: .zero, bottom: Constants.smallSpacing, right: .zero))
        
        scrollView.addSubview(actionStackView)
        actionStackView.fillSuperview()
        actionStackView.anchor(top: nil, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor)
        
        let stackHeightConstraint = actionStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        stackHeightConstraint.priority = .defaultLow
        stackHeightConstraint.isActive = true
        
        containerView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.spacing).isActive = true
    }
    
    private func updateViews() {
        actionStackView.safelyRemoveArrangedSubviews()
        
        lastButtonSeparatorHeightConstraint?.constant = separatorParams.height
        
        let firstView = BoxView(subview: UIView()).withConstraints(size: .init(width: actionStackView.frame.width, height: Constants.smallSpacing))
        firstView.subview.backgroundColor = .white
        actionStackView.addArrangedSubview(firstView)
        
        for (index, groupActions) in actions.enumerated() {
            for action in groupActions {
                actionStackView.addArrangedSubview(buttonForAction(action: action))
            }
            if index != (actions.endIndex - 1) {
                addSeparator(needSpacing: true)
            }
        }
        
        let newLastAction = Action(title: lastAction.title, image: lastAction.image, callback: { [weak self] in
            self?.close()
            self?.lastAction.callback()
        })
        lastButton.action = newLastAction
        configureButton(button: lastButton, align: .center)
        lastButton.layer.cornerRadius = Constants.lastButtonCorner
        lastButton.backgroundColor = .white
        lastButton.contentHorizontalAlignment = .center
        lastButton.titleLabel?.textAlignment = .center
        configureAccessibility()
        
        view.layoutIfNeeded()
    }
    
    private func buttonForAction(action: Action) -> ActionButton {
        let newAction = Action(title: action.title, image: action.image, callback: { [weak self] in
            self?.close()
            action.callback()
        })
        let button = ActionButton(action: newAction, type: .full)
        configureButton(button: button, align: .left)
        return button
    }
    
    private func addSeparator(needSpacing: Bool = false) {
        let separatorView = BoxView(subview: UIView()).withConstraints(
            insets: .init(top: 0, left: needSpacing ? Constants.spacing : 0, bottom: 0, right: needSpacing ? Constants.spacing : 0),
            size: .init(width: .zero, height: separatorParams.height))
        separatorView.subview.backgroundColor = Constants.separatorColor
        actionStackView.addArrangedSubview(separatorView)
    }

    private func configureButton(button: ActionButton, align: UIControl.ContentHorizontalAlignment) {
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = FontBook.bigText
        button.contentHorizontalAlignment = align
        button.contentVerticalAlignment = .center
        button.contentEdgeInsets = .init(top: Constants.spacing,
                                         left: Constants.defaultSpacing,
                                         bottom: Constants.spacing,
                                         right: Constants.spacing)
        if button.action?.title == nil || button.action?.title?.count == 0 {
            button.iconRenderingMode = .alwaysTemplate
            button.imageView?.tintColor = UIColor(separatorColorStr)
        } else {
            button.iconRenderingMode = .alwaysOriginal
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.lineBreakMode = .byWordWrapping
            if button.action?.image != nil {
                button.contentHorizontalAlignment = align
                button.titleEdgeInsets = Constants.textPadding
                button.contentEdgeInsets = .init(top: Constants.spacing,
                                                 left: Constants.defaultSpacing,
                                                 bottom: Constants.spacing,
                                                 right: Constants.spacing)
            }
        }
        button.withHeight(Constants.buttonHeight)
    }
    
    private func setupAccessibility() {
        lastButton.accessibilityLabel = R.Strings.general_close.localized()
    }
    
    private func configureAccessibility() {
        UIAccessibility.post(notification: .layoutChanged, argument: actionStackView.subviews.first)
    }
    
    // MARK: - Actions
    @objc private func close() {
        container?.close()
    }
}

// MARK: - Constants
extension ActionSheetViewController {
    fileprivate enum Constants {
        static let separatorColor = UIColor.black.withAlphaComponent(0.07)
        static let cornerRadius: CGFloat = 24
        static let buttonHeight: CGFloat = 56
        static let lastButtonCorner: CGFloat = 28
        static let spacing: CGFloat = 16
        static let defaultSpacing: CGFloat = 32
        static let textPadding = UIEdgeInsets(top: 20,
                                              left: 20,
                                              bottom: 20,
                                              right: 20)
        static let smallSpacing: CGFloat = spacing / 2
        static let separatorHeight: CGFloat = 1
    }
}
