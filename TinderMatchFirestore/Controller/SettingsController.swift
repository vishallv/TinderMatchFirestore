//
//  SettingsController.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/2/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage
class CustomImagePickerController : UIImagePickerController{
    
    var imageButton : UIButton?
}

class HeaderLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
}


protocol SettingsControllerDelegate : class {
    func didSaveSetting()
}

class SettingsController: UITableViewController{
    
    //MARK: Properties
    deinit {
        print("SettingsController Deinit")
    }
    
    var user : User?
    weak var delegate : SettingsControllerDelegate?
    
    lazy var header : UIView = {
        let header = UIView()
        let padding : CGFloat = 16
        
        header.addSubview(imageButton1)
        imageButton1.anchor(top: header.topAnchor, left: header.leftAnchor,bottom: header.bottomAnchor ,
                            paddingTop: padding ,paddingLeft: padding ,paddingBottom: padding )
        imageButton1.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let verticalStack = UIStackView(arrangedSubviews: [imageButton2,imageButton3])
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = padding
        
        header.addSubview(verticalStack)
        verticalStack.anchor(top: header.topAnchor,left: imageButton1.rightAnchor,bottom: header.bottomAnchor,right: header.rightAnchor,
                             paddingTop: padding ,paddingLeft: padding ,paddingBottom: padding ,paddingRight: padding )
        return header
    }()
    
    lazy var imageButton1 = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageButton2 = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageButton3 = createButton(selector: #selector(handleSelectPhoto))
    
    func createButton(selector : Selector) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .white
        return button
    }
    
    
    //MARK: Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        tableView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
    }
    
    //MARK: Selector
    
    @objc func handleLogout(){
        try? Auth.auth().signOut()
        
        dismiss(animated: true)
    }
    @objc func handleSave(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData :  [String:Any] = [
            "uid":uid,
            "fullname" : user?.name ?? "",
            "imageURL1" : user?.imageUrl1 ?? "",
            "imageURL2" : user?.imageUrl2 ?? "",
            "imageURL3" : user?.imageUrl3 ?? "",
            "age" : user?.age ?? -1,
            "profession" : user?.profession ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge":user?.maxSeekingAge ?? -1
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving"
        hud.show(in: self.view)
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            hud.dismiss()
            if let err = err{
                print(err.localizedDescription)
                return
            }
            
            self.dismiss(animated: true) {
                self.delegate?.didSaveSetting()
            }
        }
        
    }
    
    @objc func handleSelectPhoto(button : UIButton){
        
        let imagePickerController = CustomImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageButton = button
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helper Function
    func fetchCurrentUser(){
        guard let  uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error{
                print(error)
                return
            }
            
            guard let userDict = snapshot?.data() else {return}
            let user = User(dictionary: userDict)
            self.user = user
            
            self.loadUserPhoto()
            self.tableView.reloadData()
            
        }
        
    }
    
    func loadUserPhoto(){
        if let imageUrl  = user?.imageUrl1, let url = URL(string: imageUrl)  {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                
                self.imageButton1.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl  = user?.imageUrl2, let url = URL(string: imageUrl)  {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                
                self.imageButton2.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageUrl  = user?.imageUrl3, let url = URL(string: imageUrl)  {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                
                self.imageButton3.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        
    }
    
    fileprivate func setupNavigationItem() {
        title = "Settings"
        setupLargeNavigationBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
                                              UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
    
}
extension SettingsController{
    
    func setupLargeNavigationBar(){
        if #available(iOS 13, *){
            let appearance = UINavigationBarAppearance()
            
            
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().prefersLargeTitles = true
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
        }
            
        else{
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = .white
        }
    }
}

//MARK:- Header Height and View
extension SettingsController{
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return header
        }
        
        let headerLabel = HeaderLabel()
        switch section{
        case 1: headerLabel.text = "Name"
        case 2: headerLabel.text = "Profession"
        case 3: headerLabel.text = "Age"
        case 4: headerLabel.text = "Bio"
        default: headerLabel.text = "Seeking Age Range"
            
        }
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 300
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }
        return 1
    }
    
    @objc func handleMinAgeChanges(slider : UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        let cell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        
        cell.minLabel.text = "Min: \(Int(slider.value))"
        self.user?.minSeekingAge = Int(slider.value)
    }
    
    @objc func handleMaxAgeChanges(slider : UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        let cell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        
        cell.maxLabel.text = "Max: \(Int(slider.value))"
        self.user?.maxSeekingAge = Int(slider.value)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5{
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChanges), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChanges), for: .valueChanged)
            
            
            ageRangeCell.minSlider.value = Float(user?.minSeekingAge ?? 18)
            ageRangeCell.maxSlider.value = Float(user?.maxSeekingAge ?? 50)
            
            ageRangeCell.minLabel.text = "Min: \(user?.minSeekingAge ?? 18)"
            ageRangeCell.maxLabel.text = "Min: \(user?.maxSeekingAge ?? 50)"
            return ageRangeCell
        }
        
        let cell = SettingCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section{
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age{
                cell.textField.text = String(age)
            }
            
        default:
            cell.textField.placeholder = "Enter Bio"
            
        }
        
        return cell
    }
    
    
    @objc func handleNameChange(textField :UITextField){
        
        self.user?.name = textField.text
    }
    
    @objc func handleProfessionChange(textField :UITextField){
        self.user?.profession = textField.text
    }
    
    @objc func handleAgeChange(textField :UITextField){
        
        self.user?.age = Int(textField.text ?? "")
    }
}

extension SettingsController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
        
        
        guard let imageData = image?.jpegData(compressionQuality: 0.8) else {return}
        let fileName = NSUUID().uuidString
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading Image"
        hud.show(in: self.view)
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        ref.putData(imageData, metadata: nil) { (_, error) in
            
            
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            ref.downloadURL { (url, error) in
                hud.dismiss()
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                print(url?.absoluteString ?? "")
                
                if imageButton == self.imageButton1{
                    self.user?.imageUrl1 = url?.absoluteString
                }
                else if imageButton == self.imageButton2{
                    self.user?.imageUrl2 = url?.absoluteString
                }
                else{
                    self.user?.imageUrl3 = url?.absoluteString
                }
            }
        }
        
    }
}


