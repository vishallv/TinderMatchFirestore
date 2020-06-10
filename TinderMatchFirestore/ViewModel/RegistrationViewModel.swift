//
//  RegistrationViewModel.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 5/30/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import Firebase


class RegistrationViewModel {
    
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
    var fullName : String? {    didSet{formValidity()}}
    var email : String? {   didSet{formValidity()}}
    var password : String? {    didSet{formValidity()}}
    
    
    func performRegistration(completion : @escaping(Error?)->Void){
        guard let email = email, let password = password else {return}
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err{
                completion(err)
                return
            }
            self.saveImageToFireStore(completion: completion)
        }
    }
    
    fileprivate func saveImageToFireStore(completion : @escaping(Error?)->Void){
        
        let fileName = NSUUID().uuidString
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        
        let ref = Storage.storage().reference().child("/images/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { (_, err) in
            
            if let error = err {
                completion(error)
                return
            }
            
            ref.downloadURL { (url, error) in
                if let error = error {
                    completion(error)
                    return
                }
                self.bindableIsRegistering.value = false
                print(url?.absoluteString ?? "")
                let imageURL = url?.absoluteString ?? ""
                self.saveInfoToFireStore(imageURl: imageURL, completion: completion)
                
//                completion(nil)
            }
        }
    }
    
    fileprivate func saveInfoToFireStore(imageURl : String,completion : @escaping(Error?)->Void){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData  : [String:Any] = ["fullname":fullName ?? "",
                       "uid":uid,
                       "imageURL1":imageURl,
                       "age" : 18,
                       "minSeekingAge": 18,
                       "maxSeekingAge": 50
                        ]
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let error = error{
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
     func formValidity(){
        let ifFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableIsFormValid.value = ifFormValid
    }
}

//        isFormValidObserver?(ifFormValid)
//    var isFormValidObserver : ((Bool)->())?

//    var image : UIImage?
//    {
//        didSet{
//            imageObserver?(image)
//        }
//    }
//
//    var imageObserver : ((UIImage?) ->())?
