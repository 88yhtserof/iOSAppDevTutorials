//
//  ReminderViewController.swift
//  Today
//
//  Created by 임윤휘 on 3/7/24.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    var reminder: Reminder
    
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
