//
//  SwipePhotoControllerViewController.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/3/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit

class SwipePhotoControllerViewController: UIPageViewController {
    //MARK: Properties
    
    var carViewModel : CardViewModel!{
        
        didSet{
            controller = carViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                
                return PhotoController(imageUrl: imageUrl)
            })
            
            
            setViewControllers([controller.first!], direction: .forward, animated: true, completion: nil)
            
            setupBarViews()
        }
    }
    
    var controller : [UIViewController] = []
    
    let isCardView  : Bool

    
    //MARK: Life Cycle
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        dataSource = self
        delegate = self
        
        if isCardView{
            disableSwipeAbility()
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
  
    init(isCarViewMode : Bool = false) {
        self.isCardView = isCarViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Selector
    @objc func handleTap(gesture : UITapGestureRecognizer){

        
        let currentController = viewControllers!.first!

        if let index = controller.firstIndex(of: currentController){
             barStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedColor})
            if gesture.location(in: view).x > view.frame.width/2{
                let nextIndex = min(controller.count-1, index + 1)
                let nextController = controller[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: false, completion: nil)
                barStackView.arrangedSubviews[nextIndex].backgroundColor = .white
            }
            else{
                let nextIndex = max(0, index - 1)
                let nextController = controller[nextIndex]
                setViewControllers([nextController], direction: .reverse, animated: false, completion: nil)
                barStackView.arrangedSubviews[nextIndex].backgroundColor = .white
            }

            
        }
    }
    
    //MARK: Helper Function
    
    func disableSwipeAbility(){
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView{
                v.isScrollEnabled = false
            }
        }
        
    }
    
    let barStackView = UIStackView(arrangedSubviews: [])
    let deselectedColor = UIColor(white: 0, alpha: 0.1)
    
    func  setupBarViews(){
        
        carViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deselectedColor
            barView.layer.cornerRadius = 2
            barStackView.addArrangedSubview(barView)
        }
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        barStackView.spacing = 8
        barStackView.distribution = .fillEqually
        view.addSubview(barStackView)
        
        var paddingTop : CGFloat = 8
        if !isCardView{
             paddingTop += (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        }
        
//        let paddingTop = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0 + 8
        
        barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                            paddingTop: paddingTop,paddingLeft: 8,paddingRight: 8,height: 4)
        
    }
}

extension SwipePhotoControllerViewController : UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controller.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 {return nil}
        return self.controller[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = self.controller.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controller.count - 1 {return nil}

        return self.controller[index + 1]
    }
    
    
}


class PhotoController : UIViewController{
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "jane1"))
    
    init(imageUrl : String) {
        if let url = URL(string: imageUrl){
            imageView.sd_setImage(with: url, completed: nil)
        }

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.addConstraintsToFillView(view)
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}

extension SwipePhotoControllerViewController : UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let currentController = viewControllers?.first
        if let index = controller.firstIndex(where: {$0 == currentController}){
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedColor})
            barStackView.arrangedSubviews[index].backgroundColor = .white
        }
        
        
        
    }
}
