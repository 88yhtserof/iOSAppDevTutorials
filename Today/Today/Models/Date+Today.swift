//
//  Date+Today.swift
//  Today
//
//  Created by 임윤휘 on 2/1/24.
//

import Foundation
// Model은 비지니스 로직은 포함하는 부분이기 때문에 Date를 확장한 해당 파일도 Model에 속한다
extension Date {
    var datAndTimeText: String {
        // Local-aware format, 지역 기준 형식
        var timeText = formatted(date: .omitted, time: .shortened)
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        } else {
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        } else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
}
