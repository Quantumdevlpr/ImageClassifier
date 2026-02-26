import SwiftUI
import PhotosUI
struct ContentView: View {
    @StateObject private var classifier = ImageClassifier()
    @State private var selectedImage: UIImage?
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 30) {
            Text("AI Fit Scanner")
                .font(.largeTitle)
                .fontWeight(.bold)
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .overlay(Text("No Image Selected").foregroundColor(.gray))
            }
            
            Text(classifier.classificationResult)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                Label("Open Media Library", systemImage: "photo.fill.on.rectangle.fill")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .onChange(of: selectedPhotoItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.selectedImage = uiImage
                        classifier.classificationResult = "Analyzing..."
                        classifier.classifyImage(uiImage)
                    }
                } else {
                    await MainActor.run {
                        classifier.classificationResult = "Failed to load image."
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
