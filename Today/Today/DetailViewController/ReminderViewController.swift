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
    
    var reminder: Reminder {
        didSet {
            // reminder가 변경될 때마다 view controller는 인지하고 변경사항에 대해 반응한다
            onChange(reminder)
        }
    }
    var workingReminder: Reminder // 사용자가 수정사항을 저장 또는 폐기(discard)하기 전까지 수정사항을 임시저장하는 프로퍼티
    var onChange: (Reminder) -> Void
    private var dataSource: DataSource!
    
    init(reminder: Reminder, onChange: @escaping (Reminder) -> Void) {
        self.reminder = reminder
        self.workingReminder = reminder
        self.onChange = onChange
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
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
            prepareForEditing()
        } else {
            prepareForViewing()
        }
    }
    
    /// cell과 indexPath row를 받아 collectionview에 cell 등록
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
        case (_, .header(let title)):
            // 첫 번째 행을 헤더로 지정했으므로 cell이 필요. row가 header에 해당하는 경우 cell의 기본 구성에 텍스트를 지정하여 구성을 마무리한다
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
        case (.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
        case (.title, .editableText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title)
        case (.date, .editableDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        case (.notes, .editableText(let notes)):
            cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
        default:
            fatalError("Unexpected combination of section and row")
        }
        cell.tintColor = .todayPrimaryTint
    }
    
    @objc func didCancelEdit() {
        // 편집을 수정했으므로 임시 working reminder를 원래 상태로 초기화
        workingReminder = reminder
        setEditing(false, animated: true)
    }
    
    private func prepareForEditing() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
        updateSnapshotForEditing()
    }
    
    private func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, . notes])
        snapshot.appendItems([.header(Section.title.name), .editableText(reminder.title)], toSection: .title)
        snapshot.appendItems([.header(Section.date.name), .editableDate(reminder.dueDate)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name), .editableText(reminder.notes)], toSection: .notes)
        dataSource.apply(snapshot)
    }
    
    private func prepareForViewing() {
        navigationItem.leftBarButtonItem = nil
        if workingReminder != reminder { // 변경사항이 있을 경우 반영
            reminder = workingReminder
        }
        updateSnapshotForViewing()
    }
    
    private func updateSnapshotForViewing() {
        var snapShot = Snapshot()
        snapShot.appendSections([.view])
        snapShot.appendItems([Row.header(""), Row.title, Row.date, Row.time, Row.notes], toSection: .view)
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
