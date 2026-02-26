
AI Fit Scanner is a native iOS application built with SwiftUI that leverages on-device machine learning to analyze and classify clothing and outfit images. Designed as a foundational tool for digital wardrobe management and AI-driven fit suggestions, the app allows users to seamlessly select photos from their media library and receive instant, intelligent classification results.

✨ Features
Native Photo Selection: Utilizes iOS 16+ PhotosPicker for a seamless, privacy-friendly media selection experience.

Real-Time Processing: Asynchronous image loading and classification using modern Swift Concurrency (Task, MainActor).

Robust AI Model: Powered by a custom image classification model trained on a comprehensive dataset of 25,000 images for high-accuracy fit and clothing recognition.

Modern UI/UX: A clean, responsive SwiftUI interface with state-driven UI updates (loading states, success, and error handling).

🛠️ Tech Stack
Language: Swift

Frameworks: SwiftUI, PhotosUI

Architecture: MVVM (Model-View-ViewModel) pattern using @StateObject

Concurrency: Swift async/await

Machine Learning: CoreML / Vision (via the ImageClassifier class)

📋 Requirements
iOS 16.0+ (Required for PhotosPickerItem and .loadTransferable)

Xcode 14.0+

Swift 5.7+

🚀 Getting Started
Prerequisites
To run this project, you will need the compiled CoreML model (.mlmodel or .mlmodelc) trained on your 25k image dataset.

Installation
Clone the repository:

Bash

git clone https://github.com/yourusername/AIFitScanner.git
Open the project in Xcode:

Bash

open AIFitScanner.xcodeproj
Ensure your custom ImageClassifier class and your CoreML model are added to the Xcode project target.

Select your target device or simulator and press Cmd + R to build and run.

📂 Code Overview
The main interface is driven by ContentView.swift, which handles the presentation layer:

@StateObject private var classifier: Manages the state and logic for the CoreML model interactions.

PhotosPicker: Replaces older UIImagePickerController implementations for modern, out-of-process image selection.

.onChange modifier: Listens for user selection, securely extracts the Data via loadTransferable, converts it to a UIImage, and passes it to the classifier on the Main Thread.

🤝 Contributing
Contributions, issues, and feature requests are welcome! Feel free to check the issues page.
