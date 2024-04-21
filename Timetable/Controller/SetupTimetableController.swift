//
//  SetupTimetableController.swift
//  Timetable
//
//  Created by 진현식 on 3/23/24.
//

import UIKit

class SetupTimetableController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = SetupTimetableViewModel.shared
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var subjectInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [makeTimetableInputView(period: 1), makeTimetableInputView(period: 2), makeTimetableInputView(period: 3), makeTimetableInputView(period: 4), makeTimetableInputView(period: 5), makeTimetableInputView(period: 6), makeTimetableInputView(period: 7)])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var classroomInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [makeTimetableInputView(), makeTimetableInputView(), makeTimetableInputView(), makeTimetableInputView(), makeTimetableInputView(), makeTimetableInputView(), makeTimetableInputView()])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.defaultButton(title: "다음")
        button.addTarget(self, action: #selector(handleNextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.defaultButton(title: "이전")
        button.backgroundColor = .lightGray
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dayControlButtonStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var subjectTextFields: [UITextField] {
        var textFields = [UITextField]()
        
        subjectInputStack.arrangedSubviews.forEach { containerView in
            containerView.subviews.forEach { subview in
                guard let tf = subview as? UITextField else { return }
                textFields.append(tf)
            }
        }
        
        return textFields
    }
    
    private var classroomTextFields: [UITextField] {
        var textFields = [UITextField]()
        
        classroomInputStack.arrangedSubviews.forEach { containerView in
            containerView.subviews.forEach { subview in
                guard let tf = subview as? UITextField else { return }
                textFields.append(tf)
            }
        }
        
        return textFields
    }
    
    private var allTextFields: [UITextField] {
        var textFields = [UITextField]()
        
        for i in 0...subjectTextFields.count - 1 {
            textFields.append(subjectTextFields[i])
            if i < classroomTextFields.count {
                textFields.append(classroomTextFields[i])
            }
        }
        
        return textFields
    }
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "네 글자 이하로 입력해 주세요"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var mondayDayControlButtonWidhtConstraint = dayControlButtonStack.widthAnchor.constraint(equalToConstant: 100)
    private lazy var normalDayControlButtonWidhtConstraint = dayControlButtonStack.widthAnchor.constraint(equalToConstant: 210)
    
    // MARK: - Actions
    
    @objc func handleNextButtonTapped() {
        let subjectTexts = getSubjects()
        let classroomTexts = getClassrooms()
        
        viewModel.saveTimetableData(subjectsData: subjectTexts, classroomsData: classroomTexts) {
            
            self.viewModel.changeDay(toNextDay: true) { isFriday in
                DispatchQueue.main.async {
                    if isFriday {
                        let controller = TimetableController(collectionViewLayout: UICollectionViewFlowLayout())
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: true)
                    } else {
                        self.updateUI()
                    }
                }
            }
        }
    }
    
    @objc func handleBackButtonTapped() {
        viewModel.changeDay(toNextDay: false) { _ in
            self.updateUI()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        let startIndex = text.startIndex
        let maxLength = 4
        
        if text.count > maxLength {
            noticeLabel.textColor = .systemRed
            let targetIndex = text.index(startIndex, offsetBy: maxLength - 1)
            let newString = text[text.startIndex...targetIndex]
            textField.text = String(newString)
        } else {
            noticeLabel.textColor = UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateUI()
        setupTextFields()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(guideLabel)
        guideLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 10)
        
        view.addSubview(daysLabel)
        daysLabel.anchor(top: guideLabel.bottomAnchor, paddingTop: 10)
        daysLabel.centerX(withView: view)
        
        view.addSubview(noticeLabel)
        noticeLabel.anchor(top: daysLabel.bottomAnchor)
        noticeLabel.centerX(withView: view)
        
        let stack = UIStackView(arrangedSubviews: [subjectInputStack, classroomInputStack])
        stack.spacing = 40
        
        view.addSubview(stack)
        stack.centerX(withView: view)
        stack.anchor(top: noticeLabel.bottomAnchor, paddingTop: 4)
        
        view.addSubview(dayControlButtonStack)
        mondayDayControlButtonWidhtConstraint.isActive = true
        dayControlButtonStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dayControlButtonStack.anchor(top: stack.bottomAnchor, paddingTop: 10)
        dayControlButtonStack.centerX(withView: stack)
    }
    
    func makeTimetableInputView(period: Int? = nil) -> UIStackView {
        let guideLabel = UILabel()
        guideLabel.font = UIFont.systemFont(ofSize: 15)
        
        if let period = period {
            guideLabel.text = "\(period)교시"
        } else {
            guideLabel.text = "교실"
        }
        
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.tag = 1
        
        tf.setDimension(width: 80, height: 34)
        
        let stack = UIStackView(arrangedSubviews: [guideLabel, tf])
        stack.spacing = 10
        return stack
    }
    
    func setupTextFields() {
        allTextFields.forEach { tf in
            tf.delegate = self
            tf.returnKeyType = .next
            tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    func getSubjects() -> [String] {
        var values = [String]()
        
        subjectInputStack.arrangedSubviews.forEach { containerView in
            containerView.subviews.forEach { subview in
                if let textField = subview as? UITextField {
                    if let text = textField.text {
                        values.append(text)
                    }
                }
            }
        }
        
        return values
    }
    
    func getClassrooms() -> [String] {
        var values = [String]()
        
        classroomInputStack.arrangedSubviews.forEach { containerView in
            containerView.subviews.forEach { subview in
                if let textField = subview as? UITextField {
                    if let text = textField.text {
                        values.append(text)
                    }
                }
            }
        }
        
        return values
    }
    
    func clearAllTextFields() {
        subjectInputStack.arrangedSubviews.forEach { containerView in
            containerView.subviews.forEach { subview in
                if let textField = subview as? UITextField {
                    textField.text = nil
                }
            }
        }
        
        classroomInputStack.arrangedSubviews.forEach { containerView in
            containerView.subviews.forEach { subview in
                if let textField = subview as? UITextField {
                    textField.text = nil
                }
            }
        }
    }
    
    func updateUI() {
        clearAllTextFields()
        
        UIView.animate(withDuration: 0.2) { [self] in
            guideLabel.alpha = 0
            daysLabel.alpha = 0
        } completion: { _ in
            self.guideLabel.text = self.viewModel.getGuideText()
            self.daysLabel.text = self.viewModel.getDayName()
            
            UIView.animate(withDuration: 0.2) { [self] in
                self.guideLabel.alpha = 1
                self.daysLabel.alpha = 1
            }
        }
        
        updateDayControlStack()
        
        viewModel.loadTimetableData {
            let timetableData = self.viewModel.getTimetableData()
            print(timetableData)
            
            DispatchQueue.main.async {
                for i in 0...self.allTextFields.count - 1 {
                    self.allTextFields[i].text = timetableData[i]
                }
            }
        }
        
        guard let firstTextField = subjectTextFields.first else { return }
        firstTextField.becomeFirstResponder()
    }
    
    func updateDayControlStack() {
        let subviews = dayControlButtonStack.subviews
        subviews.forEach { view in
            dayControlButtonStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        if viewModel.shouldShowBackButton {
            dayControlButtonStack.addArrangedSubview(backButton)
            
            mondayDayControlButtonWidhtConstraint.isActive = false
            normalDayControlButtonWidhtConstraint.isActive = true
            dayControlButtonStack.layoutIfNeeded()
        } else {
            normalDayControlButtonWidhtConstraint.isActive = false
            mondayDayControlButtonWidhtConstraint.isActive = true
            dayControlButtonStack.layoutIfNeeded()
        }
        
        dayControlButtonStack.addArrangedSubview(nextButton)
    }
}

// MARK: - UITextFieldDelegate

extension SetupTimetableController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let currentIndex = allTextFields.firstIndex(of: textField) else { return true }
        
        if currentIndex < 13 {
            allTextFields[currentIndex + 1].becomeFirstResponder()
        } else if currentIndex == 13 {
            handleNextButtonTapped()
        }
        
        return true
    }
}
