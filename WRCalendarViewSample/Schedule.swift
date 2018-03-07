//
//  Schedule.swift
//  WRCalendarViewSample
//
//  Created by TakaoAtsushi on 2018/03/08.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit

class Schedule: NSObject {

    var objectID: String
    var date: String
    var startTime: String
    var finishedTime: String
    var title: String
    var detail: String
    
    
    init(objectID: String, date: String, startTime: String, finishedTime: String, title: String, detail: String) {
        self.objectID = objectID
        self.date = date
        self.startTime = startTime
        self.finishedTime = finishedTime
        self.title = title
        self.detail = detail
    }
}
