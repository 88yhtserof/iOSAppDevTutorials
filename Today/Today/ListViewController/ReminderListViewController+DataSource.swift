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
    
    /// cell의 타입을 등록하는 메서드
    func cellRegisterationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminders[indexPath.item]
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguaration(for: reminder)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
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
    
    /// list 내 완료 버튼의 configuration을 반환하는 메서드
    private func doneButtonConfiguaration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = UIButton()
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
}
