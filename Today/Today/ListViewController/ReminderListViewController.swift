//
//  ReminderListViewController.swift
//  Today
//
//  Created by 임윤휘 on 1/30/24.
//

// UIKit 앱에서 view controller는 맡은 일이 많기 때문에 VC의 파일의 크기는 커질 수 있다.
// VC의 책임을 별개의 파일 및 extension으로 재조직하면 오류 발견과 새 기능 추가를 쉽게 만들 수 있단.

import UIKit

class ReminderListViewController: UICollectionViewController {
    var dataSource: DataSource!
    var reminders: [Reminder] = Reminder.sampleData

    // viewController가 자신의 view 계층을 메모리에 로드한 후 시스템은 ViewDiddLoad를 호출한다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        // ReminderListVC에서 모든 data source 동작을 발췌여 더 조직화된 Swift 파일들을 갖게 된다.
        // view controller의 동작들은 한 파일에 있고, data source의 동작들은 다른 파일에 있다
        let cellRegisteration = UICollectionView.CellRegistration(handler: cellRegisterationHandler)
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { 
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
        })
        
        updateSnapshot()
        
        collectionView.dataSource = dataSource
    }
    
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
}
