//
//  BookCoverPicker.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 17/11/24.
//

import SwiftUI

struct BookCoverPicker: View {
    @Binding var image: UIImage?

    @State private var isCameraActive = false
    @State private var isPhotoPickerActive = false

    var body: some View {
        Menu {
            Button("Take a photo") {
                isCameraActive = true
            }

            Button("Pick a photo") {
                isPhotoPickerActive = true
            }
        } label: {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .sheet(isPresented: $isPhotoPickerActive) {
            ImagePicker(sourceType: .photoLibrary) { selectedImage in
                self.image = selectedImage
            }
        }
        .fullScreenCover(isPresented: $isCameraActive) {
            ImagePicker(sourceType: .camera) { selectedImage in
                self.image = selectedImage
            }
        }
    }
}
