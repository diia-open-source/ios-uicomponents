
import UIKit
import Kingfisher
import DiiaCommonTypes

public enum ImagePositionAlignment {
    case left
    case center
    case right
    case top
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

public extension UIImageView {
    func loadImage(imageURL: String?, placeholder: UIImage? = nil, completion: Callback? = nil, onError: Callback? = nil) {
        if let loader = UIComponentsConfiguration.shared.imageLoader {
            loader.loadImage(to: self, imageURL: imageURL, placeholder: placeholder, completion: completion, onError: onError)
        } else {
            loadImageViaKFService(imageURL: imageURL, placeholder: placeholder, completion: completion, onError: onError)
        }
    }

    func loadImageFromPrivateRepo(imageURL: String?,
                                  parameters: [String: String],
                                  transitionDuration: TimeInterval = 0.25,
                                  cacheExpiration: TimeInterval? = nil,
                                  placeholder: UIImage? = nil,
                                  completion: Callback? = nil,
                                  onError: Callback? = nil) {
        let modifier = AnyModifier { request in
            var mutableRequest = request
            parameters.forEach { mutableRequest.setValue($1, forHTTPHeaderField: $0) }
            return mutableRequest
        }
        var kfOptions: KingfisherOptionsInfo = [.cacheOriginalImage,
                                                .transition(.fade(transitionDuration)),
                                                .requestModifier(modifier)]
        if let cacheExpiration = cacheExpiration {
            kfOptions += [.diskCacheExpiration(.seconds(cacheExpiration)), .memoryCacheExpiration(.seconds(cacheExpiration))]
        }
        loadImageViaKFService(imageURL: imageURL, placeholder: placeholder, completion: completion, onError: onError, kfOptions: kfOptions)
    }

    func cancelLoading() {
        kf.cancelDownloadTask()
    }

    func animate(withGIFNamed resourceName: String) {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            log("Gif does not exist at that path")
            return
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
              let source = CGImageSourceCreateWithData(gifData as CFData, nil) else { return }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        animationImages = images
        startAnimating()
    }

    func stopAnimatingCustom() {
        animationImages = nil
    }

    func resizeAndFillImage(alignment: ImagePositionAlignment = .center) {
        guard let image = image else { return }
        contentMode = .scaleAspectFill
        self.image = image.resizeAndFill(to: self.bounds.size, alignment: alignment)
    }

    // MARK: - Private
    private func loadImageViaKFService(imageURL: String?,
                                       placeholder: UIImage? = nil,
                                       completion: Callback? = nil,
                                       onError: Callback? = nil,
                                       kfOptions: KingfisherOptionsInfo = [.cacheOriginalImage, .transition(.fade(0.25))]) {
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            image = placeholder
            onError?()
            return
        }

        kf.setImage(
            with: url,
            placeholder: placeholder,
            options: kfOptions,
            completionHandler: { result in
                switch result {
                case .success:
                    completion?()
                case .failure:
                    onError?()
                }
            }
        )
    }
}

public protocol ImageLoaderProtocol {
    func loadImage(to imageView: UIImageView,
                   imageURL: String?,
                   placeholder: UIImage?,
                   completion: Callback?,
                   onError: Callback?)
}
