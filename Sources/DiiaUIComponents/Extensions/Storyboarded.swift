import UIKit

public protocol Storyboarded {
    static func storyboardInstantiate(bundle: Bundle) -> Self
}

public extension Storyboarded where Self: UIViewController {
    static func storyboardInstantiate(bundle: Bundle = Bundle.main) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)
        
        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]
        
        // load our storyboard
        let storyboard = UIStoryboard(name: className, bundle: bundle)
        
        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self // swiftlint:disable:this force_cast
    }
}
