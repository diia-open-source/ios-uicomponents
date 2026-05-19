
import UIKit

public protocol ModalPresentationViewControllerProtocol {
    func close(animated: Bool)
}

public protocol ContainerProtocol: NSObjectProtocol {
    func close()
}

public protocol ChildSubcontroller: UIViewController {
    var container: ContainerProtocol? { get set }
}

public enum ChildPresentationStyle {
    case presentation
    case fullscreen
    case actionSheet
    case alert
}

final public class ChildContainerViewController: UIViewController, ModalPresentationViewControllerProtocol {

    // MARK: - Properties
    public var isClosingAlowed: Bool = true
    public var presentationStyle: ChildPresentationStyle = .fullscreen
    public var isAnimationFinished: Bool = false
    public var childSubview: ChildSubcontroller? {
        didSet {
            self.childSubview?.container = self
        }
    }
    
    private lazy var visualEffectView = CustomIntensityVisualEffectView(effect: UIBlurEffect(style: .dark), intensity: 0.15)

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityViewIsModal = true
        configureSubviews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isAnimationFinished {
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.visualEffectView.alpha = 1
        })
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isAnimationFinished {
            return
        }
        self.addChildSubview()
    }
    
    // MARK: - Configuration
    private func configureSubviews() {
        view.addSubview(visualEffectView)
        visualEffectView.alpha = 0
        visualEffectView.fillSuperview()
        visualEffectView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(backTap))
        visualEffectView.addGestureRecognizer(tap)
    }

    // MARK: - Actions
    @objc private func backTap() {
        if isClosingAlowed {
            close()
        }
    }
    
    public func close(animated: Bool) {
        if animated {
            close()
        } else {
            if let parent = self.parent {
                VCChildComposer.removeChild(self, from: parent, animationType: .none)
                parent.updateAccessibilityElements()
            }
        }
    }
    
    private func addChildSubview() {
        if let subview = childSubview {
            switch presentationStyle {
            case .actionSheet:
                VCChildComposer.addChild(subview, to: self, animationType: .bottom)
            case .alert:
                view.addSubview(subview.view)
                subview.view.translatesAutoresizingMaskIntoConstraints = false
                subview.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            case .fullscreen:
                VCChildComposer.addChild(subview, to: self, animationType: .fadeIn)
            case .presentation:
                visualEffectView.isHidden = true
                VCChildComposer.addChild(subview, to: self, animationType: .none)
            }
            isAnimationFinished = true
        }
        
        parent?.removeAccessibilityElements()
    }
}

extension ChildContainerViewController: ContainerProtocol {
    public func close() {
        if let subview = childSubview {
            switch presentationStyle {
            case .actionSheet:
                VCChildComposer.removeChild(subview, from: self, animationType: .bottom)
            case .alert, .fullscreen:
                VCChildComposer.removeChild(subview, from: self, animationType: .fadeIn)
            case .presentation:
                VCChildComposer.removeChild(subview, from: self, animationType: .none)
            }
        }
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.visualEffectView.alpha = 0
                    },
                    completion: { [weak self] _ in
                        if let self, let parent = self.parent {
                            VCChildComposer.removeChild(self, from: parent, animationType: .none)
                            parent.updateAccessibilityElements()
                        }
                    })
    }
}

public final class CustomIntensityVisualEffectView: UIVisualEffectView {
    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    private var animator: UIViewPropertyAnimator?
    private let intensity: CGFloat
    private let customEffect: UIVisualEffect

    private let reducedTransparencyBackgroundColor: UIColor

    // MARK: - Lifecycle
    public init(effect: UIVisualEffect, intensity: CGFloat, reducedTransparencyBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.2)) {
        self.customEffect = effect
        self.reducedTransparencyBackgroundColor = reducedTransparencyBackgroundColor
        self.intensity = max(0, min(1, intensity))
        super.init(effect: nil)
        addObservers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        tearDown()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            setupBlur()
        }
    }

    // MARK: - Private
    private func addObservers() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.setupBlur()
        }
    }

    private func setupBlur() {
        tearDown()

        guard !UIAccessibility.isReduceTransparencyEnabled else {
            backgroundColor = reducedTransparencyBackgroundColor
            return
        }

        let animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
            self?.effect = self?.customEffect
        }
        self.animator = animator
        animator.fractionComplete = intensity
        animator.pausesOnCompletion = true
    }

    private func tearDown() {
        effect = nil
        if let animator, animator.state != .inactive {
            animator.stopAnimation(true)
            self.animator = nil
        }
    }
}
