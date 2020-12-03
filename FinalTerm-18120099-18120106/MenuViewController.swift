//
//  MenuViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by TRUNG on 12/2/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
class Menu {
    var MenuName: String?
    var List: [String]?
    init(MenuName: String, List: [String]){
        self.MenuName = MenuName
        self.List = List
    }
}
class MenuViewController: UIViewController {
    var MenuList = ["Favorite Food","My Food Recipe","Holiday Food","Vegetarian Food","Diet Food","Cake Food","Party Food"]
    var MyAppList = ["Security","Email"]
    var LIST = [Menu]()
    @IBOutlet weak var MenuTBV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        INIT()
        LIST.append(Menu.init(MenuName: "MenuList", List: MenuList))
        LIST.append(Menu.init(MenuName: "MyAppList", List: MyAppList))
        self.MenuTBV.separatorStyle = .none
        MenuTBV.delegate = self
        MenuTBV.dataSource = self
        // Do any additional setup after loading the view.
    }
    func INIT(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(view.subviews[view.subviews.count - 2])
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LIST[section].List!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuTableViewCell
        cell.lbMenu.text = LIST[indexPath.section].List![indexPath.row]
        if (indexPath.section == 0){
            cell.btnMenu.setImage(UIImage(named: "menu\(indexPath.row + 1)"), for: .normal)}
        else{
            cell.btnMenu.setImage(UIImage(named: "menu\(indexPath.row + 1 + LIST[0].List!.count)"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (section == 0){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        view.backgroundColor = .darkGray
            return view}
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 0){
            return 1.0}
        return 0.0
    }
}
