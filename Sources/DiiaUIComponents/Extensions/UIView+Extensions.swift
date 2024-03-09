import UIKit

public extension UIView {
    class func fromNib<T: UIView>(bundle: Bundle = Bundle.main) -> T {
        // swiftlint:disable:next force_unwrapping
        return bundle.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T // swiftlint:disable:this force_cast
    }
}

public extension UIView {
    func fromNib(bundle: Bundle = Bundle.main) {
        let nib = UINib(nibName: String(describing: self.classForCoder), bundle: bundle)
        
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(view)
            view.frame = self.bounds
        }
    }
}
