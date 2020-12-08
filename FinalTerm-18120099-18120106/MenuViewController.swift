//
//  MenuViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/2/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
class MenuViewController: UIViewController {
    var MenuList = ["Món ăn yêu thích","Công thức nhà mình","Mẹo hay","Món ăn ngày lễ","Món ăn chay","Món ăn giảm cân","Món bánh ngon","Món nhậu cơ bản", "Chính sách quyền riêng tư","Liên hệ"]
    @IBOutlet weak var MenuTBV: UITableView!
    
    @IBOutlet weak var MenuRightConstraint: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
        MenuRightConstraint.constant += view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MenuRightConstraint.constant -= view.bounds.width
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                     animations: { [weak self] in
                      self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        self.MenuTBV.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    func Init() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(view.subviews[view.subviews.count - 2])
    }

    @IBAction func act_HideMenu(_ sender: Any) {
        MenuRightConstraint.constant += view.bounds.width
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                     animations: { [weak self] in
                      self?.view.layoutIfNeeded()
            }, completion: {(value: Bool) in
            self.dismiss(animated: true, completion: nil)
        }
        )
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MenuViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuTableViewCell
        cell.lbMenu.text = MenuList[indexPath.row]
        cell.btnMenu.setImage(UIImage(named: "menu\(indexPath.row + 1)"), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 2) {
            let dest = self.storyboard?.instantiateViewController(identifier: "TipListViewController") as! TipListViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(dest, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
