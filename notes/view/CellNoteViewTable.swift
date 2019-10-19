//
//  CellNoteViewTable.swift
//  puotb
//
//  Created by Сергей Гриневич on 01/10/2019.
//  Copyright © 2019 Green. All rights reserved.
//

import UIKit
import Firebase


class CellNoteViewTable: UITableViewCell {
    
    var note : Notes? {
           didSet {
 
            textLabel?.text = note?.title
            detailTextLabel?.text = note?.note
            
            if let second = note?.date?.doubleValue {
                   let timeStapDate = Date(timeIntervalSince1970: second)
                   let dateForMatter = DateFormatter()
                   dateForMatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                   timeLabel.text = dateForMatter.string(from: timeStapDate)
               }
               
           }
       }
    

    override func layoutSubviews() {
        super.layoutSubviews()
         textLabel?.frame = CGRect(x: 16, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
         detailTextLabel?.frame = CGRect(x: 16, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
       
        
    }
    
    
    let timeLabel : UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(timeLabel)
        
        //timelabel
          timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
          timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
          timeLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
          timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
