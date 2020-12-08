//
//  ShoppingListViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/8/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController {

    @IBOutlet weak var DateLabel: UILabel!
        @IBOutlet weak var NotificationLabel: UILabel!
        
        @IBOutlet weak var EstablishMenuButton: UIButton!
        
        var dateData = Date()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            Init()
            // Do any additional setup after loading the view.
        }
        
        func Init() {
        }
        
        @IBAction func act_ShowDatePicker(_ sender: Any) {
            let myPopUp = self.storyboard?.instantiateViewController(identifier: "DatePickerPopUpViewController") as! DatePickerPopUpViewController
            myPopUp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myPopUp.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            myPopUp.delegate = self
            myPopUp.DefaultDate = dateData
            self.present(myPopUp, animated: true, completion: nil)
        }
    }

    extension ShoppingListViewController: DatePickerDalegate {
        func TransmitDate(Date date: Date) {
            let calendar = Calendar.current
            dateData = date
            if (calendar.isDateInToday(date) == true) {
                DateLabel.text = "Hôm nay"
            }
            else if (calendar.isDateInYesterday(date) == true) {
                DateLabel.text = "Hôm qua"
            }
            else if (calendar.isDateInTomorrow(date) == true) {
                DateLabel.text = "Ngày mai"
            }
            else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                DateLabel.text = dateFormatter.string(from: date)
            }
        }
    }
