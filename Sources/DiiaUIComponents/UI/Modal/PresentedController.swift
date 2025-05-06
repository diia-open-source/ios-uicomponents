import UIKit

public final class PresentedController: UIViewController, ModalPresentationViewControllerProtocol {
    private let generalView = UIView()
    private let childContainerView = UIView()
    private let presentationView = UIView()
    
    private let viewController: UIViewController
    private var isFinishLoading: Bool = false
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewController = UIViewController()
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        parent?.beginAppearanceTransition(false, animated: false)
        parent?.endAppearanceTransition()

        if !isFinishLoading {
            changeTopOffset(offset: 0, animated: true)
            isFinishLoading = true
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIAccessibility.post(notification: .screenChanged, argument: self)
    }
    
    private func setupViews() {
        view.backgroundColor = .clear
        view.accessibilityViewIsModal = true
        
        generalView.clipsToBounds = true
        
        let fullScreenPresentations = [UIModalPresentationStyle.fullScreen, .overFullScreen]
        let isFullScreen = fullScreenPresentations.contains(viewController.modalPresentationStyle)
        let isCustomPresentation = viewController.modalPresentationStyle == .custom

        let topInset = isFullScreen ? 0 : Constants.topPosition
        view.addSubview(generalView)

        if !isFullScreen {
            generalView.layer.cornerRadius = Constants.cardCornerRadius
            generalView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            generalView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                               leading: view.leadingAnchor,
                               bottom: view.bottomAnchor,
                               trailing: view.trailingAnchor,
                               padding: .init(top: topInset, left: 0, bottom: 0, right: 0))
            presentationView.backgroundColor = Constants.topLineColor
            presentationView.layer.cornerRadius = Constants.topLineHeight/2
            
            generalView.addSubview(childContainerView)
            childContainerView.fillSuperview()
            
            if !isCustomPresentation {
                generalView.addSubview(presentationView)
                presentationView.anchor(top: generalView.topAnchor,
                                        leading: nil,
                                        bottom: nil,
                                        trailing: nil,
                                        padding: .init(top: Constants.topLineInset, left: 0, bottom: 0, right: 0),
                                        size: .init(width: Constants.topLineWidth, height: Constants.topLineHeight))
                presentationView.centerXAnchor.constraint(equalTo: generalView.centerXAnchor).isActive = true
            }
            generalView.backgroundColor = viewController.view.backgroundColor ?? viewController.children.first?.view.backgroundColor

            let topView = UIView()
            generalView.addSubview(topView)
            topView.backgroundColor = .clear
            topView.anchor(top: generalView.topAnchor,
                           leading: generalView.leadingAnchor,
                           bottom: nil,
                           trailing: generalView.trailingAnchor,
                           size: .init(width: 0, height: Constants.topPosition))
            
            VCChildComposer.addChild(viewController, to: self, in: childContainerView, animationType: .none)
            self.generalView.transform = .init(translationX: 0, y: Constants.bottomPosition)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture))
            panGestureRecognizer.delegate = self
            view.addGestureRecognizer(panGestureRecognizer)
        } else {
            generalView.fillSuperview()
            generalView.backgroundColor = viewController.view.backgroundColor ?? viewController.children.first?.view.backgroundColor
            generalView.addSubview(childContainerView)
            childContainerView.anchor(top: view.topAnchor,
                                      leading: generalView.leadingAnchor,
                                      bottom: generalView.bottomAnchor,
                                      trailing: generalView.trailingAnchor)
            
            VCChildComposer.addChild(viewController, to: self, in: childContainerView, animationType: .none)
            self.generalView.transform = .init(translationX: 0, y: Constants.bottomPosition)
        }
    }
    
    // MARK: - Actions
    @objc public func hide(animated: Bool = true) {
        changeTopOffset(offset: Constants.bottomPosition, animated: animated)
    }
    
    private func changeTopOffset(offset: CGFloat, animated: Bool = true) {
        let isClosing = offset == Constants.bottomPosition
        let backColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: Constants.maximumBackgroundAlpha * (1 - offset/Constants.bottomPosition))
        if animated {
            let progress = Double((isClosing ? Constants.bottomPosition : 0 - generalView.transform.ty) * (isClosing ? 1 : -1) / Constants.bottomPosition)
            let duration: TimeInterval = Constants.animationDuration * progress
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: [isClosing ? .curveEaseIn : .curveEaseOut],
                animations: {
                    self.view.backgroundColor = backColor
                    self.generalView.transform = .init(translationX: 0, y: offset)
                },
                completion: { [weak self] _ in
                    if isClosing {
                        self?.removeFromSuperview()
                    }
                }
            )
        } else {
            self.generalView.transform = .init(translationX: 0, y: offset)
            self.view.backgroundColor = backColor
            if isClosing {
                self.removeFromSuperview()
            }
        }
    }
    
    private func removeFromSuperview() {
        if let parent = self.parent {
            VCChildComposer.removeChild(self, from: parent, animationType: .none)
            parent.beginAppearanceTransition(true, animated: false)
            parent.endAppearanceTransition()
        }
    }
    
    // MARK: - Pan Handling
    @objc private func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        switch sender.state {
        case .began:
            break
        case .changed:
            if translation.y > 0 {
                changeTopOffset(offset: translation.y, animated: false)
            }
        case .ended:
            if translation.y > Constants.bottomPosition * Constants.proportionToClose || sender.velocity(in: view).y > Constants.velocityToClose {
                changeTopOffset(offset: Constants.bottomPosition)
                return
            }
            changeTopOffset(offset: 0)
        default:
            break
        }
    }
    
    // MARK: - ModalPresentationViewControllerProtocol
    public func close(animated: Bool) {
        hide(animated: animated)
    }
}

// MARK: UIGestureRecognizerDelegate
extension PresentedController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let yOffset = (gestureRecognizer as? UIPanGestureRecognizer)?.velocity(in: view).y ?? 0
        let xOffset = (gestureRecognizer as? UIPanGestureRecognizer)?.velocity(in: view).x ?? 0
        if let scrollView = otherGestureRecognizer.view as? UIScrollView {
            if scrollView.contentOffset.y == 0, yOffset > 0, yOffset.magnitude > xOffset.magnitude {
                otherGestureRecognizer.isEnabled = false
                otherGestureRecognizer.isEnabled = true
                return true
            }
            return false
        }
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let yOffset = (gestureRecognizer as? UIPanGestureRecognizer)?.velocity(in: view).y ?? 0
        let xOffset = (gestureRecognizer as? UIPanGestureRecognizer)?.velocity(in: view).x ?? 0
        if yOffset > 0, yOffset.magnitude > xOffset.magnitude {
            return true
        }
        return false
    }
}

// MARK: Constants
extension PresentedController {
    private enum Constants {
        static let cardCornerRadius: CGFloat = 24
        static let topPosition: CGFloat = 13
        static let bottomPosition: CGFloat = UIScreen.main.bounds.height - topPosition
        static let animationDuration: TimeInterval = 0.3
        static let proportionToClose: CGFloat = 0.7
        static let velocityToClose: CGFloat = 300.0
        static let maximumBackgroundAlpha: CGFloat = 0.7
        static let topLineWidth: CGFloat = 40
        static let topLineHeight: CGFloat = 4
        static let topLineInset: CGFloat = 16
        static let topLineColor = UIColor("#A9ACAC")
    }
}
