//
//  UIView+PinnedSubview.swift
//  Today
//
//  Created by 임윤휘 on 3/12/24.
//

import UIKit

// 각 control들이 유사한 레이아웃을 사용하기 때문에, 상위 뷰에 고정되어진 하위뷰를 추가하는 뷰의 기능을 확장한다.
extension UIView {
    func addPinnedSubview(
        _ subview: UIView, height: CGFloat? = nil,
        inset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    ) {
        addSubview(subview)
        // 시스템은 자동으로 view의 현재 size와 위치에 제약조건(constraint)를 설정한다.
        // 하지만 시스템에 의해 자동으로 설정된 제약조건은 뷰가 적응(변경)되지 못하게 한다.
        // 시스템이 자동으로 뷰에 제약조건을 걸지 못하도록 아래와 같이 설정
        subview.translatesAutoresizingMaskIntoConstraints = false
        // UIKit constraint syntax는 새로운 constraint의 isActivity 프로퍼티를 true로 설정하여 단일 단계로 제약조건을 정의하고 활성화할 수 있게 한다.
        subview.topAnchor.constraint(equalTo: topAnchor, constant: inset.top).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1.0 * inset.right).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0 * inset.bottom).isActive = true
        // 하위뷰가 상위뷰에 top과 bottom을 고정해두었기 때문에, 하위뷰의 높이를 조정하면 상위뷰도 상위뷰의 높이를 강제로 조정한다.
        if let height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
