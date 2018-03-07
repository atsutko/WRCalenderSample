//
//  addViewController.swift
//  WRCalendarViewSample
//
//  Created by TakaoAtsushi on 2018/03/06.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import FontAwesomeKit
import NCMB

protocol datePickerControlDelegate {
    func datePickerDidFinished(text: String)
}

class addViewController: UIViewController, UIPickerViewDelegate , UITextViewDelegate {
    
    @IBOutlet weak var scheduleDatePicker: UIDatePicker!
    @IBOutlet weak var dateScheduleIconLabel: UILabel!
    @IBOutlet weak var timeIconLabel: UILabel!
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var finishTimeDatePicker: UIDatePicker!
    @IBOutlet weak var titleIconLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var detailIconLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    var hoursChunk: Int = 0
    var minutesChunk: Int = 0
    var selectedDateText: String!
    var startTimeText: String!
    var finishedTimeText: String!
    
    var startTimeDate = Date()
    var finishedTimeDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateScheduleIconLabel.attributedText = FAKFontAwesome.calendarIcon(withSize: 15).attributedString()
        timeIconLabel.attributedText = FAKFontAwesome.clockOIcon(withSize: 15).attributedString()
        titleIconLabel.attributedText = FAKFontAwesome.pencilIcon(withSize: 15).attributedString()
        detailIconLabel.attributedText = FAKFontAwesome.listIcon(withSize: 15).attributedString()
        
        titleTextView.delegate = self
        detailTextView.delegate = self
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // textViewを閉じる
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            titleTextView.resignFirstResponder()
            detailTextView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    @IBAction func changeScheduleDatePicker(sender: UIDatePicker) {
       
        // フォーマットを生成.
        let myDateFormatter: DateFormatter = DateFormatter()
        
        myDateFormatter.dateFormat = "yyyy/MM/dd"
        
        // 日付をフォーマットに則って取得.
        
        let mySelectedDate: NSString = myDateFormatter.string(from: sender.date) as NSString
        selectedDateText = mySelectedDate as String!
    }
    
    @IBAction func changeStartTimePicker(sender: UIDatePicker) {
        
        // フォーマットを生成.
        
        let myDateFormatter: DateFormatter = DateFormatter()
        
        myDateFormatter.dateFormat = "hh:mm"
        
        // 始まる時刻をフォーマットに則って取得.

        let startTime: NSString = myDateFormatter.string(from: sender.date) as NSString
        startTimeText = startTime as String!
        startTimeDate = myDateFormatter.date(from: startTimeText)!
    }
    
    @IBAction func changeFinishTimeDatePicker(sender: UIDatePicker) {
        
        // フォーマットを生成.
        
        let myDateFormatter: DateFormatter = DateFormatter()
        
        myDateFormatter.dateFormat = "hh:mm"
        
        // 終了時刻をフォーマットに則って取得.
        let finishedTime: NSString = myDateFormatter.string(from: sender.date)  as! NSString
        finishedTimeText = finishedTime as String!
        finishedTimeDate = myDateFormatter.date(from: finishedTimeText)!
    }
    
    
    @IBAction func saveButtonPushed() {
      
        let object = NCMBObject(className: "Schedule")
        object?.setObject(titleTextView.text, forKey: "Title")
        object?.setObject(detailTextView.text, forKey: "Detail")
        object?.setObject(selectedDateText, forKey: "Date")
        object?.setObject(startTimeText, forKey: "StartTime")
        object?.setObject(finishedTimeText, forKey: "FinishedTime")
        
        //文字列を日付(Date型)に変換
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
       
        let span = finishedTimeDate.timeIntervalSince(startTimeDate)
        let hoursSpan = span/60/60
        let minutesSpan = (span - hoursSpan*60*60) / 60
        
        object?.setObject(minutesSpan, forKey: "minutesSpan")
        object?.setObject(hoursSpan, forKey: "hoursSpan")
        
        object?.saveInBackground({ (error) in
            if error != nil {
                
                // 保存できなかった時の処理
                let alertText = "正常に保存できませんでした"
                let alertController = UIAlertController(title: "保存", message: alertText, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                
                //保存できた時の処理
                let alertText = "保存が完了されました"
                let alertController = UIAlertController(title: "保存", message: alertText, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        })
        
        
        
    }
    
    
}
