//
//  ViewController.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 5/28/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import LBTATools

class HomeController: UIViewController {
    
    //MARK:- Properties
    let topStackView = TopNavigationStackView()
    let bottomControls = HomeBottomControlsStackView()
    let cardDeckView = UIView()
    var user : User?
    
    //    var cardViewModels : [CardViewModel] = {
    //
    //        let producers = [
    //            User(name: "Kelly", age: 23, profession: "DJ", imageNames: ["kelly1","kelly2","kelly3"]),
    //        Advertiser(title: "Slide out menu", brandName: "Lets buid that app", posterPhotoName: "slide_out_menu_poster"),
    //        User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1","jane2","jane3"])
    //            ] as [ProduceCardViewModel]
    //
    //        let viewModels  = producers.map({ return $0.toCardViewModel()})
    //        return viewModels
    //    }()
    
    
    var cardViewModels = [CardViewModel](){
        didSet{
            
            
        }
    }
    
    //MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        topStackView.settingButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        setupLayout()
        topStackView.messageButton.addTarget(self, action: #selector(handleMessages), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDisLike), for: .touchUpInside)
        
        //        setupFirestoreUserCard()
        //        fetchUserFromFireStore()
        
        fetchCurrentUser()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser?.uid == nil{
            
            let loginController = LoginController()
            loginController.delegate = self
            let navController = UINavigationController(rootViewController: loginController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        }
    }
    
    //MARK:- Selector
    
    @objc func handleMessages(){
        let vc = MatchesAndMessagesController()
        vc.view.backgroundColor = .red
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleRefresh(){
        cardDeckView.subviews.forEach({$0.removeFromSuperview()})
        fetchUserFromFireStore()
    }
    
    @objc func handleSettings(){
        
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    //MARK:- Helper Function
    
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
            //            print(user)
            
            
            self.fetchMySwipes()
            //            self.fetchUserFromFireStore()
        }
    }
    
    var swipes = [String:Int]()
    
    fileprivate func fetchMySwipes(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let data = snapshot?.data() as? [String:Int] else {return}
            
            self.swipes = data
            self.fetchUserFromFireStore()
        }
    }
    
    var lastFetchedUser : User?
    let hud = JGProgressHUD(style: .dark)
    fileprivate func fetchUserFromFireStore(){
        //        guard let minAge = user?.minSeekingAge,let maxAge = user?.maxSeekingAge else {
        //            hud.dismiss()
        //            return}
        
        let minAge = user?.minSeekingAge ?? 18
        let maxAge = user?.maxSeekingAge ?? 50
        
        hud.textLabel.text = "Fetching User"
        hud.show(in: self.view)
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge).limit(to: 1)
        //            .order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        self.topCardView = nil
        query.getDocuments { (snapshot, error) in
            self.hud.dismiss()
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            var previousCardView : CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.users[user.uid ?? ""] = user
                
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                //                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                
                let hasNotSwipedBefore = true
                if isNotCurrentUser && hasNotSwipedBefore{
                    let cardview = self.setupCardWithUser(user: user)
                    
                    
                    previousCardView?.nextCardView = cardview
                    previousCardView = cardview
                    if self.topCardView == nil{
                        self.topCardView = cardview
                    }
                }
                
            })
            //            self.setupFirestoreUserCard()
        }
    }
    
    var users = [String:User]()
    var topCardView : CardView?
    
    @objc func handleDisLike(){
        saveSwipeToFireStore(swipeValue: 0)
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    @objc func handleLike(){
        
        saveSwipeToFireStore(swipeValue: 1)
        performSwipeAnimation(translation: 700, angle: 15)
        
        
        
        //        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
        //            self.topCardView?.frame = CGRect(x: 1000 , y: 0, width: self.topCardView!.frame.width, height: self.topCardView!.frame.height)
        //            let angle = CGFloat.convertDegreeToRadian(degree: 15)
        //            self.topCardView?.transform = CGAffineTransform(rotationAngle: angle)
        //        }) { (_) in
        //            self.topCardView?.removeFromSuperview()
        //            self.topCardView = self.topCardView?.nextCardView
        //        }
        
    }
    
    fileprivate func saveSwipeToFireStore(swipeValue : Int){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let cardUID = topCardView?.cardViewModel.uid else {return}
        let documentData = [cardUID : swipeValue]
        
        
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            if snapshot?.exists == true{
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }
                    
                    print("Success Updated swipe")
                    if swipeValue == 1{
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                    
                    //                    self.checkIfMatchExists(cardUID: cardUID)
                }
                
            }
            else{
                
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }
                    
                    print("Success storing swipe")
                    if swipeValue == 1{
                        self.checkIfMatchExists(cardUID: cardUID)
                    }
                    //                    self.checkIfMatchExists(cardUID: cardUID)
                }
            }
        }
        
    }
    
    fileprivate func checkIfMatchExists(cardUID: String){
        
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let data = snapshot?.data() else {return}
            guard let uid = Auth.auth().currentUser?.uid else{return}
            
            let hasMatched  = data[uid] as? Int == 1
            
            if hasMatched{
                
                self.presentMatchView(cardUID: cardUID)
                
                guard let cardUser = self.users[cardUID] else {return}
                
                let data = ["name":cardUser.name ?? "", "profileImageUrl": cardUser.imageUrl1 ?? "","uid":cardUID,"timeStamp":Timestamp(date: Date())] as [String : Any]
                Firestore.firestore().collection("matches_messages").document(uid).collection("matches").document(cardUID).setData(data) { (error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }
                }
                
                
                guard let currentUser = self.user else {return}
                
                let cdata = ["name":currentUser.name ?? "", "profileImageUrl": currentUser.imageUrl1 ?? "","uid":uid,"timeStamp":Timestamp(date: Date())] as [String : Any]
                Firestore.firestore().collection("matches_messages").document(cardUID).collection("matches").document(uid).setData(cdata) { (error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }
                }
            }
            
        }
        
        
    }
    
    fileprivate func presentMatchView(cardUID : String){
        
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = self.user
        view.addSubview(matchView)
        matchView.addConstraintsToFillView(self.view)
    }
    
    
    fileprivate func performSwipeAnimation(translation : CGFloat, angle : CGFloat){
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = 0.5
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat.convertDegreeToRadian(degree: angle)
        rotationAnimation.duration = 0.5
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
            
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    
    func setupCardWithUser(user : User) -> CardView{
        let cardView = CardView()
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        //        cardDeckView.
        cardDeckView.sendSubviewToBack(cardView)
        cardView.addConstraintsToFillView(cardDeckView)
        return cardView
    }
    
    //    func setupFirestoreUserCard(){
    //
    //        cardViewModels.forEach { (cardModel) in
    //            let cardView = CardView()
    //            cardView.cardViewModel = cardModel
    //            cardDeckView.addSubview(cardView)
    //            cardDeckView.sendSubviewToBack(cardView)
    //            cardView.addConstraintsToFillView(cardDeckView)
    //
    //        }
    //
    //    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let overAllStackView = UIStackView(arrangedSubviews: [topStackView, cardDeckView, bottomControls])
        overAllStackView.axis = .vertical
        view.addSubview(overAllStackView)
        overAllStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
        overAllStackView.isLayoutMarginsRelativeArrangement = true
        overAllStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overAllStackView.bringSubviewToFront(cardDeckView)
    }
}

extension HomeController : SettingsControllerDelegate{
    func didSaveSetting() {
        fetchCurrentUser()
    }
    
}

extension HomeController : LoginControllerDelegate{
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    
}

extension HomeController : CardViewDelegate{
    func didRemoveCard(carView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    func didTapForMoreInfo(cardViewModel: CardViewModel) {
        let userDetailController = UserDetailController()
        userDetailController.cardViewModel = cardViewModel
        userDetailController.modalPresentationStyle = .fullScreen
        present(userDetailController, animated: true, completion: nil)
    }
    
}
