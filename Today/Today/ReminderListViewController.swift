//
//  ReminderListViewController.swift
//  Today
//
//  Created by 임윤휘 on 1/30/24.
//

import UIKit

class ReminderListViewController: UICollectionViewController {

    // viewController가 자신의 view 계층을 메모리에 로드한 후 시스템은 ViewDiddLoad를 호출한다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}

