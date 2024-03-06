//
//  ImagePicker.swift
//  RoomExpence
//
//  Created by MQF-6 on 28/02/24.
//

import UIKit

class ImagePicker: NSObject {
    static var shared = ImagePicker()
    private var imagePickerController = UIImagePickerController()
    private var phPickerController = {UIImagePickerController()}
    
    var allowEditing = false
    var imageCompletion: ((UIImage) -> Void)?
    
    func openCamera() {
        imagePickerController.sourceType = .camera
        imagePickerController.allowsEditing = allowEditing
        imagePickerController.delegate = self
        UIApplication.shared.topMostVC()?.present(imagePickerController, animated: true)
    }
    
    func openGallery() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = allowEditing
        imagePickerController.delegate = self
        UIApplication.shared.topMostVC()?.present(imagePickerController, animated: true)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[allowEditing ? .editedImage : .originalImage] as? UIImage else {
            return
        }
        imageCompletion?(image)
        UIApplication.shared.topMostVC()?.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        UIApplication.shared.topMostVC()?.dismiss(animated: true)
    }
}
