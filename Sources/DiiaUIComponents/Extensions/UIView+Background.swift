import UIKit

public extension UIView {
    func addBackgroundImage(named imageName: String) {
        let image = UIImage(named: imageName)
        addBackgroundImage(image)
    }
    
    func addBackgroundImage(_ image: UIImage?) {
        let backgroundImage = UIImageView(image: image)
        addBackgroundImage(backgroundImage)
    }
    
    func addBackgroundImage(_ imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFill
        insertSubview(imageView, at: 0)
        imageView.fillSuperview()
    }
    
    func addBackgroundImage(_ imageURL: String?, placeholder: UIImage?) {
        let backgroundImage = UIImageView()
        backgroundImage.loadImage(imageURL: imageURL, placeholder: placeholder)
        addBackgroundImage(backgroundImage)
    }
}
