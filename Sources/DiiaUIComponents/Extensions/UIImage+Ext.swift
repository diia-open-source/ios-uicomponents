
import UIKit

public extension UIImage {
    var roundedImage: UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        defer {
            // End context after returning to avoid memory leak
            UIGraphicsEndImageContext()
        }

        UIBezierPath(
            roundedRect: rect,
            cornerRadius: 4
        ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext() ?? nil
    }

    class func from(color: UIColor, withSize size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)

        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(color.cgColor)
        context.fill(rect)

        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()

        return img
    }
    
    class func gradientImage(with colors: [UIColor],
                             startPoint: CGPoint = CGPoint(x: 0, y: 0),
                             endPoint: CGPoint = CGPoint(x: 1, y: 1),
                             size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        
        let renderer = UIGraphicsImageRenderer(bounds: gradientLayer.frame)
        
        let image = renderer.image { context in
            gradientLayer.render(in: context.cgContext)
        }
        
        return image
    }

    class func qrCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")

        let filterFalseColor = CIFilter(name: "CIFalseColor")
        filterFalseColor?.setDefaults()
        filterFalseColor?.setValue(filter?.outputImage, forKey: "inputImage")
        // convert method
        let cgColor: CGColor = UIColor.black.cgColor
        let qrColor: CIColor = CIColor(cgColor: cgColor)
        let transparentBG: CIColor = CIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        filterFalseColor?.setValue(qrColor, forKey: "inputColor0")
        filterFalseColor?.setValue(transparentBG, forKey: "inputColor1")

        if let image = filterFalseColor?.outputImage {
            let transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            return UIImage(ciImage: image.transformed(by: transform))
        }

        return nil
    }

    class func barcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(3.00, forKey: "inputQuietSpace")
        filter?.setValue(data, forKey: "inputMessage")

        let filterFalseColor = CIFilter(name: "CIFalseColor")
        filterFalseColor?.setDefaults()
        filterFalseColor?.setValue(filter?.outputImage, forKey: "inputImage")
        // convert method
        let cgColor: CGColor = UIColor.black.cgColor
        let qrColor: CIColor = CIColor(cgColor: cgColor)
        let transparentBG: CIColor = CIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        filterFalseColor?.setValue(qrColor, forKey: "inputColor0")
        filterFalseColor?.setValue(transparentBG, forKey: "inputColor1")

        if let image = filterFalseColor?.outputImage {
            let transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            return UIImage(ciImage: image.transformed(by: transform))
        }

        return nil
    }

    // TODO: Check if it works with self.scale
    func scaled(forFittingSize fittingSize: CGSize, scale: CGFloat = 1) -> UIImage {
        let size = self.size
        guard size.width > fittingSize.width || size.height > fittingSize.height else {
            return self
        }
        let fixedFittingSize = CGSize(width: fittingSize.width.isZero ? .greatestFiniteMagnitude : fittingSize.width,
                                      height: fittingSize.height.isZero ? .greatestFiniteMagnitude : fittingSize.height)
        let imageScale = max(size.width/fixedFittingSize.width, size.height/fixedFittingSize.height)
        let newSize = CGSize(width: size.width / imageScale, height: size.height / imageScale)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }

    func scaled(forFillingSize fillingSize: CGSize) -> UIImage {
        let size = self.size
        let fixedScaleSize = CGSize(width: fillingSize.width.isZero ? .leastNormalMagnitude : fillingSize.width,
                                    height: fillingSize.height.isZero ? .leastNormalMagnitude : fillingSize.height)
        let scale = min(size.width/fixedScaleSize.width, size.height/fixedScaleSize.height)
        let newSize = CGSize(width: size.width / scale, height: size.height / scale)

        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }

    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let resizedImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return resizedImage
    }

    // this method used only in dfo
    func resizeAndFill(to viewSize: CGSize, alignment: ImagePositionAlignment = .center) -> UIImage? {
        let imgAspect = size.width / size.height
        let viewAspect = viewSize.width / viewSize.height

        var scaledSize: CGSize

        if viewAspect > imgAspect {
            scaledSize = CGSize(width: viewSize.width, height: viewSize.width / imgAspect)
        } else {
            scaledSize = CGSize(width: viewSize.height * imgAspect, height: viewSize.height)
        }

        let calculatedPositionPoint = calculateImagePositionPoint(by: alignment, for: CGSize(width: viewSize.width - scaledSize.width,
                                                                                             height: viewSize.height - scaledSize.height))
        let drawRect = CGRect(x: calculatedPositionPoint.x,
                              y: calculatedPositionPoint.y,
                              width: scaledSize.width,
                              height: scaledSize.height)

        UIGraphicsBeginImageContextWithOptions(viewSize, false, .zero)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.clip(to: CGRect(x: .zero, y: .zero, width: viewSize.width, height: viewSize.height))
        draw(in: drawRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    func centerFrame(widthToHeightRatio: CGFloat = 1) -> CGRect {

        if size.width > size.height * widthToHeightRatio {
            let newWidth = size.height * widthToHeightRatio
            return .init(x: (size.width - newWidth) / 2,
                         y: 0,
                         width: newWidth,
                         height: size.height)
        }
        let newHeight = size.width / widthToHeightRatio
        return .init(x: 0,
                     y: (size.height - newHeight) / 2,
                     width: size.width,
                     height: newHeight)
    }

    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {
        if let rawImageRef = self.cgImage {
            let colorMasking: [CGFloat] = [200, 255, 200, 255, 200, 255]
            UIGraphicsBeginImageContext(self.size)
            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking), let context = UIGraphicsGetCurrentContext() {
                context.translateBy(x: 0.0, y: self.size.height)
                context.scaleBy(x: 1.0, y: -1.0)
                context.draw(maskedImageRef, in: .init(x: 0, y: 0, width: size.width, height: size.height))
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        }
        return nil
    }

    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            // This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }

        guard let cgImage = self.cgImage else {
            // CGImage is not available
            return nil
        }

        guard let colorSpace = cgImage.colorSpace,
              let ctx = CGContext(data: nil,
                                  width: Int(size.width),
                                  height: Int(size.height),
                                  bitsPerComponent: cgImage.bitsPerComponent,
                                  bytesPerRow: 0,
                                  space: colorSpace,
                                  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else {
            return nil // Not able to create CGContext
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }

        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }

        ctx.concatenate(transform)

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }

        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }

    static func createWithBase64String(_ string: String?) -> UIImage? {
        if let string = string, let imageData = Data(base64Encoded: string, options: .ignoreUnknownCharacters) {
            return UIImage(data: imageData)
        }
        return nil
    }

    // MARK: - Private
    private func calculateImagePositionPoint(by alignment: ImagePositionAlignment,
                                             for size: CGSize) -> CGPoint {
        let positionPoint: CGPoint

        switch alignment {
        case .left:
            positionPoint = .init(x: 0, y: size.height / 2.0)
        case .center:
            positionPoint = .init(x: size.width / 2.0,
                                  y: size.height / 2.0)
        case .right:
            positionPoint = .init(x: size.width,
                                  y: size.height / 2.0)
        case .top:
            positionPoint = .init(x: size.width / 2.0,
                                  y: 0)
        case .bottom:
            positionPoint = .init(x: size.width / 2.0,
                                  y: size.height)
        case .topLeft:
            positionPoint = .init(x: 0, y: 0)
        case .topRight:
            positionPoint = .init(x: size.width, y: 0)
        case .bottomLeft:
            positionPoint = .init(x: 0, y: size.height)
        case .bottomRight:
            positionPoint = .init(x: size.width,
                                  y: size.height)
        }

        return positionPoint
    }
}

extension UIImage {
    public func withColor(_ color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
        
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
}
