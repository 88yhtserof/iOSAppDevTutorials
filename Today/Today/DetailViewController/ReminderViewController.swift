//
//  ReminderViewController.swift
//  Today
//
//  Created by 임윤휘 on 3/7/24.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    // DataSource는 제너릭 타입이다.
    // 제너릭 파라미터로 Int와 Row를 지정했으므로 DataSource가 section number로 Int를, list의 row로 Row 타입을 사용함을 컴파일러에게 알려줄 수 있다.
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Row>
    
    var reminder: Reminder
    private var dataSource: DataSource!
    
    init(reminder: Reminder) {
        self.reminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    // code-based로 reminder view controller를 생성했기 때문에 아래 이니셜라이저는 사용되지 않는다
    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        // view controller의 life cycle을 오버라이드할 때, 사용자 지정 작업을 수행하기 전에 부모 클래스의 작업이 우선 시행되어야 한다.
        super.viewDidLoad()
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    /// cell과 indexPath row를 받아 collectionview에 cell 등록
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        var contentConfiguaration = cell.defaultContentConfiguration()
        contentConfiguaration.text = text(for: row)
        contentConfiguaration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguaration.image = row.image
        cell.contentConfiguration = contentConfiguaration
        cell.tintColor = .todayPrimaryTint
    }
    
    // 주어진 행과 관련한 텍스트를 반환하는 함수
    // if문 대신 열거형을 사용하여 각 case를 구분한다면, 각 행 수정이 쉬워지고 이후 reminder의 상세를 더 추가할 수 있어 확장적이다
    func text(for row: Row) -> String? {
        switch row {
        case .date: return reminder.dueDate.dayText
        case .notes: return reminder.notes
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title: return reminder.title
        }
    }
}
