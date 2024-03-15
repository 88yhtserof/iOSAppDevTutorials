//
//  ReminderViewController+CellConfiguration.swift
//  Today
//
//  Created by 임윤휘 on 3/12/24.
//

import UIKit

extension ReminderViewController {
    // view 모드에 적용할 configuration 반환
    // 기존 list view의 외관 설정을 추출하여 구성
    /// cell 과 row를 받아 cotentConfiguration 반환
    func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row) -> UIListContentConfiguration {
        var contentConfiguaration = cell.defaultContentConfiguration()
        contentConfiguaration.text = text(for: row)
        contentConfiguaration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguaration.image = row.image
        return contentConfiguaration
    }
    
    /// title과 함께 해더로 설정할 cell을 받아 configuration을 반환한다
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        return contentConfiguration
    }
    
    func titleConfiguration(for cell: UICollectionViewListCell, with title: String?) ->TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = title
        contentConfiguration.onChange = { [weak self] title in
            self?.workingReminder.title = title
        }
        return contentConfiguration
    }
    
    func dateConfiguration(for cell: UICollectionViewListCell, with date: Date) -> DatePickerContentView.Configuration {
        var contentConfiguration = DatePickerContentView.Configuration()
        contentConfiguration.date = date
        contentConfiguration.onChange = { [weak self] dueDate in
            self?.workingReminder.dueDate = dueDate
        }
        return contentConfiguration
    }
    
    func notesConfiguration(for cell: UICollectionViewListCell, with notes: String?) -> TextViewContentView.Configuration {
        var contentConfiguration = TextViewContentView.Configuration()
        contentConfiguration.text = notes
        contentConfiguration.onChange = { [weak self] notes in
            self?.workingReminder.notes = notes
        }
        return contentConfiguration
    }
    
    // 이 함수는 각 row 타입에 대한 적절한 text를 생성하기 때문에 cell confoguration 확장 swift 파일에 두는 것이 후에 해당 함수를 찾거나 수정할 때 용이할 것이다.
    // 주어진 행과 관련한 텍스트를 반환하는 함수
    // if문 대신 열거형을 사용하여 각 case를 구분한다면, 각 행 수정이 쉬워지고 이후 reminder의 상세를 더 추가할 수 있어 확장적이다
    func text(for row: Row) -> String? {
        switch row {
        case .date: return reminder.dueDate.dayText
        case .notes: return reminder.notes
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title: return reminder.title
        default: return nil
        }
    }
}
