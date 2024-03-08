//
//  ReminderViewController+Section.swift
//  Today
//
//  Created by 임윤휘 on 3/8/24.
//

import Foundation

extension ReminderViewController {
    // data source는 데이터의 변경사항을 결정할 때 해시 값을 사용한다
    // view 모드는 사용자에게 reminder detail을 보여줄 때 사용하는 section
    // 나머지 세 개의 section은 edit 모드에서 사용한다.
    enum Section: Int, Hashable {
        case view
        case title
        case date
        case notes
        
        var name: String {
            switch self {
            case .view: return ""
            case .title:
                return NSLocalizedString("Title", comment: "Title section name")
            case .date:
                return NSLocalizedString("Date", comment: "Date section name")
            case .notes:
                return NSLocalizedString("Notes", comment: "Notes section name")
            }
        }

    }
}
