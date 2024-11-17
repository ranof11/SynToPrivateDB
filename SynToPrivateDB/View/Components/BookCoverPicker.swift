//
//  BookCoverPicker.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 17/11/24.
//

import SwiftUI

struct BookCoverPicker: View {
    @Binding var image: UIImage?
    
    @State var isCameraActive = false
    @State var isPhotoPickerActive = false
    @State private var isActionSheetPresented = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                .foregroundStyle(.gray)
                .frame(width: 200, height: 200)
                .overlay (
                    Group {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 50))
                                    .foregroundStyle(.gray)
                                Text("Add a book cover")
                                    .foregroundStyle(.gray)
                                    .font(.headline)
                            }
                        }
                    }
                )
        }
        .onTapGesture {
            isActionSheetPresented = true
        }
        .actionSheet(isPresented: $isActionSheetPresented) {
            ActionSheet(
                title: Text("Choose an option"),
                buttons: [
                    .default(Text("Take a photo")) {
                        isCameraActive = true
                    },
                    .default(Text("Pick a photo")) {
                        isPhotoPickerActive = true
                    },
                    .cancel()
                ]
            )
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

#Preview {
    BookCoverPicker(image: .constant(nil))
}
