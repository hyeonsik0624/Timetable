//
//  EditTimeTableTip.swift
//  Timetable
//
//  Created by 진현식 on 5/4/24.
//

import SwiftUI
import TipKit

struct EditTimetableTip: Tip {
    var title: Text {
        Text("탭하여 수정하기")
    }
    
    var message: Text? {
        Text("수정하고 싶은 곳을 터치하면\n시간표를 수정할 수 있어요.")
    }
    
    var image: Image? {
        Image(systemName: "square.and.pencil")
    }
    
    @Parameter
    static var shouldNotShowTip: Bool = {
        return UserDefaults.standard.bool(forKey: "shouldNotShowTip")
    }()
    
    var rules: [Rule] {
        #Rule(Self.$shouldNotShowTip) {
            $0 == false
        }
    }
}
