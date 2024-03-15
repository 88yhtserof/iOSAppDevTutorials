//
//  TextFieldContentView.swift
//  Today
//
//  Created by 임윤휘 on 3/13/24.
//

import UIKit

// UIContentView를 채택하는 것은 이 view가 configuration 속에 정의한 content와 styling을 만들어낸다는 것을 신호로 알린다.
// content view의 configuration은 뷰를 커스터마이즈한 모든 프로퍼티들과 동작들에 대한 값을 제공한다.
class TextFieldContentView: UIView, UIContentView {
    // 후에 configuration과 view의 content를 커스터마이즈하기 위해 아래 타입을 사용한다.
    // TextFieldContentView는 초기화시 UIContentConfiguration을 취하지만, 이 UIContentConfiguration은 텍스트필드 내에 포함될 content인 text를 가진다.
    // Including model data directly in the view code can create problems. Instead, provide the content view with a configuration structure with a property that includes the model data.
    // 모델 데이터를 뷰에 직접적으로 포함하는 것은 문제를 만들어 낼 수 있다. 대신, 모델 데이터를 포함하는 configuration 구조체의 프로퍼티를 두어 content 뷰에 제공하라
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) -> Void = { _ in } // 사용자가 텍스트필드에서 텍스트를 수정할 때 수행할 동작을 가진다
        
        func makeContentView() -> UIView & UIContentView {
            return TextFieldContentView(self)
        }
    }
    let textField = UITextField()
    var configuration: UIContentConfiguration {
        // How can you ensure your content view’s visual representation stays in sync with its associated model data?
        // Include a didSet observer for the configuration property in your content view that reconfigures the view every time the configuration object changes.
        // Because your configuration object provides the underlying model data, observing the configuration object for changes and reconfiguring the view when changes occur is an effective strategy.
        // configuration 구조체에 모델 데이터를 포함하는 프로퍼티가 있기 때문에, 뷰가 변화될 때마다 그 변화를 configuration 객체가 옵서빙하고 뷰를 재구성하는 것은 아주 효율적인 뷰-모델 동기화 작업이다
        // configuration이 변경될 때마다 현재 상태를 반영한 UI를 업데이트한다
        didSet { // didSet 옵서버
            configure(configuration: configuration)
        }
    }
    
    // 시스템은 UIView의 모든 하위클래스에 고유한 크기(너비, 높이)를 할당한다.
    // 예를 들어 label은 글자 크기에 기반하여 고유한 content 크기를 가진다.
    // 아래 프로퍼티를 오버라이드하여 커스텀 뷰가 레이아웃 시스템에 선호하는 크기를 알리도록 할 수 있다
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    // 커스텀 이니셜라이저를 구현한 UIView 서브클래스는 또한 아래 이니셜라이저를 구현해야한다.
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        // top과 bottom의 padding이 0으로 설정되어 있기 때문에, 텍스트뷰가 부모뷰의 전체 높이에 걸쳐져 있다.
        addPinnedSubview(textField, inset: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        textField.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        textField.clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textField.text = configuration.text
    }
    
    @objc private func didChange(_ sender: UITextField) {
        guard let configuration = configuration as? TextFieldContentView.Configuration else { return }
        configuration.onChange(textField.text ?? "")
    }
}

// TextFieldContentView와 한 쌍이 될 커스텀 configuration을 반환하는 UICollectionViewListCell의 동작 확장
extension UICollectionViewListCell {
    func textFieldConfiguration() -> TextFieldContentView.Configuration {
        TextFieldContentView.Configuration()
    }
}
