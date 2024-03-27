//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by 임윤휘 on 2/6/24.
//

import UIKit

// Collection view data source들은 collection view에서 데이터를 관리한다.
// 더해 collection view의 리스트에서 아이템을 표시할 셀을 생성하고 구성한다.

// ReminderListViewController가 reminder 리스트의 data source로 역할할 모든 동작들을 모아놓은 extension
// ReminderListVC에서 모든 data source 동작을 발췌여 더 조직화된 Swift 파일들을 갖게 된다.
// view controller의 동작들은 한 파일에 있고, data source의 동작들은 다른 파일에 있다

extension ReminderListViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    var reminderCompletedValue: String {
        NSLocalizedString("Completed", comment: "Reminder completed value")
    }
    var reminderNotCompletedValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not completed vlaue")
    }
    
    // diffable data source를 사용할 때에는 데이터가 변경될 때 사용자 인터페이스를 업데이트하기 위해선 새로운 snapshot을 적용해야 한다.
    /// diffable data source에 snapshot을 적용시키는 메서드
    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        // 빈 array를 기본값으로 설정하여 viewDidLoad에서 인수 전달 없이 호출할 수 있도록 한다
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map { $0.id })
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
    }
    
    
    /// cell의 타입을 등록하는 메서드
    func cellRegisterationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(withId: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguaration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(for: reminder)]
        cell.accessibilityValue = reminder.isComplete ? reminderCompletedValue : reminderNotCompletedValue
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration),
            .disclosureIndicator(displayed: .always)
        ]
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
        // 제공받은 백그라운드 컬러 에셋을 사용하더라도 기본 백스라운 컬러를 변경시키지 못한다.
        // 이후 이를 고치는 튜토리얼을 진행한다.
    }
    
    // Create function for accessing the model
    // 직접적으로 reminders에 접근하는 것보다 아래 메서드를 사용하는 것이 잠재적인 에러를 감소시키고 코드를 간결하게 유지할 수 있게 한다
    /// reminder 식별자에 접근하여 일cl하는 reminder를 해당 reminder array에서 반환하는 메서드
    func reminder(withId id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(withId: id)
        return reminders[index]
    }
    
    /// reminder 식별자에 접근하여 일치하는 reminder를 찾아 업데이트하는 메서드
    func updateReminder(_ reminder: Reminder) {
        let index = reminders.indexOfReminder(withId: reminder.id)
        reminders[index] = reminder
    }
    
    /// Reminder.ID에 접근하여 상태를 변경하는 메서드
    func completeReminder(withId id: Reminder.ID) {
        // fetch the reminder
        var reminder = reminder(withId: id)
        reminder.isComplete.toggle()
        updateReminder(reminder)
        updateSnapshot(reloading: [id])
    }
    
    // 사용자가 Done 버튼을 누를 때 호출되어 새 reminder를 저장한다.
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
    }
    
    // doneButton에 적용할 커스텀 accessibilityAction을 생성하는 메서드
    // 각 cell에 대해 하나씩 accessibilityAction을 생성할 계획이다
    private func doneButtonAccessibilityAction(for reminder: Reminder) -> UIAccessibilityCustomAction {
        //VoiceOver은 액션이 이용 가능할 때 사용자에게 이를 알린다.
        // 사용자가 그 옵션들을 듣기로 결정하면, VoiceOver은 각 앤션의 이름들을 읽는다.
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        let action = UIAccessibilityCustomAction(name: name, actionHandler: { [weak self] action in
            // 클로저는 기본적으로 클로저 내부에서 사용할 외부 값에 대해 강한 참조를 생성한다.
            // 내부에서 사용할 view controller에 약한 참조를 지정하여 순환 참조를 방지하라.
            self?.completeReminder(withId: reminder.id)
            return true
        })
        return action
    }
    
    /// list 내 완료 버튼의 configuration을 반환하는 메서드
    private func doneButtonConfiguaration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.id = reminder.id
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
}
