//
//  TextFieldContentView.swift
//  Today
//
//  Created by 임윤휘 on 3/13/24.
//

import UIKit

class TextFieldContentView: UIView {
    let textField = UITextField()
    
    // 시스템은 UIView의 모든 하위클래스에 고유한 크기(너비, 높이)를 할당한다.
    // 예를 들어 label은 글자 크기에 기반하여 고유한 content 크기를 가진다.
    // 아래 프로퍼티를 오버라이드하여 커스텀 뷰가 레이아웃 시스템에 선호하는 크기를 알리도록 할 수 있다
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    // 커스텀 이니셜라이저를 구현한 UIView 서브클래스는 또한 아래 이니셜라이저를 구현해야한다.
    init() {
        super.init(frame: .zero)
        // top과 bottom의 padding이 0으로 설정되어 있기 때문에, 텍스트뷰가 부모뷰의 전체 높이에 걸쳐져 있다.
        addPinnedSubview(textField, inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        textField.clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
