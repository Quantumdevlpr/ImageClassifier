import SwiftUI
import CoreML
import Vision
import UIKit
import Combine

class ImageClassifier: ObservableObject {
    @Published var classificationResult: String = "Upload an image to classify"
    
    func classifyImage(_ image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            classificationResult = "Unable to process image."
            return
        }
        
        do {
            // Load your specific Create ML model
            let config = MLModelConfiguration()
            // Attempt to locate a compiled Core ML model in the bundle
            let bundle = Bundle.main
            // Prefer a model named "ClothingClassifier.mlmodelc" if it exists
            let preferredModelURL = bundle.url(forResource: "ClothingClassifier", withExtension: "mlmodelc")
            
            // If preferred model isn't found, try to find any .mlmodelc in the bundle
            let modelURL: URL
            if let preferred = preferredModelURL {
                modelURL = preferred
            } else if let anyModelURL = bundle.urls(forResourcesWithExtension: "mlmodelc", subdirectory: nil)?.first {
                modelURL = anyModelURL
            } else {
                classificationResult = "No compiled Core ML model (.mlmodelc) found in app bundle. Add your model to the target."
                return
            }
            
            // Load the MLModel from the located URL
            let mlModel = try MLModel(contentsOf: modelURL, configuration: config)
            let visionModel = try VNCoreMLModel(for: mlModel)
            
            // Create a Vision request
            let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
                self?.processResults(for: request, error: error)
            }
            
            // Execute the request
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            DispatchQueue.global(qos: .userInitiated).async {
                try? handler.perform([request])
            }
        } catch {
            classificationResult = "Failed to load model: \(error.localizedDescription)"
        }
    }
    
    private func processResults(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            if let results = request.results as? [VNClassificationObservation],
               let topResult = results.first {
                // Format the output (e.g., "Tshirts - 95.5%")
                let confidence = String(format: "%.1f", topResult.confidence * 100)
                self.classificationResult = "\(topResult.identifier.capitalized) - \(confidence)%"
            } else {
                self.classificationResult = "Could not classify image."
            }
        }
    }
}

