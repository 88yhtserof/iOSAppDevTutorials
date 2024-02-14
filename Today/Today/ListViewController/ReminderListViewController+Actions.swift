//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by 임윤휘 on 2/14/24.
//

import UIKit

extension ReminderListViewController {
    /// 버튼 클릭 시 호출될 함수
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(withId: id)
    }
}
