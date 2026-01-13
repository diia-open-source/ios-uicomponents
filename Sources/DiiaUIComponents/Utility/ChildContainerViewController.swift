
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
    
    private lazy var visualEffectView: UIView = {
        var visualEffectsOff = UIAccessibility.isReduceTransparencyEnabled
        if visualEffectsOff {
            let visualEffectView = UIView()
            visualEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            return visualEffectView
        } else {
            let blurView = CustomIntensityVisualEffectView(effect: UIBlurEffect(style: .dark), intensity: 0.15)
            blurView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            return blurView
        }
    }()
    
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
    // MARK: Private props
    private var animator: UIViewPropertyAnimator?
    private var intensity: CGFloat
    private var customEffect: UIVisualEffect?
    
    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    public init(effect: UIVisualEffect, intensity: CGFloat) {
        self.intensity = intensity
        self.customEffect = effect
        
        super.init(effect: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setupBlur() {
        let visualEffectsOff = UIAccessibility.isReduceTransparencyEnabled
        guard let customEffect, !visualEffectsOff else { return }
        
        animator?.stopAnimation(true)
        
        effect = nil
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
            self?.effect = customEffect
        }
        animator?.fractionComplete = intensity
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            setupBlur()
        }
    }
    
    deinit {
        animator?.stopAnimation(true)
    }
}
