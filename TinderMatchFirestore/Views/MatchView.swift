//
//  MatchView.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/4/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import Firebase
class MatchView : UIView{
    
    //MARK: Properties
    var currentUser : User!{
        didSet{
            
        }
        
    }
    
    var cardUID : String!{
        didSet{
            Firestore.firestore().collection("users").document(cardUID).getDocument { (snapshot, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                guard let dictionary = snapshot?.data() else {return}
                let user = User(dictionary: dictionary)
                
                self.descriptionLAbel.text = "You and \(user.name ?? "") liked \neach other"
                guard let url = URL(string: user.imageUrl1 ?? "") else {return}
                //                self.matchUserImageView.alpha = 1
                
                self.views.forEach { (v) in
                    v.alpha = 1
                }
                self.matchUserImageView.sd_setImage(with: url)
                guard let currentUrl = URL(string: self.currentUser.imageUrl1 ?? "") else {return}
                self.currentUserImageView.sd_setImage(with: currentUrl) { (_, _, _, _) in
                    self.setupAnimations()
                }
                
                
            }
        }
    }
    
    
    let itISMatchView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let descriptionLAbel : UILabel = {
        let label = UILabel()
        label.text = "You and X liked \neach other"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let currentUserImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "jane1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let matchUserImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.alpha = 0
        return iv
    }()
    
    let sendMessageButton : UIButton = {
        let button = SendMessageButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let keepSwipingButton : UIButton = {
        let button = KeepSwipingButton(type: .system)
        button.setTitle("KEEP SWIPING", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        setupLayout()
        //        setupAnimations()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    @objc func handleTapDismiss(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 1
            
        }, completion: { _ in
            self.removeFromSuperview()
            
        })
        
    }
    
    let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    //MARK: Helper Function
    
    func setupAnimations(){
        let angle = CGFloat.convertDegreeToRadian(degree: 30)
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        matchUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        
        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.matchUserImageView.transform = CGAffineTransform(rotationAngle: angle)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.3) {
                self.currentUserImageView.transform = .identity
                self.matchUserImageView.transform = .identity
            }
            
        }) { (_) in
            
            
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.65, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        }, completion: nil)
        
        //        UIView.animate(withDuration: 0.5) {
        //            self.currentUserImageView.transform = .identity
        //            self.matchUserImageView.transform = .identity
        //        }
        
    }
    
    
    lazy var views = [itISMatchView,descriptionLAbel,currentUserImageView,matchUserImageView,sendMessageButton,keepSwipingButton]
    func setupLayout(){
        
        views.forEach { (v) in
            addSubview(v)
            v.alpha = 0
        }
        //        addSubview(itISMatchView)
        //        addSubview(descriptionLAbel)
        //        addSubview(currentUserImageView)
        //        addSubview(matchUserImageView)
        //        addSubview(sendMessageButton)
        //        addSubview(keepSwipingButton)
        
        currentUserImageView.anchor(right : centerXAnchor ,paddingRight: 16,width : 140,height: 140)
        currentUserImageView.centerY(inView: self)
        currentUserImageView.layer.cornerRadius = 140/2
        
        
        descriptionLAbel.anchor(top: nil, left: leftAnchor, bottom: currentUserImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 32, paddingRight: 0, height: 50)
        
        itISMatchView.anchor(top: nil, left: nil, bottom: descriptionLAbel.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 300, height: 80)
        itISMatchView.centerX(inView: self)
        
        matchUserImageView.anchor(left : centerXAnchor ,paddingLeft: 16,width : 140,height: 140)
        matchUserImageView.centerY(inView: self)
        matchUserImageView.layer.cornerRadius = 140/2
        
        sendMessageButton.anchor(top : currentUserImageView.bottomAnchor, left: leftAnchor,right: rightAnchor,
                                 paddingTop: 32,paddingLeft: 48,paddingRight: 48,height: 50)
        keepSwipingButton.anchor(top : sendMessageButton.bottomAnchor, left: leftAnchor,right: rightAnchor,
                                 paddingTop: 16,paddingLeft: 48,paddingRight: 48,height: 50)
    }
    
    func setupBlurView(){
        
        visualEffect.alpha = 0
        addSubview(visualEffect)
        visualEffect.addConstraintsToFillView(self)
        visualEffect.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffect.alpha = 1
        }, completion: nil)
        
    }
}
