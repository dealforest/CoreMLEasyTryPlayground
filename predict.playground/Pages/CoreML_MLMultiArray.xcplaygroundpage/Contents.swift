// ⚠️ I don't recommend using `MLMultiArray` directly.

import UIKit
import CoreML

// define input
class MnistInput : MLFeatureProvider {
    var image: MLMultiArray

    var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(multiArray: image)
        }
        return nil
    }
    
    init(image: MLMultiArray) {
        self.image = image
    }
}

extension UIImage {
    func pixelDataForGrayscale() -> [UInt8]? {
        guard let cgImage = self.cgImage else { return nil }
        
        let size = self.size
        let dataSize = size.width * size.height
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        
        let context = CGContext(
            data: &pixelData,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: Int(size.width),
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue)
        
        context?.draw(cgImage, in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        
        return pixelData
    }
}

func preprocess(image: UIImage) -> MLMultiArray? {
    // https://inneka.com/ml/kr/converting-uiimage-to-mlmultiarray-for-keras-model/
    guard let pixels = image.pixelDataForGrayscale() else {
        return nil
    }

    guard let array = try? MLMultiArray(shape: [1, 28, 28], dataType: .double) else {
        return nil
    }
    
    for (index, element) in pixels.enumerated() {
        let value = Double(element) / 255.0
        array[index] = NSNumber(value: value)
    }

    return array
}

let image = UIImage(named: "samples/4.png")!

let modelURL = Bundle.main.url(forResource: "Mnist", withExtension: "mlmodelc")!
let model = try! MLModel(contentsOf: modelURL)

let multiArray = preprocess(image: image)!
let input = MnistInput(image: multiArray)
let output = try! model.prediction(from: input)

print("[symbol]")
print(output.featureValue(for: "symbol") ?? "none")
print("[classLabel]")
print(output.featureValue(for: "classLabel") ?? "none")

