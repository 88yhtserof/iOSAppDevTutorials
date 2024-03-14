//
//  ReminderViewController+Row.swift
//  Today
//
//  Created by 임윤휘 on 3/7/24.
//

import UIKit

extension ReminderViewController {
    // diffable data source는 snapshot 간 어떤 element가 변경되었는지 결정하기 위해 hash 값을 사용한다.
    // 이를 위해 열거형을 hashable하게 만든다.
    // 열거형을 추가하는 것은 각 행을 간단 명료하게 이미지화하며, 이는 view controller가 각 행에 적절한 텍스트를 제공하도록 돕는다.
    enum Row: Hashable {
        case header(String)
        case date
        case notes
        case time
        case title
        case editableText(String)
        
        var imageName: String? {
            switch self {
            case .date: return "calender.circle"
            case .notes: return "square.and.pencil"
            case .time: return "clock"
            default: return nil
            }
        }
        
        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        var textStyle: UIFont.TextStyle {
            switch self {
            case .title: return .headline
            default: return .subheadline
            }
        }
    }
}
