import UIKit
import Vision

let image = UIImage(named: "samples/4.png")!

let modelURL = Bundle.main.url(forResource: "MnistWithInterface", withExtension: "mlmodelc")!
let model = try! VNCoreMLModel(for: MLModel(contentsOf: modelURL))

let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
    guard let results = request.results as? [VNClassificationObservation] else {
        fatalError()
    }

    print("[predict result]")
    if let result = results.first {
        print("☀️ idntifier: \(result.identifier) (\(result.confidence))")
    }
    else {
        print("🌧not found")
    }

    print("[verbose]")
    for result in results {
        print("identifier: \(result.identifier) (\(result.confidence))")
    }
})

try! handler.perform([request])
