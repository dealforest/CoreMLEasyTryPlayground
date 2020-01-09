import UIKit
import PencilKit
import Vision
import XCPlayground
import PlaygroundSupport

final class DrawingCanvasViewController: UIViewController {
    private var submitWorkItem: DispatchWorkItem?
    private let model: VNCoreMLModel = {
        let modelURL = Bundle.main.url(forResource: "MnistImageInput", withExtension: "mlmodelc")!
            return try! VNCoreMLModel(for: MLModel(contentsOf: modelURL))
        }()
    
    private lazy var canvasView: PKCanvasView = {
        let canvasView = PKCanvasView(frame: UIScreen.main.bounds)
        canvasView.backgroundColor = .white
        canvasView.isOpaque = false
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 20)
        canvasView.delegate = self
        return canvasView
    }()
    
    override func loadView() {
        super.loadView()

        configureView()
    }
    
    private func configureView() {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(canvasView)
        self.view = view
    }
}

extension DrawingCanvasViewController: PKCanvasViewDelegate {
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        submitWorkItem?.cancel()
    }

    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        let drawingRect = canvasView.drawing.bounds
        guard drawingRect.size != .zero else {
            return
        }
        
        let intersectingViews = canvasView.subviews
            .compactMap { $0 as? UILabel }
            .filter { $0.frame.intersects(drawingRect) }
        
        guard intersectingViews.isEmpty else {
            intersectingViews.forEach { $0.removeFromSuperview() }
            clear()
            return
        }
        
        submitWorkItem = DispatchWorkItem {
            self.submitDrawing(canvasView: canvasView)
        }
        
        DispatchQueue
            .global(qos: .userInitiated)
            .asyncAfter(deadline: .now() + 1.0, execute: submitWorkItem!)
    }
}

private extension DrawingCanvasViewController {
    func clear() {
        DispatchQueue.main.async {
            self.canvasView.drawing = PKDrawing()
        }
    }
    
    func submitDrawing(canvasView: PKCanvasView) {
        let drawingRect = canvasView.drawing.bounds.containingSquare
        let image = canvasView.drawing.image(from: drawingRect, scale: UIScreen.main.scale * 2.0)
        
        if let resizedImage = image.resize(size: CGSize(width: 48.0, height: 48.0)) {
            predict(image: resizedImage)
        }
        
        clear()
    }
    
    func predict(image: UIImage) {
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError()
            }

            print("[result]")
            image
            if let result = results.first {
                print("☀️\(result.identifier): \(result.confidence)")
            }
            else {
                print("🌧not found")
            }

            print("[verbose]")
            for result in results {
                print("\(result.identifier): \(result.confidence)")
            }
        })
        
        try! handler.perform([request])
    }
}

extension CGRect {
    var containingSquare: CGRect {
        let dimension = max(size.width, size.height)
        let xInset = (size.width - dimension) / 2
        let yInset = (size.height - dimension) / 2
        return insetBy(dx: xInset, dy: yInset)
    }
}

extension UIImage {
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

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = DrawingCanvasViewController()


