//
//  CardView.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 5/28/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate : class {
    func didTapForMoreInfo(cardViewModel : CardViewModel)
    func didRemoveCard(carView : CardView)
}

class CardView: UIView {
    
    //MARK: Properties
    var nextCardView : CardView?
    
    var cardViewModel : CardViewModel!{
        didSet{
            configure()
        }
    }
    
    let gradientLayer = CAGradientLayer()
    
    weak var delegate : CardViewDelegate?
    
//    private var imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    fileprivate let swipeController = SwipePhotoControllerViewController(isCarViewMode: true)
    
    private let informationLabel = UILabel()
    private let barStackView = UIStackView()
    fileprivate let barDeselectedColor = UIColor.init(white: 0, alpha: 0.1)
    
    fileprivate let  moreInfoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    // CONFIGURATIONS
    fileprivate let threshold : CGFloat = 100
    
    //MARK: Life Cycle
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    
    @objc func handleMoreInfo(){
        delegate?.didTapForMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    @objc fileprivate func handleTap(gesture : UITapGestureRecognizer){
        let tapLocation = gesture.location(in: nil)
        let shouldAdvance = tapLocation.x > frame.width/2 ? true : false
        
        if shouldAdvance{
            print("Front")
            cardViewModel.advanceToNextPhoto()
        }else{
            
            cardViewModel.goToPreviousPhoto()
        }
  
    }
    
    @objc func handlePan(gesture : UIPanGestureRecognizer){
        switch gesture.state{
        case .began:
            
            superview?.subviews.forEach({ (view) in
                view.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
            
        default:
            ()
        }
    }
    
    //MARK: Helper Function
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        let swipingView = swipeController.view!
        
//        imageView.contentMode = .scaleAspectFill
        addSubview(swipingView)
        swipingView.addConstraintsToFillView(self)
        
//        setupBarStackView()
        setupGradientLayer()
        
        
        addSubview(informationLabel)
        informationLabel.anchor(left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,
                                paddingLeft: 16,paddingBottom: 16,paddingRight: 16)
        informationLabel.numberOfLines = 0
        informationLabel.textColor = .white
        addSubview(moreInfoButton)
        moreInfoButton.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 16,paddingRight: 16,
                                width: 44,height: 44)
//        moreInfoButton.layer.cornerRadius = 44/2
    }
    
    fileprivate func setupBarStackView(){
        
        
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 5)
        
    }
    
    fileprivate func setupGradientLayer(){
        
        
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1.1]
        
        gradientLayer.frame = self.frame
        layer.addSublayer(gradientLayer)
        
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        
        let translate = gesture.translation(in: nil)
        //Convert degree to radian
        let angle =  CGFloat.convertDegreeToRadian(degree: translate.x/20)
        
        let rotationTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTransformation.translatedBy(x: translate.x, y: translate.y)
        
        
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        
        
        guard let homeController = self.delegate as? HomeController else {return}
        
        if shouldDismissCard{
            
            if translationDirection == 1{
                homeController.handleLike()
            }
            else{
                homeController.handleDisLike()
            }
        }
        else{
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity
            }, completion: nil)
        }
        
        
        
        
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
//            if shouldDismissCard{
//
//                self.layer.frame = CGRect(x: 1000 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
//
//            }else{
//
//                self.transform = .identity
//            }
//        }) { (_) in
//
//            UIView.animate(withDuration: 1) {
//                self.transform = .identity
//                if shouldDismissCard{
//                    self.removeFromSuperview()
//                    self.delegate?.didRemoveCard(carView: self)
//                }
//                //                self.frame = CGRect(x: 0, y: 0, width: self.superview!.frame.width, height: self.superview!.frame.height)
//            }
//        }
    }
    
}

extension CardView{
    
    func configure(){
//        let imageName = cardViewModel.imageUrls.first ?? ""
//        if let url = URL(string: imageName){
//         self.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_placeholder").withRenderingMode(.alwaysOriginal), options: .continueInBackground, context: nil)
//        }
        
        swipeController.carViewModel = self.cardViewModel
        informationLabel.attributedText = cardViewModel.attributedText
        informationLabel.textAlignment = cardViewModel.textAlignment
        
        (0..<cardViewModel.imageUrls.count).forEach { (_) in
            let view = UIView()
            view.backgroundColor = barDeselectedColor
            barStackView.addArrangedSubview(view)
        }
        
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        
        setupImageIndexObserver()
    }
    
    func setupImageIndexObserver(){
        cardViewModel.imageIndexObserver = { [unowned self] imageIndex,imageUrl in
//            if let url = URL(string: imageUrl ?? ""){
//                self.imageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "photo_placeholder").withRenderingMode(.alwaysOriginal), options: .continueInBackground, context: nil)
//            }

            self.barStackView.arrangedSubviews.forEach { (view) in
                view.backgroundColor = self.barDeselectedColor
            }
            self.barStackView.arrangedSubviews[imageIndex].backgroundColor = .white
        }
    }
}

