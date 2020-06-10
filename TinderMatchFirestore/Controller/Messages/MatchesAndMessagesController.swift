//
//  MatchesAndMessagesController.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/5/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import LBTATools
import Firebase

struct RecentMessage {
    let text,uid, name , profileImageUrl : String
    let timestamp : Timestamp
    
    
    init(dictionary : [String:Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}


class RecentMessageCell : LBTAListCell<RecentMessage>{
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "lady4c"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "USER name", font: .boldSystemFont(ofSize: 18))
    let messageLabel = UILabel(text: "dsadnlkanmdlkandlsanjlfnaslfnlajfnlasnfjn sanljasdnlandla", font: .systemFont(ofSize: 15),textColor: .lightGray,numberOfLines: 2)
    
    override var item: RecentMessage!{
        didSet{
            usernameLabel.text = item.name
            messageLabel.text = item.text
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl), completed: nil)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        profileImageView.setDimensions(width: 90, height: 90)
        profileImageView.layer.cornerRadius = 90/2
        profileImageView.clipsToBounds = true
        hstack(profileImageView,
               stack(usernameLabel,messageLabel,spacing :2),
               spacing :20,
            alignment : .center).padLeft(20).padRight(20)
        
        
        addSeparatorView(leadingAnchor: usernameLabel.leadingAnchor)
        
    }
}

class MatchesAndMessagesController : LBTAListHeaderController<RecentMessageCell,RecentMessage,MatchHeaderView>{
    
    //MARK: Properties

    let customNavBar  = MachNavView()
    

    override func setupHeader(_ header: MatchHeaderView) {
        
        header.horizontalViewController.rootMatchesViewController = self
    }
    
    func didSelectMatchForHeader(match : Match){
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        items  = [.red,.systemPink,.red,.systemPink,]
        
        collectionView.backgroundColor = .white
        collectionView.verticalScrollIndicatorInsets.top = 150
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor,
                            height: 150)
        collectionView.contentInset.top = 150
        let statusBarView = UIView(backgroundColor: .white)
        
        view.addSubview(statusBarView)
        statusBarView.anchor(top:view.topAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.topAnchor,right: view.rightAnchor)
        fetchRecentMessages()
//        fetchMatches()
    }
    
    //MARK: Selector
    @objc func handleBack(){
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helper Function
   
    
//    func fetchMatches(){
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//
//        Firestore.firestore().collection("matches_messages").document(uid).collection("matches").getDocuments { (snapshot, error) in
//            if let error = error{
//                print(error.localizedDescription)
//                return
//            }
//            var matches = [Match]()
//            snapshot?.documents.forEach({ (snapshot) in
//                let dict = snapshot.data()
//                let match = Match(dictionary: dict)
//                matches.append(match)
//            })
//
//            self.items = matches
//            self.collectionView.reloadData()
//
//        }
//    }
    var recentMessageDictionary = [String :RecentMessage]()
    var listener : ListenerRegistration?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent{
            listener?.remove()
        }
    }
    deinit {
        print("Deinit" )
    }
    func fetchRecentMessages(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
         listener = Firestore.firestore().collection("matches_messages").document(uid).collection("recent_messages").addSnapshotListener { (querySnapshot, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added || change.type == .modified{
                    let dict = change.document.data()
                    let recentMessage = RecentMessage(dictionary: dict)
                    self.recentMessageDictionary[recentMessage.uid] = recentMessage
//                    self.items.append(.init(dictionary: dict))
                }
            })
//            self.collectionView.reloadData()
            self.resetItems()
        }
    }
    
    func resetItems(){
        let  values = Array(recentMessageDictionary.values)
        items = values.sorted(by: { (rm1, rm2) -> Bool in
            return rm1.timestamp.compare(rm2.timestamp) == .orderedDescending
        })
        collectionView.reloadData()
    }
}

extension MatchesAndMessagesController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let recentMessage = self.items[indexPath.row]
        
        let dict = ["name":recentMessage.name,"uid": recentMessage.uid,"profileImageUrl":recentMessage.profileImageUrl]
        let match = Match(dictionary: dict)
//        match.profileImageUrl
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
