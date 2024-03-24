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
    
    private lazy var firstPeriodInputView = makePeriodInputView(withPeriodNumber: 1)
    private lazy var secondPeriodInputView = makePeriodInputView(withPeriodNumber: 2)
    private lazy var thirdPeriodInputView = makePeriodInputView(withPeriodNumber: 3)
    private lazy var fourthPeriodInputView = makePeriodInputView(withPeriodNumber: 4)
    private lazy var fifthPeriodInputView = makePeriodInputView(withPeriodNumber: 5)
    private lazy var sixthPeriodInputView = makePeriodInputView(withPeriodNumber: 6)
    private lazy var seventhPeriodInputView = makePeriodInputView(withPeriodNumber: 7)
    
    private lazy var inputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [firstPeriodInputView, secondPeriodInputView, thirdPeriodInputView, fourthPeriodInputView, fifthPeriodInputView, sixthPeriodInputView, seventhPeriodInputView])
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
        let subjects = getValuesAllTextFields()
        saveTimetable(withSubjects: subjects)
        
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
        view.backgroundColor = .systemBackground
        
        view.addSubview(guidanceLabel)
        guidanceLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 10)
        
        view.addSubview(daysLabel)
        daysLabel.anchor(top: guidanceLabel.bottomAnchor, paddingTop: 20)
        daysLabel.centerX(withView: view)
        
        view.addSubview(inputStack)
        inputStack.centerX(withView: view)
        inputStack.anchor(top: daysLabel.bottomAnchor, paddingTop: 4)
        
        view.addSubview(nextButton)
        nextButton.setDimension(width: 100, height: 40)
        nextButton.anchor(top: inputStack.bottomAnchor, paddingTop: 10)
        nextButton.centerX(withView: inputStack)
    }
    
    func makePeriodInputView(withPeriodNumber period: Int) -> UIStackView {
        let periodLabel = UILabel()
        periodLabel.font = UIFont.systemFont(ofSize: 15)
        periodLabel.text = "\(period)교시"
        
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.text = "국어"
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
    
    func getValuesAllTextFields() -> [String] {
        var values = [String]()
        
        inputStack.arrangedSubviews.forEach { containerView in
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
        inputStack.arrangedSubviews.forEach { containerView in
            containerView.subviews.forEach { subview in
                if let textField = subview as? UITextField {
                    textField.text = nil
                }
            }
        }
    }
    
    func updateUI() {
        clearAllTextFields()
        
        guidanceLabel.text = "\(day.name) 시간표를 입력해주세요"
        daysLabel.text = day.name
        
        setupFirstResponder()
    }
    
    func saveTimetable(withSubjects subjects: [String]) {
        UserDefaults.standard.setValue(subjects, forKey: "\(day.rawValue)")
    }
}
