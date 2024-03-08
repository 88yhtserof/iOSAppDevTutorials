//
//  ReminderViewController.swift
//  Today
//
//  Created by 임윤휘 on 3/7/24.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    // DataSource과 SnapShot은 제너릭 타입이다.
    // 제너릭 파라미터로 Int와 Row를 지정했으므로 DataSource 또는 SnapShot이 section number로 Int를, list의 row로 Row 타입을 사용함을 컴파일러에게 알려줄 수 있다.
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
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
        
        // iOS 16 이후부터는 navigationBar의 동작과 content 밀집도를 커스텀할 수 있다
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder view controller title")
        navigationItem.rightBarButtonItem = editButtonItem
        
        // view controller가 로드하는 첫 순간에 data snapshot이 목록에 반영된다.
        // 이후 reminder detail 아이템을 수정할 때, 사용자 인토페이스를 업데이트하기 위해 또다른 snapshot을 적용해야한다.
        // 왜냐하면 snapshot은 사용자가 만든 모든 변화를 반영하기 때문이다.
        updateSnapshotForViewing()
    }
    
    // 사용자가 Edit 또는 Done 버튼을 누르면 호출되는 setEditing 메서드를 오버라이드
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            updateSnapshotForEditing()
        } else {
            updateSnapshotForViewing()
        }
    }
    
    /// cell과 indexPath row를 받아 collectionview에 cell 등록
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case (.view, _):
            var contentConfiguaration = cell.defaultContentConfiguration()
            contentConfiguaration.text = text(for: row)
            contentConfiguaration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
            contentConfiguaration.image = row.image
            cell.contentConfiguration = contentConfiguaration
        default:
            fatalError("Unexpected combination of section and row")
        }
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
    
    private func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, . notes])
    }
    
    private func updateSnapshotForViewing() {
        var snapShot = Snapshot()
        snapShot.appendSections([.view])
        snapShot.appendItems([Row.title, Row.date, Row.time, Row.notes], toSection: .view)
        // snapshot을 datasource에 적용하는 것은 snapshot의 데이터와 스타일을 반영한 사용자 인터페이스를 업데이트시킨다.
        dataSource.apply(snapShot)
    }
    
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
}
