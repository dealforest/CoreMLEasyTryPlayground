import UIKit

public extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let ratio = max(_size.width / size.width, _size.height / size.height)
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let resizedFrame = CGRect(origin: .zero, size: resizedSize)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return nil
        }
        
        context.clear(resizedFrame)
        context.setFillColor(UIColor.white.cgColor)
        context.fill(resizedFrame)
        context.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: resizedSize.height))
        context.draw(cgImage, in: resizedFrame)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
