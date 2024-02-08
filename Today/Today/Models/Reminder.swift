//
//  Reminder.swift
//  Today
//
//  Created by 임윤휘 on 1/30/24.
//

import Foundation

struct Reminder: Identifiable {
    var id: String = UUID().uuidString // 개별의 Reminder 구분 목적 프로퍼티
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}


// #if DEBUG
// 코드
// #endif
// 샘플 Reminder 데이터 저장하기 위한 flag
// #if DEBUG는 컴파일러 지시문(compilation directive)으로, 릴리즈를 위해 앱을 빌드할 때 컴파일되지 않도록 막는다.
// 디버그 빌드 시 코드를 테스트하거나 샘플 테스트 데이터를 제공하기 위해 사용한다

#if DEBUG
extension Reminder {
    static var sampleData = [
        Reminder(
            title: "Submit reimbursement report", dueDate: Date().addingTimeInterval(800.0),
            notes: "Don't forget about taxi receipts"),
        Reminder(
            title: "Code review", dueDate: Date().addingTimeInterval(14000.0),
            notes: "Check tech specs in shared folder", isComplete: true),
        Reminder(
            title: "Pick up new contacts", dueDate: Date().addingTimeInterval(24000.0),
            notes: "Optometrist closes at 6:00PM"),
        Reminder(
            title: "Add notes to retrospective", dueDate: Date().addingTimeInterval(3200.0),
            notes: "Collaborate with project manager", isComplete: true),
        Reminder(
            title: "Interview new project manager candidate",
            dueDate: Date().addingTimeInterval(60000.0), notes: "Review portfolio"),
        Reminder(
            title: "Mock up onboarding experience", dueDate: Date().addingTimeInterval(72000.0),
            notes: "Think different"),
        Reminder(
            title: "Review usage analytics", dueDate: Date().addingTimeInterval(83000.0),
            notes: "Discuss trends with management"),
        Reminder(
            title: "Confirm group reservation", dueDate: Date().addingTimeInterval(92500.0),
            notes: "Ask about space heaters"),
        Reminder(
            title: "Add beta testers to TestFlight", dueDate: Date().addingTimeInterval(101000.0),
            notes: "v0.9 out on Friday")
    ]
}
#endif
