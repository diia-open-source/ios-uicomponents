import UIKit

public protocol DSImageNameProvider {
    func imageForCode(imageCode: String?) -> UIImage?
    func imageNameForCode(imageCode: String) -> String
}
