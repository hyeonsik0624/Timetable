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
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var firstPeriodInputView = makeTimetableInputView(period: 1)
    private lazy var secondPeriodInputView = makeTimetableInputView(period: 2)
    private lazy var thirdPeriodInputView = makeTimetableInputView(period: 3)
    private lazy var fourthPeriodInputView = makeTimetableInputView(period: 4)
    private lazy var fifthPeriodInputView = makeTimetableInputView(period: 5)
    private lazy var sixthPeriodInputView = makeTimetableInputView(period: 6)
    private lazy var seventhPeriodInputView = makeTimetableInputView(period: 7)
    
    private lazy var firstClassroomInputView = makeTimetableInputView()
    private lazy var secondClassroomInputView = makeTimetableInputView()
    private lazy var thirdClassroomInputView = makeTimetableInputView()
    private lazy var fourthClassroomInputView = makeTimetableInputView()
    private lazy var fifthClassroomInputView = makeTimetableInputView()
    private lazy var sixthClassroomInputView = makeTimetableInputView()
    private lazy var seventhClassroomInputView = makeTimetableInputView()
    
    private lazy var subjectInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstPeriodInputView, secondPeriodInputView, thirdPeriodInputView, fourthPeriodInputView, fifthPeriodInputView, sixthPeriodInputView, seventhPeriodInputView])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var classroomInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstClassroomInputView, secondClassroomInputView, thirdClassroomInputView, fourthClassroomInputView, fifthClassroomInputView, sixthClassroomInputView, seventhClassroomInputView])
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
    
    // MARK: - Actions
    
    @objc func handleNextButtonTapped() {
        saveTimetable()
        
        guard let nextDay = Weekday(rawValue: day.rawValue + 1) else {
            let controller = TimetableController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
            return
        }
        
        day = nextDay
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateUI()
        setupFirstResponder()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(guidanceLabel)
        guidanceLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 10)
        
        view.addSubview(daysLabel)
        daysLabel.anchor(top: guidanceLabel.bottomAnchor, paddingTop: 20)
        daysLabel.centerX(withView: view)
        
        let stack = UIStackView(arrangedSubviews: [subjectInputStack, classroomInputStack])
        stack.spacing = 40
        
        view.addSubview(stack)
        stack.centerX(withView: view)
        stack.anchor(top: daysLabel.bottomAnchor, paddingTop: 4)
        
        view.addSubview(nextButton)
        nextButton.setDimension(width: 100, height: 40)
        nextButton.anchor(top: stack.bottomAnchor, paddingTop: 10)
        nextButton.centerX(withView: stack)
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
    
    func setupFirstResponder() {
        if let firstTextField = firstPeriodInputView.arrangedSubviews.first(where: { $0.tag == 1 }) {
            firstTextField.becomeFirstResponder()
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
            self.guidanceLabel.text = "\(self.day.name) 시간표를 입력해주세요"
            self.daysLabel.text = self.day.name
            
            UIView.animate(withDuration: 0.2) { [self] in
                self.guidanceLabel.alpha = 1
                self.daysLabel.alpha = 1
            }
        }
        
        setupFirstResponder()
    }
    
    func saveTimetable() {
        let period = getSubjects()
        let classroom = getClassrooms()
        
        UserDefaults.standard.setValue(period, forKey: "subjects:\(day.rawValue)")
        UserDefaults.standard.setValue(classroom, forKey: "classrooms:\(day.rawValue)")
    }
}
