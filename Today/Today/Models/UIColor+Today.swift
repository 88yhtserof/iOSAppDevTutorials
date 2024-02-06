//
//  UIColor+Today.swift
//  Today
//
//  Created by 임윤휘 on 2/6/24.
//

// Model은 데이터와 비지니스 로직의 역할을 수행한다
// 이 UIColor의 extension은 view에 사용자 지정 색상을 사용하기 위한 코드가 담겨 있으므로 비지니스 로직으로 취급되어 Model로 분류된다.

import UIKit

extension UIColor {
    static var todayDetailCellTint: UIColor {
        UIColor(named: "DetailCellTint") ?? .tintColor
    }

    static var todayListCellBackground: UIColor {
        UIColor(named: "ListCellBackground") ?? .secondarySystemBackground
    }

    static var todayListCellDoneButtonTint: UIColor {
        UIColor(named: "ListCellDoneButtonTint") ?? .tintColor
    }

    static var todayGradientAllBegin: UIColor {
        UIColor(named: "GradientAllBegin") ?? .systemFill
    }

    static var todayGradientAllEnd: UIColor {
        UIColor(named: "GradientAllEnd") ?? .quaternarySystemFill
    }

    static var todayGradientFutureBegin: UIColor {
        UIColor(named: "GradientFutureBegin") ?? .systemFill
    }

    static var todayGradientFutureEnd: UIColor {
        UIColor(named: "GradientFutureEnd") ?? .quaternarySystemFill
    }

    static var todayGradientTodayBegin: UIColor {
        UIColor(named: "GradientTodayBegin") ?? .systemFill
    }

    static var todayGradientTodayEnd: UIColor {
        UIColor(named: "GradientTodayEnd") ?? .quaternarySystemFill
    }

    static var todayNavigationBackground: UIColor {
        UIColor(named: "NavigationBackground") ?? .secondarySystemBackground
    }

    static var todayPrimaryTint: UIColor {
        UIColor(named: "PrimaryTint") ?? .tintColor
    }

    static var todayProgressLowerBackground: UIColor {
        UIColor(named: "ProgressLowerBackground") ?? .systemGray
    }

    static var todayProgressUpperBackground: UIColor {
        UIColor(named: "ProgressUpperBackground") ?? .systemGray6
    }
}
