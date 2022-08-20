//
//  UploadVC.swift
//  Snapchat Clone
//
//  Created by İhsan Elkatmış on 3.08.2022.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var UploadPhotoImage: UIImageView!
    @IBOutlet weak var UploadLibraryImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    UploadLibraryImage.isUserInteractionEnabled = true
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        UploadLibraryImage.addGestureRecognizer(gestureRecognizer)
    
    
    UploadPhotoImage.isUserInteractionEnabled = true
    let gestureRecognizerr =  UITapGestureRecognizer(target: self, action: #selector(choosephotos))
    UploadPhotoImage.addGestureRecognizer(gestureRecognizerr)
    
    }
        
    @objc func choosePicture() {
    
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
        
    @objc func choosephotos(){
    let vc = UIImagePickerController()
    vc.sourceType = .camera
    vc.allowsEditing = true
    vc.delegate = self
    present(vc, animated: true)

}
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        UploadLibraryImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func UploadClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = UploadLibraryImage.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")

                } else {
                    
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            
                            
                            let imageUrl = url?.absoluteString
                            
                            //FireStore
                            
                            let fireStore = Firestore.firestore()
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents {
                                            
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalDictionary = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                
                                                fireStore.collection("Snaps").document(documentId).setData(additionalDictionary, merge: true) { (error) in
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.UploadLibraryImage.image = UIImage(named: "library.png")
                                                    }
                                                }

                                            }
                                            
                                        }
                                    } else {
                                        let snapDictionary = ["imageUrlArray" : [imageUrl!], "snapOwner" : UserSingleton.sharedUserInfo.username,"date": FieldValue.serverTimestamp()] as [String : Any]
                                        
                                        fireStore.collection("Snaps").addDocument(data: snapDictionary) { (error) in
                                            if error != nil {
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ??  "Error")
                                            } else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.UploadLibraryImage.image = UIImage(named: "library.png")
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    
                    
                }
            }
            
        }
        
    }
    func makeAlert(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

