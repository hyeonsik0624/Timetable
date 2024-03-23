//
//  TimetableController.swift
//  Timetable
//
//  Created by 진현식 on 3/23/24.
//

import UIKit

class TimetableController: UIViewController {
    
    // MARK: - Properties
    
    private var mondayTimetable = [String]() {
        didSet { print(mondayTimetable) }
    }
    private var tuesdayTimetable = [String]()
    private var wednesdayTimetable = [String]()
    private var thusdayTimetable = [String]()
    private var fridayTimetable = [String]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfDataExists()
    }
    
    // MARK: - Helpers
    
    func checkIfDataExists() {
        print(#function)
        if UserDefaults.standard.array(forKey: "5") != nil {
            print("loadtimetable...")
            loadTimetableData()
        } else {
            DispatchQueue.main.async {
                self.showSetupController()
            }
        }
    }
    
    func loadTimetableData() {
        print(#function)
        self.mondayTimetable = UserDefaults.standard.array(forKey: "1") as! [String]
        self.tuesdayTimetable = UserDefaults.standard.array(forKey: "2") as! [String]
        self.wednesdayTimetable = UserDefaults.standard.array(forKey: "3") as! [String]
        self.thusdayTimetable = UserDefaults.standard.array(forKey: "4") as! [String]
        self.fridayTimetable = UserDefaults.standard.array(forKey: "5") as! [String]
    }
    
    func showSetupController() {
        
        let controller = SetupTimetableController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
}

