//
//  TextViewContentView.swift
//  Today
//
//  Created by 임윤휘 on 3/14/24.
//

import UIKit

class TextViewContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return TextViewContentView(self)
        }
    }
    
    let textView = UITextView()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(textView, height: 200)
        textView.backgroundColor = nil
        textView.delegate = self // 이 contentview를 textView의 delegate로 할당하여 사용자 상호작용에 대해 textview의 컨트롤를 모니터링하고 적절하게 응답한다
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textView.text = configuration.text
    }
}

extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}

// textView delegate로써 할당하는 객체는 textView가 사용자 상호작용을 감지할 때 개입한다
extension TextViewContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let configuration = configuration as? TextViewContentView.Configuration else { return }
        configuration.onChange(textView.text)
    }
}

// UIKit가 많은 control에 대해 delegate pattern을 사용하는 이유
// 1) delegate 프로토콜의 메소드를 구현한 후에는 delegate 객체는 개발자가 원하는 모든 작업을 수행할 수 있다. 따라서 사용자가 뷰 control과 상호작용할 때 어떤 일이든 유동적으로 작동한다.
// 2) view controller는 control의 delegate(대리인) 역할을 수행하여 model data와 control에 대해 관계(업무?)를 분리할 수 있다. 따라서 MVC 디자인 아키텍처에 잘 맞는다
// 3) delegate 패턴을 사용하는 UIKit control은 모델에 대해 전혀 알 필요가 없다. control은 오직 상호작용 또는 이벤트가 발생될 때에만 delegate(대리인, 주로 view controller)에게 보고한다. delegate는 적절하게 응답할 책임이 있다. 따라서 view controller과 모델의 결합도를 낮춘다
// 4) 단일 객체가 여러 다양한 control에 대한 이벤트를 처리할 수 있도록 코드를 조직화한다. 객체가 프로토콜을 준수하는 한 한 객체에 많고 다양한 UIKit control과 연관된 작업들을 수행하도록 할 수 있다. 
