//
//  CollectionUsers.swift
//  RoomExpence
//
//  Created by MQF-6 on 29/02/24.
//

import UIKit

class CollectionUsers: UICollectionView {
    
    var arrUsers = [UserModel]()
    
    @Published var didSelectItem: UserModel?
 
    override func awakeFromNib() {
        super.awakeFromNib()
        initialization()
    }
    
    func initialization() {
        self.delegate = self
        self.dataSource = self
    }
}

extension CollectionUsers: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsersCell", for: indexPath) as? UsersCell else {
            return UICollectionViewCell()
        }
        let user = arrUsers[indexPath.item]
        cell.configureCell(user: user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        arrUsers = arrUsers.map { user in
            var u = user
            u.isSelected = false
            return u
        }
        arrUsers[indexPath.item].isSelected = true
        didSelectItem = arrUsers[indexPath.item]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
