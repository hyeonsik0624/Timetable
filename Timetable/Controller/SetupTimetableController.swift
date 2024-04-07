//
//  SetupTimetableController.swift
//  Timetable
//
//  Created by 진현식 on 3/23/24.
//

import UIKit

class SetupTimetableController: UIViewController {
    
    // MARK: - Properties
    
    private var day = Weekday.monday {
        didSet { updateUI() }
    }
    
    private let guidanceLabel: UILabel = {
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
        button.backgroundColor = .systemBlue
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleNextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemGray
        button.setTitle("이전", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
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
        saveTimetableData()
        
        guard let nextDay = Weekday(rawValue: day.rawValue + 1) else {
            let controller = TimetableController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
            return
        }
        
        day = nextDay
    }
    
    @objc func handleBackButtonTapped() {
        guard let newDay = Weekday(rawValue: day.rawValue - 1) else { return }
        day = newDay
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
            noticeLabel.textColor = .black
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
        
        view.addSubview(guidanceLabel)
        guidanceLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 10)
        
        view.addSubview(daysLabel)
        daysLabel.anchor(top: guidanceLabel.bottomAnchor, paddingTop: 10)
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
        let periodLabel = UILabel()
        periodLabel.font = UIFont.systemFont(ofSize: 15)
        
        if let period = period {
            periodLabel.text = "\(period)교시"
        } else {
            periodLabel.text = "교실"
        }
        
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.tag = 1
        
        tf.setDimension(width: 80, height: 34)
        
        let stack = UIStackView(arrangedSubviews: [periodLabel, tf])
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
            guidanceLabel.alpha = 0
            daysLabel.alpha = 0
        } completion: { _ in
            self.guidanceLabel.text = "\(self.day.name) 시간표를 입력해 주세요"
            self.daysLabel.text = self.day.name
            
            UIView.animate(withDuration: 0.2) { [self] in
                self.guidanceLabel.alpha = 1
                self.daysLabel.alpha = 1
            }
        }
        
        updateDayControlStack()
        
        let timetableData = loadSavedTimetableData(day.rawValue)
        
        for i in 0...allTextFields.count - 1 {
            allTextFields[i].text = timetableData[i]
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
        
        if day != .monday {
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
    
    func saveTimetableData() {
        let period = getSubjects()
        let classroom = getClassrooms()
        
        UserDefaults.standard.setValue(period, forKey: "subjects:\(day.rawValue)")
        UserDefaults.standard.setValue(classroom, forKey: "classrooms:\(day.rawValue)")
    }
    
    func loadSavedTimetableData(_ dayRawValue: Int) -> [String] {
        var subjects = [String]()
        var classrooms = [String]()
        var results = [String]()

        subjects.append(contentsOf: UserDefaults.standard.array(forKey: "subjects:\(dayRawValue)") as! [String])
        classrooms.append(contentsOf: UserDefaults.standard.array(forKey: "classrooms:\(dayRawValue)") as! [String])
        
        for i in 0...subjects.count - 1 {
            results.append(subjects[i])
            
            if i < classrooms.count {
                results.append(classrooms[i])
            }
        }
        
        return results
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
