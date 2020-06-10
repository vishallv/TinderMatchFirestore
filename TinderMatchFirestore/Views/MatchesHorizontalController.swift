//
//  MatchesHorizontalController.swift
//  TinderMatchFirestore
//
//  Created by Vishal Lakshminarayanappa on 6/6/20.
//  Copyright © 2020 Vishal Lakshminarayanappa. All rights reserved.
//

import UIKit
import LBTATools
import Firebase

class MatchesHorizontalController : LBTAListController<MatchCell,Match>,UICollectionViewDelegateFlowLayout{
    
    weak var rootMatchesViewController : MatchesAndMessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMatches()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .horizontal
        }
    }
    func fetchMatches(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("matches_messages").document(uid).collection("matches").getDocuments { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            var matches = [Match]()
            snapshot?.documents.forEach({ (snapshot) in
                let dict = snapshot.data()
                let match = Match(dictionary: dict)
                matches.append(match)
            })
            
            self.items = matches
            self.collectionView.reloadData()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: view.frame.height)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
        rootMatchesViewController?.didSelectMatchForHeader(match : self.items[indexPath.row])
           
       }
    

}
