//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by 임윤휘 on 2/14/24.
//

import UIKit

extension ReminderListViewController {
    /// 버튼 클릭 시 호출될 함수
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(withId: id)
    }
    
    /// reminder 추가 버튼 클릭 시 호출되는 함수
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        let reminder = Reminder(title: "", dueDate: Date.now)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            // closure의 캡쳐 리스트에 [weak self]를 추가하여 reminder view controller가 reminder "list" view controller에 대한 강한 참조(strong reference)를 캡쳐하거나 저장하는 걸 방지한다.
            // (https://longlivedrgn-miro.tistory.com/67)
            // (https://bbiguduk.gitbook.io/swift/language-guide-1/closures#closure-expressions)
            // ( 클로저는 외부 변수를 사용할 때 해당 변수를 클로저 내부적으로 저장한다. 해당 변수가 값/참조 구분없이 memory capture한다. 즉, 외부 변수의 주소값을 클로저가 capture하는 것이다. 이렇게 하여 외부 변수를 계속 클로저 내에서 참조하는 것이다. 이러한 상수와 변수를 폐쇄(closing over)라고 한다. Swift는 캡처의 모든 메모리 관리를 처리한다.
            // 이러한 클로져의 캡쳐 현상을 막아줄 수 있는 방법은 캡쳐 리스트를 활용하는 것이다. (캡쳐 리스트: 클로저가 정의되는 시점에 복사되는 변수들의 리스트) 리스트 내 변수들의 복사본들은 클로저가 메모리에서 소멸되기 전까지 내용이 변경되지 않고 유지된다. 즉, 클로저 내부에서 활용할 복사본을 만드는 것이다.
            // 하지만 참조 타입은 복사본을 만들더라도 주소 값이 전달되기 때문에 위에서 말한 완벽한 복사본 활용을 할 수 없다. 따라서 참조 타입의 캡쳐 리스트를 만들 때 reference count가 1 증가한다. 이때 weak나 unowned를 사용하여 reference count 증가를 막을 수 있으며 이를 통해 순환 참조 시 발생하는 메모리 누수(leak)를 방지할 수 있다.
            // (https://iosdevlime.tistory.com/entry/iOSSwift-메모리-누수가-발생하는-원인과-해결방안Strong-weak-unowned)
            //(메모리 누수: 순환참조로 인해 reference count가 0으로 수렴하지 않아 발생하는 문제, ARC를 통해 관리되는 메모리 할당/해제 과정이 강한 참조로 인해 제대로 작동(해제)되지 않아 발생
            // strong: 참조하는 인스턴스의 reference count 증가시키는 일반적인 참조 유형, RC가 0이 될 경우 메모리 상에서 해제. 순환참조가 발생하여 RC가 0이 되지 않아 메모리 해제가 계속 되지 않는 경우 메모리 누수 발생
            // weak: 객체의 소유권을 가지지 않고 주소값만을 가진 Pointer. 참조하는 객체의 RC를 증가시키지 않음(메모리 상에 weak 유형만 남아있다면, 객체는 메모리를 해제). 참조하는 객체게 메모리 해제될 경우, 자동으로 nil값이 할당된다. 따라서 해당 객체는 optional 타입이다.(weak self 시 self?가 되는 걸 떠올려보자)
            // unowned: 말 그대로 소유권을 가지지 않지만 항상 값이 있음을 가정한다. 따라서 optional 타입이 아니다. 소유권을 가지지 않으므로 참조하는 인스턴스의 RC를 증가시키지 않는다. 참조하는 객체가 메모리에서 해제되어도 댕글링 포인터(할당되지 않는 빈 공간을 가르키는 포인터)가 존재한다. 참조 해제로 해당 인스턴스를 사용하면 Error 발생. 따라서 객체의 Life Cycle이 명확한 경우에만 사용한다.
        }
        viewController.isAddingNewReminder = true
        viewController.setEditing(true, animated: false)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd(_:)))
        viewController.navigationItem.title = NSLocalizedString("Add Reminder", comment: "Add Reminder view controller title")
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    /// 취소 버튼 클릭 시 호출되는 함수. view controller를 dismiss한다
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
