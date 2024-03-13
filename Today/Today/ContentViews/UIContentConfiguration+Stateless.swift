//
//  UIContentConfiguration+Stateless.swift
//  Today
//
//  Created by 임윤휘 on 3/13/24.
//

import UIKit

extension UIContentConfiguration {
    // updated(for:)는 주어진 상태 따라 UIContentConfiguration가 configuration을 제공하도록 한다.
    // Today에서는 모든 상태에서 같은 configuration을 제공한다.
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
