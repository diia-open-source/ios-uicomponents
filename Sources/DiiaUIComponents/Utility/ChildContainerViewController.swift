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
        var visualEffectsOff = true
        if #available(iOS 11.0, *) {
            visualEffectsOff = UIAccessibility.isReduceTransparencyEnabled
        }
        if visualEffectsOff {
            let visualEffectView = UIView()
            visualEffectView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
            return visualEffectView
        } else {
            return CustomIntensityVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.light), intensity: 0.15)
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
                    completion: { _ in
                        if let parent = self.parent {
                            VCChildComposer.removeChild(self, from: parent, animationType: .none)
                        }
                    })
    }
}

public class CustomIntensityVisualEffectView: UIVisualEffectView {

    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    public init(effect: UIVisualEffect, intensity: CGFloat) {
        var visualEffectsOff = true
        if #available(iOS 11.0, *) {
            visualEffectsOff = UIAccessibility.isReduceTransparencyEnabled
        }
        if visualEffectsOff {
            super.init(effect: nil)
            return
        }
        super.init(effect: nil)

        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
        animator.fractionComplete = intensity
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: Private
    private var animator: UIViewPropertyAnimator!
}
