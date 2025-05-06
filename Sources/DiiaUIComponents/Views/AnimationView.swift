
import UIKit
import DiiaCommonTypes

public protocol AnimatedViewProtocol where Self: UIView {
    func startAnimation()
    func stopAnimation()
}

public class AnimationView<T: AnimatedViewProtocol>: UIView {
    private let subview: T
    
    // MARK: - Init
    public init(_ subview: T) {
        self.subview = subview
        super.init(frame: .zero)
        
        addSubview(subview)
        subview.fillSuperview()
        
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleEnterForeground(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)
    }
    
    // MARK: - Actions
    @objc private func handleEnterBackground(_ notification: NSNotification) {
        subview.stopAnimation()
    }
    
    @objc private func handleEnterForeground(_ notification: NSNotification) {
        subview.startAnimation()
    }
}
