//
//  EditTimetableController.swift
//  Timetable
//
//  Created by 진현식 on 4/9/24.
//

import UIKit

protocol EditTimetableControllerDelegate: AnyObject {
    func didFinishEditingTimetable(_ controller: EditTimetableController)
}

class EditTimetableController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: EditTimetableControllerDelegate?
    
    var index: Int
    var subject: String
    var classroom: String
    
    private lazy var subjectInputStackView = makeTimetableInputStackView(isClassroom: false)
    private lazy var classroomInputStackView = makeTimetableInputStackView(isClassroom: true)
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "네 글자 이하로 입력해 주세요"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.defaultButton(title: "수정하기")
        button.addTarget(self, action: #selector(handleEditButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.defaultButton(title: "닫기")
        button.backgroundColor = .systemGray
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleCloseButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    
    @objc func handleEditButtonTapped() {
        subject = getInputValue(withInputStackView: subjectInputStackView)
        classroom = getInputValue(withInputStackView: classroomInputStackView)
        
        var subjects = [String]()
        var classrooms = [String]()
        
        for i in 1...5 {
            guard let sbs = UserDefaults.appGroupUserDefaults?.array(forKey: "subjects:\(i)") as? [String] else { return }
            guard let cls = UserDefaults.appGroupUserDefaults?.array(forKey: "classrooms:\(i)") as? [String] else { return }
            
            subjects.append(contentsOf: sbs)
            classrooms.append(contentsOf: cls)
        }
        
        var day: Weekday {
            switch index {
            case 0...6:
                return .monday
            case 7...13:
                return .tuesday
            case 14...20:
                return .wednesday
            case 21...27:
                return .thursday
            case 28...34:
                return .friday
            default:
                break
            }
            
            return .monday
        }
        
        subjects[index] = subject
        classrooms[index] = classroom
        
        let editedOneDaySubjects = Array(subjects[day.range])
        let editedOneDayClassrooms = Array(classrooms[day.range])
        
        UserDefaults.appGroupUserDefaults?.setValue(editedOneDaySubjects, forKey: "subjects:\(day.rawValue)")
        UserDefaults.appGroupUserDefaults?.setValue(editedOneDayClassrooms, forKey: "classrooms:\(day.rawValue)")
        
        delegate?.didFinishEditingTimetable(self)
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
    
    @objc func handleCloseButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Lifecycle
    
    init(index: Int, subject: String, classroom: String) {
        self.index = index
        self.subject = subject
        self.classroom = classroom
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTextFields()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "시간표 편집"
        
        view.addSubview(noticeLabel)
        noticeLabel.anchor(top: view.topAnchor, paddingTop: 160)
        noticeLabel.centerX(withView: view)
        
        let inputViewStack = UIStackView(arrangedSubviews: [subjectInputStackView, classroomInputStackView])
        inputViewStack.spacing = 30
        
        view.addSubview(inputViewStack)
        inputViewStack.centerX(withView: view)
        inputViewStack.anchor(top: noticeLabel.bottomAnchor, paddingTop: 16)
        
        let buttonStack = UIStackView(arrangedSubviews: [closeButton, editButton])
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        
        view.addSubview(buttonStack)
        buttonStack.anchor(top: inputViewStack.bottomAnchor, paddingTop: 40)
        buttonStack.setDimension(width: 190, height: 40)
        buttonStack.centerX(withView: view)
    }
    
    func configureTextFields() {
        subjectInputStackView.subviews.forEach { subview in
            if let textField = subview as? UITextField {
                textField.text = subject
                textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                textField.becomeFirstResponder()
            }
        }
        
        classroomInputStackView.subviews.forEach { subview in
            if let textField = subview as? UITextField {
                textField.text = classroom
                textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            }
        }
    }
    
    func makeTimetableInputStackView(isClassroom: Bool) -> UIStackView {
        let guideLabel = UILabel()
        guideLabel.font = UIFont.systemFont(ofSize: 15)
        guideLabel.text = isClassroom ? "교실" : "과목명"
        
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
    
    func getInputValue(withInputStackView stackView: UIStackView) -> String {
        var result = ""
        
        stackView.subviews.forEach { subview in
            if let textField = subview as? UITextField {
                result = textField.text ?? ""
            }
        }
        
        return result
    }
}
