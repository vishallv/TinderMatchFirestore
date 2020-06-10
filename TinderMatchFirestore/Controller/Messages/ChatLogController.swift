//
//  ChatLogController.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/5/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import LBTATools
import Firebase



class ChatLogController : LBTAListController<MessageCell,Message>{
    
    //MARK: Properties
    deinit {
         print("ChatLogController Deinit")
    }
    lazy var customNavBar = MessageNavBar(match: match)
    
    let match : Match
    lazy var customInputView  : CustomInputAccessoryView = {
        let civ = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return civ
    }()
    
    override var inputAccessoryView: UIView?{
        get{
            return customInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //MARK: Life Cycle
    
    init(match : Match) {
        self.match = match
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        fetchMessages()
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor,
                            height: 150)
        
        collectionView.contentInset.top = 150
        collectionView.verticalScrollIndicatorInsets.top = 150
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        let statusBarView = UIView(backgroundColor: .white)
        
        view.addSubview(statusBarView)
        statusBarView.anchor(top:view.topAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.topAnchor,right: view.rightAnchor)
    }
    
    //MARK: Selector
    @objc func handleKeyboardShow(){
        
        collectionView.scrollToItem(at: [0,items.count-1], at: .bottom, animated: true)
    }
    
    @objc func handleSend(){
        
        saveToFromMessages()
        saveToRecentMessages()
        
    }
    
    func fetchCurrentUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let data = snapshot?.data() else {return}
            
            self.currentUser = User(dictionary: data)
        }
    }
    
    func saveToRecentMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let currentUser = currentUser else {return}
        let data = ["text":customInputView.textView.text ?? "",
                    "name": match.name,
                    "profileImageUrl": match.profileImageUrl,
                    "timestamp" : Timestamp(date: Date()),
                    "uid": match.uid] as [String : Any]
        Firestore.firestore().collection("matches_messages").document(uid).collection("recent_messages").document(match.uid).setData(data) { (error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
        }
        
        let toData = ["text":customInputView.textView.text ?? "",
        "name": currentUser.name ?? "",
        "profileImageUrl": currentUser.imageUrl1 ?? "",
        "timestamp" : Timestamp(date: Date()),
        "uid": uid] as [String : Any]
        
        Firestore.firestore().collection("matches_messages").document(match.uid).collection("recent_messages").document(uid).setData(toData) { (error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
        }
        
    }
    
    
    func saveToFromMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let collection =  Firestore.firestore().collection("matches_messages").document(uid).collection(match.uid)
        
        let data = ["text": customInputView.textView.text ?? "",
                    "fromID":uid, "toID": match.uid,"timeStamp" : Timestamp(date: Date())] as [String : Any]
        
        collection.addDocument(data: data) { (error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            self.customInputView.textView.text = nil
            self.customInputView.placeholderLabel.isHidden = false
        }
        
        let otherCollection =  Firestore.firestore().collection("matches_messages").document(match.uid).collection(uid)
        otherCollection.addDocument(data: data) { (error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            

        }
    }
    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent{
        listener?.remove()
        }
    }
    
    //MARK: Helper Function
    var listener : ListenerRegistration?
    
    func fetchMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let query = Firestore.firestore().collection("matches_messages").document(uid).collection(match.uid).order(by: "timeStamp")
        
       listener = query.addSnapshotListener { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            snapshot?.documentChanges.forEach({ (docSnapshot) in
                if docSnapshot.type == .added{
                    
                    let dictionary = docSnapshot.document.data()
                    self.items.append(Message(dictionary: dictionary))
                }
            })
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0,self.items.count-1], at: .bottom, animated: true)
            
        }
    }
}
extension ChatLogController :UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let estimatedCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedCell.item = items[indexPath.row]
        
        estimatedCell.layoutIfNeeded()
        
        let estimatedSize = estimatedCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000)).height
        
        return .init(width: view.frame.width, height: estimatedSize)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
        
        
    }
}
