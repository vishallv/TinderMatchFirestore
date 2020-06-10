//
//  UserDetailController.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/3/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class UserDetailController : UIViewController{
    
    //MARK: Properties
    var cardViewModel : CardViewModel!{
        didSet{
            //            print(cardViewModel.attributedText)
            infoLabel.attributedText = cardViewModel.attributedText
            swipeController.carViewModel = cardViewModel
        }
    }
    
    lazy var scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
//    let imageView : UIImageView = {
//        let iv = UIImageView()
//        iv.image  = #imageLiteral(resourceName: "kelly2")
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        return iv
//    }()
    
    let swipeController = SwipePhotoControllerViewController()
    
    
    let infoLabel : UILabel = {
        let label = UILabel()
        label.text = "User name 30\nCook\nbio text here"
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    func createButton(image : UIImage , selector : Selector) -> UIButton{
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    lazy var disLikeButton = self.createButton(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDislike))
    lazy var superLikeButton = self.createButton(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleDislike))
    lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleDislike))
    
    //MARK: Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupVisualBlurEffectView()
        setupBottomControl()
        
    }
    fileprivate let extraHeight : CGFloat = 80
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let imageView = swipeController.view!
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraHeight)
    }
    
    //MARK: Selector
    
    @objc func handleDislike(){
        
    }
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helper Function
    
    func setupBottomControl(){
        
        let stackView = UIStackView(arrangedSubviews: [disLikeButton, superLikeButton, likeButton])
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.spacing = -16
        stackView.anchor(bottom : view.safeAreaLayoutGuide.bottomAnchor,width: 300,height: 80)
        stackView.centerX(inView: self.view)
    }
    
    func setupVisualBlurEffectView(){
        let blurEffect = UIBlurEffect(style: .regular)
        
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor,left: view.leftAnchor,bottom: view.safeAreaLayoutGuide.topAnchor,right: view.rightAnchor)
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addConstraintsToFillView(view)
        
        
        let swipingView = swipeController.view!
        scrollView.addSubview(swipingView)
        
//        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: swipingView.bottomAnchor,left : scrollView.leftAnchor,right: scrollView.rightAnchor,
                         paddingTop: 16,paddingLeft: 16,paddingRight: 16)
        
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: swipingView.bottomAnchor,right: view.rightAnchor,paddingTop: -25,paddingRight: 24, width: 50,height: 50)
    }
}

extension UserDetailController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = -scrollView.contentOffset.y
        
        var width = view.frame.width + contentOffset * 2
        width = max(width, view.frame.width)
        let imageView = swipeController.view!
        imageView.frame = CGRect(x: min(0,-contentOffset), y: min(0,-contentOffset), width: width, height: width + extraHeight)
    }
}
