//
//  DirectionListViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/4/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit

protocol DirectionDelegate: class {
    func SaveChange(List: [String])
}

class DirectionListViewController: UIViewController {
    
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var EditButton: UIButton!
    
    @IBOutlet weak var DirectionTableView: UITableView!
    
    var DirectionList = [String]()
    weak var delegate: DirectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        //Bo tron goc cho cac nut luu hoac huy thay doi
        CancelButton.layer.cornerRadius = 22
        CancelButton.layer.borderColor = UIColor.systemGreen.cgColor
        CancelButton.layer.borderWidth = 1
        SaveButton.layer.cornerRadius = 22
        
        //Khong hien thi vach chia cac cell
        DirectionTableView.separatorStyle = .none
        DirectionTableView.allowsSelection = false
    }
    
    @IBAction func act_CancelChange(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_SaveChange(_ sender: Any) {
        delegate?.SaveChange(List: DirectionList)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func act_EditDirection(_ sender: Any) {
        let index = (sender as! UIButton).tag
        let dest = self.storyboard?.instantiateViewController(identifier: "DirectionPopUpViewController") as! DirectionPopUpViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dest.delegate = self
        dest.DỉrectionID = index
        dest.DirectionContent = DirectionList[index]
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func act_ChangeEditMode(_ sender: Any) {
        //Tat che do chinh sua
        if (DirectionTableView.isEditing == true) {
            DirectionTableView.isEditing = false
            EditButton.tintColor = UIColor.systemGray
        }
        else { //Bat che do chinh sua
            DirectionTableView.isEditing = true
            EditButton.tintColor = UIColor.systemGreen
        }
        DirectionTableView.reloadData()
    }
    
    @IBAction func act_AddNewStep(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "DirectionPopUpViewController") as! DirectionPopUpViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dest.delegate = self
        dest.DỉrectionID = DirectionList.count
        dest.isAddNewDirection = true
        self.present(dest, animated: true, completion: nil)
    }
}

//Delegate
extension DirectionListViewController: DirectionPopUpDelegate {
    func DirectionProcess(index: Int, content: String) {
        //index = -1 thi khong co gi thay doi
        if (index > -1) {
            //Chinh sua buoc hien co
            if (index < DirectionList.count) {
                DirectionList[index] = content
            }
            else { //Them buoc moi
                DirectionList += [content]
            }
        }
        DirectionTableView.reloadData()
    }
}

extension DirectionListViewController : UITableViewDataSource, UITableViewDelegate {
    //So dong
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DirectionList.count
    }
    
    //Cai dat, hien thi du lieu 1 dong
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DirectionTableView.dequeueReusableCell(withIdentifier: "EditDirectionCell", for: indexPath) as! EditDirectionTableViewCell
        
        //Dinh nghia tag va target cho cac nut chinh sua nguyen lieu
        cell.EditButton.tag = indexPath.row
        cell.EditButton.addTarget(self, action: #selector(act_EditDirection(_:)), for: .touchUpInside)
        
        //Hien thi buoc thu may
        cell.StepNumberLabel.text = "Bước \(indexPath.row + 1)"
        //Hien thi noi dung cua buoc
        cell.StepDetailLabel.text = DirectionList[indexPath.row]
        //Neu dang o che do chinh sua thi hien nut chinh sua cac buoc len
        if (DirectionTableView.isEditing == true) {
            cell.WidthConstraint.constant = 30
        }
        else {
            cell.WidthConstraint.constant = 0
        }
        
        return cell
    }
    
    //Xu ly xoa nguyen lieu
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            DirectionList.remove(at: indexPath.row)
            DirectionTableView.reloadData()
        }
    }
    
    //Xu ly doi thu tu cac buoc
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = DirectionList[sourceIndexPath.row]
        DirectionList.remove(at: sourceIndexPath.row)
        DirectionList.insert(temp, at: destinationIndexPath.row)
        DirectionTableView.reloadData()
    }
}
