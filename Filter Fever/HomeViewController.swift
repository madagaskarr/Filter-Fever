

import UIKit

class HomeViewController: UIViewController {
    
    var takePictureButton: UIButton!
    var takePictureLabel: UILabel!
    var goToLibrary: UILabel!
    var openLibraryButton: UIButton!
    var imagePicker: UIImagePickerController!
    var backgroundImageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView = UIImageView(image: UIImage(named: "background"))
        backgroundImageView.contentMode = .scaleToFill
        backgroundImageView.frame = view.bounds
        view.addSubview(backgroundImageView)
        
        takePictureButton = UIButton()
        takePictureButton.setImage(UIImage(named: "camera"), for: .normal)
        takePictureButton.translatesAutoresizingMaskIntoConstraints = false
        takePictureButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        view.addSubview(takePictureButton)
        takePictureButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -65).isActive = true
        takePictureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        takePictureButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        takePictureButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        takePictureLabel = UILabel()
        takePictureLabel.text = "Take a Picture"
        takePictureLabel.textColor = .white
        takePictureLabel.textAlignment = .natural
        takePictureLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(takePictureLabel)
        takePictureLabel.leftAnchor.constraint(equalTo: takePictureButton.leftAnchor, constant: -30).isActive = true
        takePictureLabel.topAnchor.constraint(equalTo: takePictureButton.bottomAnchor, constant: 0).isActive = true
        takePictureLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        takePictureLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        openLibraryButton = UIButton()
        openLibraryButton.setImage(UIImage(named: "gallery"), for: .normal)
        openLibraryButton.translatesAutoresizingMaskIntoConstraints = false
        openLibraryButton.addTarget(self, action: #selector(openImages), for: .touchUpInside)
        view.addSubview(openLibraryButton)
        openLibraryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 65).isActive = true
        openLibraryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        openLibraryButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        openLibraryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        goToLibrary = UILabel()
        goToLibrary.text = "Go to Library"
        goToLibrary.textColor = .white
        goToLibrary.textAlignment = .natural
        goToLibrary.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goToLibrary)
        goToLibrary.leftAnchor.constraint(equalTo: openLibraryButton.leftAnchor, constant: -25).isActive = true
        goToLibrary.topAnchor.constraint(equalTo: openLibraryButton.bottomAnchor, constant: 0).isActive = true
        goToLibrary.widthAnchor.constraint(equalToConstant: 120).isActive = true
        goToLibrary.heightAnchor.constraint(equalToConstant: 50).isActive = true



        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        
    }

    
    @objc func openCamera() {
        
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func openImages() {
        imagePicker.sourceType = .photoLibrary;
        present(imagePicker, animated: true)
    }


}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        dismiss(animated: true, completion: nil)
        
        
        let vc = FiltersViewController()
        let navStack = UINavigationController(rootViewController: vc)
        vc.selectedImage = pickedImage
        present(navStack, animated: true, completion: nil)
    }
    


    

}

