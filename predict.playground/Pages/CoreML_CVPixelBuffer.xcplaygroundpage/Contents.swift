import UIKit
import CoreML

// define input
class MnistWithInterfaceInput : MLFeatureProvider {
    var image: CVPixelBuffer

    var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    init(image: CVPixelBuffer) {
        self.image = image
    }
}

let image = UIImage(named: "samples/4.png")!

let modelURL = Bundle.main.url(forResource: "MnistImageInput", withExtension: "mlmodelc")!
let model = try! MLModel(contentsOf: modelURL)

let pixelBuffer = image.pixelBufferGray(width: 28, height: 28)!
UIImage(ciImage: CIImage(cvImageBuffer: pixelBuffer))


let input = MnistWithInterfaceInput(image: pixelBuffer)
let output = try! model.prediction(from: input)

print("[symbol]")
print(output.featureValue(for: "symbol") ?? "none")
print("[classLabel]")
print(output.featureValue(for: "classLabel") ?? "none")

