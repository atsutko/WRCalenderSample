//
//  ViewController.swift
//  WRCalendarViewSample
//
//  Created by TakaoAtsushi on 2018/03/06.
//  Copyright © 2018年 TakaoAtsushi. All rights reserved.
//

import UIKit
import WRCalendarView
import DateToolsSwift
import DropDownMenuKit
import NCMB


class ViewController: UIViewController {
    
    @IBOutlet weak var weekView: WRWeekView!
    
    var titleView: DropDownTitleView!
    var navigationBarMenu: DropDownMenu!
    
    var nextTitle: String = ""
    var nextDate = Date()
    var nextStartTime = Date()
    var nextFinishedTime = Date()
    var nextDetail: String = ""
    
    var scheduleArray = [Schedule]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarData()
        
        let title = prepareNavigationBarMenuTitleView()
        prepareNavigationBarMenu(title)
        updateMenuContentOffsets()
        

        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadSchedule()
        navigationBarMenu.container = view
    }
    
    @objc func moveToToday() {
        weekView.setCalendarDate(Date(), animated: true)
    }
    
    // MARK: - WRCalendarView
    func setupCalendarData() {
        weekView.setCalendarDate(Date())
        weekView.delegate = self
    }
    
    // MARK: - DropDownMenu
    func prepareNavigationBarMenuTitleView() -> String {
        titleView = DropDownTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        titleView.addTarget(self,
                            action: #selector(willToggleNavigationBarMenu(_:)),
                            for: .touchUpInside)
        titleView.addTarget(self,
                            action: #selector(didToggleNavigationBarMenu(_:)),
                            for: .valueChanged)
        titleView.titleLabel.textColor = UIColor.black
        titleView.title = "Week"
        
        navigationItem.titleView = titleView
        
        return titleView.title!
    }
    
    func prepareNavigationBarMenu(_ currentChoice: String) {
        navigationBarMenu = DropDownMenu(frame: view.bounds)
        navigationBarMenu.delegate = self
        
        let firstCell = DropDownMenuCell()
        
        firstCell.textLabel!.text = "Week"
        firstCell.menuAction = #selector(choose(_:))
        firstCell.menuTarget = self
        if currentChoice == "Week" {
            firstCell.accessoryType = .checkmark
        }
        
        let secondCell = DropDownMenuCell()
        
        secondCell.textLabel!.text = "Day"
        secondCell.menuAction = #selector(choose(_:))
        secondCell.menuTarget = self
        if currentChoice == "Day" {
            firstCell.accessoryType = .checkmark
        }
        
        navigationBarMenu.menuCells = [firstCell, secondCell]
        navigationBarMenu.selectMenuCell(firstCell)
        
        // If we set the container to the controller view, the value must be set
        // on the hidden content offset (not the visible one)
        
        // TODO: 一時コメントアウト
        // navigationBarMenu.visibleContentInsets = navigationController!.navigationBar.frame.size.height + statusBarHeight()
        
        // For a simple gray overlay in background
        navigationBarMenu.backgroundView = UIView(frame: navigationBarMenu.bounds)
        navigationBarMenu.backgroundView!.backgroundColor = UIColor.black
        navigationBarMenu.backgroundAlpha = 0.7
    }
    
    @objc func willToggleNavigationBarMenu(_ sender: DropDownTitleView) {
        if sender.isUp {
            navigationBarMenu.hide()
        } else {
            navigationBarMenu.show()
        }
    }
    
    func updateMenuContentOffsets() {
        // TODO: 一時コメントアウト
        // navigationBarMenu.visibleContentInsets = navigationController!.navigationBar.frame.size.height + statusBarHeight()
    }
    
    @objc func didToggleNavigationBarMenu(_ sender: DropDownTitleView) {
    }
    
    @objc func choose(_ sender: AnyObject) {
        if let sender = sender as? DropDownMenuCell {
            titleView.title = sender.textLabel!.text
            
            switch titleView.title! {
            case "Week":
                weekView.calendarType = .week
            case "Day":
                weekView.calendarType = .day
            default:
                break
            }
        }
        
        if titleView.isUp {
            titleView.toggleMenu()
        }
    }
    
    func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return min(statusBarSize.width, statusBarSize.height)
    }
    
    
}

extension ViewController: DropDownMenuDelegate {
    func didTapInDropDownMenuBackground(_ menu: DropDownMenu) {
        titleView.toggleMenu()
    }
    
    // MARK: - events
    public func setEvents(events: [WREvent]) {
        
        forceReload(true)
    }
    
    public func addEvent(event: WREvent) {
        
        forceReload(true)
    }
    
    public func addEvents(events: [WREvent]) {
        
        forceReload(true)
    }
    
    public func forceReload(_ reloadEvents: Bool) {
        
    }
    
    //スケジュールのload
    func loadSchedule() {
        let query = NCMBQuery(className: "Schedule")
        query?.findObjectsInBackground { (results, error) in
            if error != nil {
                //検索に失敗した時の処理
                
            } else {
                
                //検索に成功した時の処理
                if let schedule = results as? [NCMBObject] {
                    for scheduleInfo in schedule {
                        let objectID = scheduleInfo.objectId
                        let date = scheduleInfo.object(forKey: "Date") as! String
                        let startTime = scheduleInfo.object(forKey: "StartTime") as! String
                        let finishedTime = scheduleInfo.object(forKey: "FinishedTime") as! String
                        //文字列を日付(Date型)に変換
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ja_JP")
                        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                        let dateSchedule = dateFormatter.date(from: "\(date) \(startTime)")
                        
                        
                        let title = scheduleInfo.object(forKey: "Title") as! String
                        let detail = scheduleInfo.object(forKey: "Detail") as! String
                        
                        let schedules = Schedule(objectID: objectID!, date: date, startTime: startTime, finishedTime: finishedTime, title: title, detail: detail)
                        self.scheduleArray.append(schedules)
                        
                        let hoursSpan = scheduleInfo.object(forKey: "hoursSpan") as! Int
                        let minutesSpan = scheduleInfo.object(forKey: "minutesSpan") as! Int
                        
                        self.weekView.addEvent(event: WREvent.make(date: dateSchedule!, chunk: TimeChunk.init(seconds: 0, minutes: minutesSpan, hours: hoursSpan, days: 0, weeks: 0, months: 0, years: 0), title: title))

                     }
                }
                
                
            }
        }
        
        
        
    }
    
    
}

extension ViewController: WRWeekViewDelegate {
    // イベントが入っている時にタップされた時の処理
    func selectEvent(_ event: WREvent) {
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        nextTitle = event.title
        
        
    }
    
    func view(startDate: Date, interval: Int) {
        print(startDate, interval)
    }
    
    
    // イベントの有無にかかわらず,タップされた時の処理
    func tap(date: Date) {
        print(date)
        // self.performSegue(withIdentifier: "toDetail", sender: nil)
        
    }
    
    
}





