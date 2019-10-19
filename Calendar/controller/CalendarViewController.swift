//
//  CalendarViewController.swift
//  basic_xcode
//
//  Created by Сергей Гриневич on 23/08/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {


    @IBOutlet weak var calendar: JTAppleCalendarView!
    @IBOutlet weak var smenaPicker: UIPickerView!
    
    let smenaField = ["1 смена", "2 смена", "3 смена", "4 смена"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.scrollDirection = .horizontal
        calendar.scrollingMode   = .stopAtEachCalendarFrame
        calendar.showsHorizontalScrollIndicator = false
        calendar.allowsMultipleSelection = true
        calendar.isRangeSelectionUsed = true
        self.smenaPicker.dataSource = self
        self.smenaPicker.delegate = self
    
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        smenaField.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        smenaField[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        return NSAttributedString(string: smenaField[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func confugureCell(view: JTAppleCell?, cellState: CellState){
        guard let cell = view as? DateCell else {
            return
        }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
             cell.selectedView.backgroundColor = .red
        } else {
            cell.dateLabel.textColor = UIColor.gray
          
        }
        
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {

        
        cell.selectedView.isHidden = !cellState.isSelected
        switch cellState.selectedPosition() {
        case .left:
            cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        case .middle:
            cell.selectedView.layer.cornerRadius = 0
            cell.selectedView.layer.maskedCorners = []
        case .right:
            cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .full:
            cell.selectedView.layer.cornerRadius = 20
            cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        default: break
        }
    }


}


extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2019 08 01")!
        let endDate = Date()
        
        return ConfigurationParameters(startDate: startDate,
                                       endDate: endDate,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfGrid)
    }
}


extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        confugureCell(view: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMM"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        confugureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        confugureCell(view: cell, cellState: cellState)
    }
    
}
