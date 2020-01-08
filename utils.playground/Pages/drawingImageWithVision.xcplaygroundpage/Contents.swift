import UIKit
import PencilKit
import XCPlayground
import PlaygroundSupport

// please write live view

final class DrawingCanvasViewController: UIViewController {
    private var saveDirectoryURL = playgroundSharedDataDirectory
    private var saveImageSize = CGSize(width: 48.0, height: 48.0)
    
    private var submitWorkItem: DispatchWorkItem?
    
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

        setup()
        configureView()
    }
}

private extension DrawingCanvasViewController {
    private func setup() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: saveDirectoryURL.absoluteString) {
            try! fileManager.createDirectory(
                at: saveDirectoryURL,
                withIntermediateDirectories: true,
                attributes: nil)
        }
        print("save directory: \(saveDirectoryURL)")
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
        
        if let resizedImage = image.resize(size: saveImageSize) {
            saveImage(image: resizedImage)
        }
        
        clear()
    }
    
    func saveImage(image: UIImage, fileName: String = String(Int(Date().timeIntervalSince1970))) {
        let fileURL = saveDirectoryURL.appendingPathComponent(fileName + ".png")
        print("save path: \(fileURL)")
        try! image.pngData()!.write(to: fileURL)
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = DrawingCanvasViewController()
