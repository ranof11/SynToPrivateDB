//
//  CustomActionSheet.swift
//  SynToPrivateDB
//
//  Created by Rajesh Triadi Noftarizal on 17/11/24.
//

import SwiftUI

struct ActionSheetItem {
    let title: String
    let icon: String
    let action: () -> Void
}

struct CustomActionSheet: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let actions: [ActionSheetItem]

    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController() // A dummy view controller to present the alert
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented, uiViewController.presentedViewController == nil {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            for action in actions {
                let alertAction = UIAlertAction(title: action.title, style: .default) { _ in
                    action.action()
                    isPresented = false
                }
                
                // Add an icon to the alert action
                if let image = UIImage(systemName: action.icon) {
                    alertAction.setValue(image.withRenderingMode(.alwaysOriginal), forKey: "image")
                }

                alertController.addAction(alertAction)
            }

            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                isPresented = false
            })

            uiViewController.present(alertController, animated: true, completion: nil)
        }
    }
}

extension View {
    func customActionSheet(isPresented: Binding<Bool>, actions: [ActionSheetItem]) -> some View {
        self.background(
            CustomActionSheet(isPresented: isPresented, actions: actions)
        )
    }
}
