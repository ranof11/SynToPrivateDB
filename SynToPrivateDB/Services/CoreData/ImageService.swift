//
//  ImageService.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 17/11/24.
//

import UIKit

class ImageService {
    func pickImage(from sourceType: UIImagePickerController.SourceType, completion: @escaping (UIImage?) -> Void) -> UIViewController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = PickerCoordinator(completion: completion)
        return picker
    }

    private class PickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let completion: (UIImage?) -> Void

        init(completion: @escaping (UIImage?) -> Void) {
            self.completion = completion
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            completion(info[.originalImage] as? UIImage)
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            completion(nil)
            picker.dismiss(animated: true)
        }
    }
}
