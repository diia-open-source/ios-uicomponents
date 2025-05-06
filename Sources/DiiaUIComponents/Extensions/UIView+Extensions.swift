import UIKit

public extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
    
    class func fromNib<T: UIView>(bundle: Bundle = Bundle.main) -> T {
        // swiftlint:disable:next force_unwrapping
        return bundle.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T // swiftlint:disable:this force_cast
    }
    
    func fromNib(bundle: Bundle = Bundle.main) {
        let nib = UINib(nibName: String(describing: self.classForCoder), bundle: bundle)
        
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = self.bounds
        }
    }
    
    func findFirstSubview<T: UIView>(ofType type: T.Type) -> T? {
        for subview in subviews {
            if let typedSubview = subview as? T {
                return typedSubview
            }
        }
        for subview in subviews {
            if let typedSubview = subview.findFirstSubview(ofType: type) {
                return typedSubview
            }
        }
        return nil
    }
    
    func findTypedSubviews<T>() -> [T] {
        if let view = self as? T {
            return [view]
        }
        return subviews.flatMap { $0.findTypedSubviews() }
    }
}
