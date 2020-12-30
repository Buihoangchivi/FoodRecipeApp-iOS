//
//  ViewController.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 11/26/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class FoodInfomation {
    var Name = ""
    var Image = ""
}

var FoodList = [FoodInfomation]()
let imageRef = Storage.storage().reference()
let FirebaseRef = Database.database().reference()
let foodInfoRef = FirebaseRef.child("FoodList")

let CategoryList = ["Thịt heo", "Thịt bò", "Thịt gà", "Thịt vịt", "Hải sản", "Cá", "Bánh", "Trái cây", "Ăn chay", "Giảm cân", "Chiên xào", "Món canh", "Món nướng", "Món kho", "Món nhậu", "Tiết kiệm", "Ngày lễ, tết", "Khác"]
let MealList = ["Bữa sáng", "Bữa trưa", "Bữa tối", "Bữa phụ", "Khác"]
var CurrentUserID = ""

//Chuyen thanh chuoi ASCII va xoa ki tu khoang trang trong chuoi
func GetCustomizedString(_ string: String) -> String {
    var result = string.folding(options: .diacriticInsensitive, locale: .current)
    result = result.replacingOccurrences(of: " ", with: "").lowercased()
    //Chuyen thu cong chu đ thanh chu d
    result = result.replacingOccurrences(of: "đ", with: "d")
    return result
}

func CheckIfStringContainSubstring(_ str: String, _ sub: String) -> Bool {
    var result = true
    //Chuyen thanh chuoi ASCII va xoa ki tu khoang trang trong chuoi
    let unicodeName = GetCustomizedString(str)
    let unicodeSubName = GetCustomizedString(sub)
    
    //Neu chuoi can tim kiem khac rong thi kiem tra
    if (unicodeSubName != "") {
        result = unicodeName.contains(unicodeSubName)
    }
    return result
}

func GetOriginSubstring(_ mainString: String, _ subString: String) -> String {
    //Neu chuoi can tim la rong thi tra ve chuoi rong
    if (subString == "") {
        return ""
    }
    //Chuyen chuoi con can tim thanh chuoi ASCII khong co ki tu khoang trang
    var str = "", mainChar = "", subChar = "", subStringTemp = GetCustomizedString(subString)
    var mainStringIndex, subStringIndex: String.Index
    var subIndex = 0
    var check = false
    for mainIndex in 0..<mainString.count {
        //Lay Index cua chuoi chinh va chuoi con tu lan luot o vi tri 'mainIndex' va 'subIndex'
        //Viec chay index cua 2 chuoi nay giong nhu chay 2 con tro song song
        mainStringIndex = mainString.index(mainString.startIndex, offsetBy: mainIndex)
        subStringIndex = subString.index(subStringTemp.startIndex, offsetBy: subIndex)
        //Lay 2 ki tu cua 2 chuoi tu 2 index o tren
        mainChar = GetCustomizedString(String(mainString[mainStringIndex]))
        subChar = String(subStringTemp[subStringIndex])
        
        //Neu 2 ki tu bang nhau hoac dang duyet chuoi kha thi ma gap dau cach thi xu ly
        if (mainChar == subChar || (mainChar == "" && check == true)) {
            //Chuyen sang trang thai chuoi dang xet la kha thi
            if (check == false) {
                check = true
            }
            //Cong dong ki tu dang xet vao ket qua
            str += [mainString[mainStringIndex]]
            //Neu ki tu dang xet khac dau cach thi moi tang chi so cua chuoi con len
            if (mainChar != "") {
                subIndex += 1
            }
        }
        else { //Truong hop ki tu chuoi con khong giong ki tu tuong ung trong chuoi chinh
            //Chuyen trang thai chuoi dang xet tu kha thi thanh khong kha thi
            if (check == true) {
                check = false
                str = ""
                subIndex = 0
            }
        }
        
        //Neu da du so ki tu thi tra va tra ve chuoi str
        if (subIndex == subStringTemp.count) {
            return str
        }
    }
    //Truong hop chuoi chinh khong chua chuoi con thi tra ve chuoi rong
    return ""
}

func AttributedStringWithColor(_ mainString: String, _ string: String, color: UIColor) -> NSAttributedString {
    
    //Lay chuoi 'string' voi dinh dang giong nhu trong 'mainString'
    let subString = GetOriginSubstring(mainString, string)
    
    //Thay doi mau cho chuoi con trong ten mon an trung voi chuoi tim kiem
    let attributedString = NSMutableAttributedString(string: mainString)
    let range = (mainString as NSString).range(of: subString)
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

    return attributedString
}

class ViewController: UIViewController {

    @IBOutlet weak var HomeButton: UIButton!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var ShoppingButton: UIButton!
    @IBOutlet weak var CategoryCollectionView: UICollectionView!
    @IBOutlet weak var MealCollectionView: UICollectionView!
    
    @IBOutlet weak var ShadowView: UIView!
    @IBOutlet weak var FoodView: UIView!
    @IBOutlet weak var HomeView: UIView!
    
    @IBOutlet weak var FoodButton0: UIButton!
    @IBOutlet weak var FoodButton1: UIButton!
    @IBOutlet weak var FoodButton2: UIButton!
    @IBOutlet weak var FoodButton3: UIButton!
    @IBOutlet weak var FoodButton4: UIButton!
    @IBOutlet weak var FoodButton5: UIButton!
    
    @IBOutlet weak var FoodFavoriteButton0: UIButton!
    @IBOutlet weak var FoodFavoriteButton1: UIButton!
    @IBOutlet weak var FoodFavoriteButton2: UIButton!
    @IBOutlet weak var FoodFavoriteButton3: UIButton!
    @IBOutlet weak var FoodFavoriteButton4: UIButton!
    @IBOutlet weak var FoodFavoriteButton5: UIButton!
    
    @IBOutlet weak var FoodImage0: UIImageView!
    @IBOutlet weak var FoodImage1: UIImageView!
    @IBOutlet weak var FoodImage2: UIImageView!
    @IBOutlet weak var FoodImage3: UIImageView!
    @IBOutlet weak var FoodImage4: UIImageView!
    @IBOutlet weak var FoodImage5: UIImageView!
    
    @IBOutlet weak var FoodName0: UILabel!
    @IBOutlet weak var FoodName1: UILabel!
    @IBOutlet weak var FoodName2: UILabel!
    @IBOutlet weak var FoodName3: UILabel!
    @IBOutlet weak var FoodName4: UILabel!
    @IBOutlet weak var FoodName5: UILabel!
    
    @IBOutlet weak var FirstPageButton: UIButton!
    @IBOutlet weak var PrevPageButton: UIButton!
    @IBOutlet weak var CurrentPageLabel: UILabel!
    @IBOutlet weak var ChangeCurrentPageButton: UIButton!
    @IBOutlet weak var NextPageButton: UIButton!
    @IBOutlet weak var LastPageButton: UIButton!
    
    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet weak var HomeLabel: UILabel!
    @IBOutlet weak var SearchButton: UIButton!
    
    @IBOutlet weak var SearchFoodButton: UIButton!
    @IBOutlet weak var CancelFoodButton: UIButton!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SearchLabel: UILabel!
    
    @IBOutlet weak var ShadowViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var ShadowViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var SearchWidthConstraint: NSLayoutConstraint!
    
    var SelectedCategory = [Bool]()
    var SelectedMeal = [Bool]()
    
    //Danh sach cac mon an dang duoc filter
    var FoodIDList = [Int]()
    
    var FoodImageOutletList = [UIImageView]()
    var FoodNameOutletList = [UILabel]()
    var FoodButtonOutletList = [UIButton]()
    var FoodFavoriteButtonOutletList = [UIButton]()
    var CurrentPage = 1
    var TotalPage = 0
    var searchFoodName = ""
    
    override func viewWillAppear(_ animated: Bool) {
        ShadowViewLeftConstraint.constant += view.bounds.width
        ShadowViewRightConstraint.constant -= view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ShadowViewLeftConstraint.constant -= view.bounds.width
        ShadowViewRightConstraint.constant += view.bounds.width
        UIView.animate(withDuration: 0.7,
                       delay: 1,
                     animations: { [weak self] in
                      self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Init()
        /*let index = 1
        //Lay thong tin tat ca nguyen lieu cua mon an id 'index' tu Firebase
        foodInfoRef.child("\(index)/Ingredient").observeSingleEvent(of: .value, with: { (snapshot) in
        for snapshotChild in snapshot.children {
            let temp = snapshotChild as! DataSnapshot
            if let arr = temp.value as? NSArray {
                var infoArr = [String]()
                foodInfoRef.child("IngredientList/\(arr[0])").observeSingleEvent(of: .value, with: { (snapshot) in
                for snapshotChild in snapshot.children {
                    let temp = snapshotChild as! DataSnapshot
                    infoArr += [temp.value as! String]
                }
                    //Chi so cua nguyen lieu
                    //print(arr[0])
                    //Gia tri cua nguyen lieu
                    //print(arr[1])
                    //Ket qua
                    print("\(infoArr[0]): \(arr[1]) \(infoArr[1])")
            })
            }}})
        
        //Cap nhat thong tin len Firebase
        let ingredientIndex = 0
        //Thay doi loai nguyen lieu id 'ingredientIndex' cho mon an id 'index'
        foodInfoRef.child("\(index)/Ingredient/\(ingredientIndex)/").updateChildValues(["0": 2])
        //Thay doi gia tri cua nguyen lieu id 1 cho mon an id 0
        foodInfoRef.child("\(index)/Ingredient/\(ingredientIndex)/").updateChildValues(["1": 93])*/
        
        /*for i in 3...15 {
            foodInfoRef.child("FoodInfo\(i)").setValue(["Image": "\(i).jpg", "Name": "\(i)"])
        }*/
        //Lay dia chi
        //let ref = Database.database().reference(withPath: "Food0")
        
        //Doc du lieu
        /*ref.observeSingleEvent(of: .value, with: { (snapshot) in
        if let food = snapshot.value as? [String:Any] {
            print(food["Name"]!)
            print(food["Image"]!)
        }})*/
        
        //Xoa du lieu
        //ref.removeValue()
        
        //Cap nhat du lieu
        //ref.updateChildValues(["Image": "abc"])
        
        //Tao node moi roi ghi du lieu luon
        /*let aFoodRef = ref.child("Food0")
        let food = FoodInfomation()
        food.Image = "0"
        food.Name = "Name0"
        let a = ["Name": food.Name, "Image": food.Image]
        aFoodRef.setValue(a)*/
        
        //Upload anh
        /*//Tao duong dan
        let foodRef = Storage.storage().reference().child("Images/image0.jpg")
        // File located on disk
        let localFile = URL(string: "/Users/buivanvi/Downloads/fish+lemongrass-3.jpg")!

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = foodRef.putFile(from: localFile, metadata: nil) { metadata, error in
          if let errorU = error {
            print("Errorrrrrrrrrrr")
            print(errorU.localizedDescription)
          }
          else {
            // Metadata contains file metadata such as size, content-type.
            let size = metadata!.size
              // You can also access to download URL after upload.
            foodRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print(size)
                print(downloadURL)
            }
            }
        }
        uploadTask.resume()*/
        
        //Download anh
        /*
        let imageRef = ref.child("/FoodImages/4.jpg")
        FoodImage1.sd_setImage(with: imageRef)*/
        // Create a reference to the file you want to download
        /*let imageName = "0.jpg"
        let islandRef = ref.child("/\(imageName)")

        // Create local filesystem URL
        let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(imageName)
        print(localURL)
        // Download to the local filesystem
        let downloadTask = islandRef.write(toFile: localURL) { url, error in
          if let error = error {
            print("ahihi")
            print(error.localizedDescription)
          } else {
            print("OK")
          }
        }
        //downloadTask.resume()*/
        
    }

    func Init() {
        //Khoi tao cho cac List
        SelectedCategory = Array(repeating: false, count: CategoryList.count)
        SelectedMeal = Array(repeating: false, count: MealList.count)
        
        //Layout thanh loai thuc an
        var layout = CategoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 5,left: 10,bottom: 0,right: 15)
        
        //Layout thanh loai bua an
        layout = MealCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 5)
        
        //Bo goc cho nut thay doi so trang hien tai
        ChangeCurrentPageButton.layer.borderWidth = 0.2
        ChangeCurrentPageButton.layer.cornerRadius = 10
        
        //Layout bo goc va do bong cho nen 6 mon an
        FoodView.layer.cornerRadius = 10
        FoodView.layer.borderWidth = 0.1
        FoodView.layer.masksToBounds = true
        
        ShadowView.layer.shadowColor = UIColor.black.cgColor
        ShadowView.layer.shadowRadius = 7
        ShadowView.layer.shadowOpacity = 0.5
        ShadowView.layer.shadowOffset = CGSize(width: -2, height: 5)
        
        //Luu danh sach Outlet vao List
        FoodImageOutletList = [FoodImage0, FoodImage1, FoodImage2, FoodImage3, FoodImage4, FoodImage5]
        FoodNameOutletList = [FoodName0, FoodName1, FoodName2, FoodName3, FoodName4, FoodName5]
        FoodButtonOutletList = [FoodButton0, FoodButton1, FoodButton2, FoodButton3, FoodButton4, FoodButton5]
        FoodFavoriteButtonOutletList = [FoodFavoriteButton0, FoodFavoriteButton1, FoodFavoriteButton2, FoodFavoriteButton3, FoodFavoriteButton4, FoodFavoriteButton5]
        
        //Xac dinh co tat ca bao nhieu mon an luu tru tren Firebase
        //Tu do suy ra duoc tong so trang
        UpdateFoodList()
        
        //Bo tron goc cho hinh anh 6 mon an
        for i in 0...5 {
            FoodImageOutletList[i].layer.cornerRadius = 76
            FoodImageOutletList[i].layer.borderWidth = 1
            FoodImageOutletList[i].layer.borderColor = UIColor.lightGray.cgColor
        }
        
        //Bo tron goc cho cac nut phan trang
        FirstPageButton.layer.cornerRadius = 12
        PrevPageButton.layer.cornerRadius = 12
        NextPageButton.layer.cornerRadius = 12
        LastPageButton.layer.cornerRadius = 12
        
        //Khoi tao cac nut bi vo hieu hoa
        FirstPageButton.layer.borderWidth = 1
        FirstPageButton.layer.borderColor = UIColor.lightGray.cgColor
        PrevPageButton.layer.borderWidth = 1
        PrevPageButton.layer.borderColor = UIColor.lightGray.cgColor
        
        //Bo tron goc cho khung tim kiem
        SearchLabel.layer.cornerRadius = 22
        SearchLabel.layer.borderWidth = 0.2
        SearchLabel.layer.masksToBounds = true
    }
    
    @IBAction func act_ClickFoodButton(_ sender: Any) {
        let button = sender as! UIButton
        let index = button.restorationIdentifier!.last!.hexDigitValue!
        let myPopUp = self.storyboard?.instantiateViewController(identifier: "FoodPopUpViewController") as! FoodPopUpViewController
        myPopUp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myPopUp.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        myPopUp.FoodID = FoodIDList[(CurrentPage - 1) * 6 + index]
        myPopUp.delegate = self
        self.present(myPopUp, animated: true, completion: nil)
    }
    
    @IBAction func act_ClickPageButton(_ sender: Any) {
        let button = (sender as! UIButton).restorationIdentifier!
        var temp = view.bounds.width
        //temp < 0 thi animation tu phai sang trai
        //temp > 0 thi animation tu trai sang phai
        if (button == "PrevPage" || button == "FirstPage") {
            temp *= -1
        }
        
        //Neu nhan nut Next hoac Last Page
        if (temp > 0) {
            if (button == "NextPage") {
                CurrentPage += 1 //Tang so trang len 1
            }
            else {
                CurrentPage = TotalPage //Trang cuoi cung
            }
            
            //Neu dang o trang cuoi cung thi vo hieu hoa 2 nut Next va Last Page
            if (CurrentPage == TotalPage) {
                ChangButtonState(NextPageButton, false)
                ChangButtonState(LastPageButton, false)
            }
            //Active 2 nut Prev va First Page
            if (PrevPageButton.isEnabled == false) {
                ChangButtonState(PrevPageButton, true)
                ChangButtonState(FirstPageButton, true)
            }
        }
        else { //Neu nhan nut Prev hoac First Page
            if (button == "PrevPage") {
                self.CurrentPage -= 1 //Giam so trang xuong 1
            }
            else {
                self.CurrentPage = 1 //Trang dau tien
            }
            
            //Neu dang o trang dau tien thi vo hieu hoa 2 nut Prev va First Page
            if (CurrentPage == 1) {
                ChangButtonState(PrevPageButton, false)
                ChangButtonState(FirstPageButton, false)
            }
            //Active 2 nut Next va Last Page
            if (NextPageButton.isEnabled == false) {
                ChangButtonState(NextPageButton, true)
                ChangButtonState(LastPageButton, true)
            }
        }
        AnimationChangePage(Width: temp)
    }
    
    @IBAction func act_ShowAddFoodScreen(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "AddNewFoodViewController") as! AddNewFoodViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dest.delegate = self
        HomeView.isHidden = true
        HomeButton.tintColor = UIColor.systemGray
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func act_ShowShoppingListScreen(_ sender: Any) {
        let dest = self.storyboard?.instantiateViewController(identifier: "ShoppingListViewController") as! ShoppingListViewController
        dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dest.delegate = self
        HomeView.isHidden = true
        HomeButton.tintColor = UIColor.systemGray
        self.present(dest, animated: true, completion: nil)
    }
    
    @IBAction func act_ShowMenu(_ sender: Any) {
        let myPopUp = self.storyboard?.instantiateViewController(identifier: "MenuViewController") as! MenuViewController
        myPopUp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myPopUp.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        myPopUp.delegate = self
        self.present(myPopUp, animated: true, completion: nil)
    }
    
    @IBAction func act_ChangeFavoriteStatus(_ sender: Any) {
        let button = sender as! UIButton
        let index = button.restorationIdentifier!.last!.hexDigitValue!
        let foodID = FoodIDList[(CurrentPage - 1) * 6 + index]
        //Them vao danh sach yeu thich
        if (button.tintColor == UIColor.black) {
            button.tintColor = UIColor.red
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            //Cap nhat data tren Firebase
            foodInfoRef.child("\(foodID)").updateChildValues(["Favorite": 1])
        }
        else { //Xoa khoi danh sach yeu thich
            button.tintColor = UIColor.black
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            //Cap nhat data tren Firebase
            foodInfoRef.child("\(foodID)").updateChildValues(["Favorite": 0])
        }
    }
    
    @IBAction func act_ChangeCurrentPageButton(_ sender: Any) {
        let myPopUp = self.storyboard?.instantiateViewController(identifier: "ChangeCurrentPagePopUpVC") as! ChangeCurrentPagePopUpVC
        myPopUp.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myPopUp.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        myPopUp.delegate = self
        myPopUp.CurrentPage = CurrentPage
        myPopUp.TotalPage = TotalPage
        self.present(myPopUp, animated: true, completion: nil)
    }
    
    @IBAction func act_OpenSearchFoodBox(_ sender: Any) {
        //Vo hieu tieu de va nut tim kiem
        HomeLabel.isHidden = true
        HomeLabel.isEnabled = false
        SearchButton.isHidden = true
        SearchButton.isEnabled = false
        
        //Hien thi khung tim kiem
        SearchLabel.isHidden = false
        SearchTextField.text = ""
        SearchTextField.isHidden = false
        SearchTextField.isEnabled = true
        SearchFoodButton.isHidden = false
        SearchFoodButton.isEnabled = true
        CancelFoodButton.isHidden = false
        CancelFoodButton.isEnabled = true
        //Animation xuat hien khung tim kiem
        SearchWidthConstraint.constant += 260
        UIView.animate(withDuration: 1,
                       delay: 0,
                     animations: {
                        [weak self] in
                        self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func act_SearchFood(_ sender: Any) {
        //Lay chuoi trong khung tim kiem
        searchFoodName = SearchTextField.text!
        UpdateFoodList()
    }
    
    @IBAction func act_CloseSearchBox(_ sender: Any) {
        searchFoodName = ""
        //An khung tim kiem
        SearchLabel.isHidden = true
        SearchTextField.isHidden = true
        SearchTextField.isEnabled = false
        SearchFoodButton.isHidden = true
        SearchFoodButton.isEnabled = false
        CancelFoodButton.isHidden = true
        CancelFoodButton.isEnabled = false
        //Active tieu de va nut tim kiem
        HomeLabel.isHidden = false
        HomeLabel.isEnabled = true
        SearchButton.isHidden = false
        SearchButton.isEnabled = true
        //Thu nho thanh tim kiem
        SearchWidthConstraint.constant -= 260
        UpdateFoodList()
    }
    
    //Thay doi trang thai cua cac nut phan trang
    func ChangButtonState(_ button: UIButton, _ isActive: Bool) {
        button.isEnabled = isActive
        if (isActive == true) {
            button.layer.borderWidth = 0
            button.tintColor  = UIColor.white
            button.backgroundColor = UIColor.systemGreen
        }
        else {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.tintColor = UIColor.black
            button.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        }
    }
    
    //Cap nhat danh sach mon an theo phan loai
    func UpdateFoodList() {
        FoodIDList = [Int]()
        
        //Kiem tra co phai dang chon tat cac cac loai mon an hay khong
        var isAllCategory = true
        for i in 0..<CategoryList.count {
            if (SelectedCategory[i] == true) {
                isAllCategory = false
                break
            }
        }
        
        //Kiem tra co phai dang chon tat cac cac loai bua an hay khong
        var isAllMeal = true
        for i in 0..<MealList.count {
            if (SelectedMeal[i] == true) {
                isAllMeal = false
                break
            }
        }
        
        foodInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for snapshotChild in snapshot.children {
                var check = 0
                let temp = snapshotChild as! DataSnapshot
                if let food = temp.value as? [String:AnyObject] {
                    //Kiem tra co thoa loai mon an dang loc hay khong
                    if (food["Category"] != nil) {
                        let categoryArray = food["Category"] as! NSArray
                        for i in 0..<categoryArray.count {
                            if (self.SelectedCategory[categoryArray[i] as! Int] == true || isAllCategory == true) {
                                check += 1
                                break
                            }
                        }
                    }
                    
                    //Kiem tra co thoa loai bua an dang loc hay khong
                    if (food["Meal"] != nil) {
                        let mealArray = food["Meal"] as! NSArray
                        for i in 0..<mealArray.count {
                            if (self.SelectedMeal[mealArray[i] as! Int] == true || isAllMeal == true) {
                                check += 1
                                break
                            }
                        }
                    }
                    
                    if let name = food["Name"] as? NSString {
                        if (CheckIfStringContainSubstring(name as String, self.searchFoodName) == false) {
                            continue
                        }
                    }
                    
                    //Neu thoa ca loai mon an va loai bua an thi dua mon an do vao List
                    if (check == 2) {
                        let id = Int(temp.key)!
                        self.FoodIDList += [id]
                    }
                }
            }
            
            if (self.FoodIDList.count == 0) {
                self.TotalPage = 0
                self.CurrentPage = 0
            }
            else {
                self.CurrentPage = 1
                self.TotalPage = (self.FoodIDList.count - 1) / 6 + 1
            }
            
            //Cap nhat trang thai cua cac nut phan trang
            if (self.TotalPage < 2) {
                if (self.NextPageButton.isEnabled == true) {
                    self.ChangButtonState(self.NextPageButton, false)
                    self.ChangButtonState(self.LastPageButton, false)
                }
            }
            else {
                if (self.NextPageButton.isEnabled == false) {
                    self.ChangButtonState(self.NextPageButton, true)
                    self.ChangButtonState(self.LastPageButton, true)
                }
            }
            self.ChangButtonState(self.PrevPageButton, false)
            self.ChangButtonState(self.FirstPageButton, false)
            
            //Cap nhat 6 mon an
            self.LoadFoodInfo()
            
            //Hien thi trang hien tai tren tong so trang
            self.CurrentPageLabel.text = "\(self.CurrentPage) / \(self.TotalPage)"
        })
    }
    
    //Lay thong tin mon an tu Firebase xuong App
    func LoadFoodInfo() {
        //An ca 6 mon an de app load lai se tao cam giac app chay muot hon
        for i in 0...5 {
            if (self.FoodButtonOutletList[i].isEnabled == true) {
                self.FoodButtonOutletList[i].isEnabled = false
                self.FoodImageOutletList[i].isHidden = true
                self.FoodNameOutletList[i].isHidden = true
                self.FoodFavoriteButtonOutletList[i].isEnabled = false
                self.FoodFavoriteButtonOutletList[i].isHidden = true
            }
        }
        
        //Cap nhat 6 mon an
        for i in 0...5 {
            //Kiem tra xem co du 6 mon an de hien thi hay khong
            //Neu khong thi vo hieu hoa nut
            if (self.FoodIDList.count <= (self.CurrentPage - 1) * 6 + i || self.CurrentPage == 0) {
                continue
            }
            //Doc du lieu 6 mon an tuong ung voi so trang hien tai
            foodInfoRef.child("\(FoodIDList[(self.CurrentPage - 1) * 6 + i])").observeSingleEvent(of: .value, with: { (snapshot) in
                
            if let food = snapshot.value as? [String:Any] {
                //Hien thi hinh anh mon an
                self.FoodImageOutletList[i].sd_setImage(with: imageRef.child("/FoodImages/\(food["Image"]!)"), maxImageSize: 1 << 30, placeholderImage: UIImage(named: "food-background"), options: .retryFailed, completion: nil)
                //Hien thi ten mon an
                self.FoodNameOutletList[i].attributedText = AttributedStringWithColor("\(food["Name"]!)", self.searchFoodName, color: UIColor.link)
                
                //Hien thi trang thai yeu thich cua mon an
                //Yeu thich
                if (food["Favorite"] as! Int == 1) {
                    self.FoodFavoriteButtonOutletList[i].tintColor = UIColor.red
                self.FoodFavoriteButtonOutletList[i].setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
                else { //Khong yeu thich
                    self.FoodFavoriteButtonOutletList[i].tintColor = UIColor.black
                self.FoodFavoriteButtonOutletList[i].setImage(UIImage(systemName: "heart"), for: .normal)
                }
                //Neu dang bi vo hieu hoa thi bat nut len
                if (self.FoodButtonOutletList[i].isEnabled == false) {
                    self.FoodButtonOutletList[i].isEnabled = true
                    self.FoodImageOutletList[i].isHidden = false
                    self.FoodNameOutletList[i].isHidden = false
                    self.FoodFavoriteButtonOutletList[i].isEnabled = true
                    self.FoodFavoriteButtonOutletList[i].isHidden = false
                }
            }
            })
        }
    }
    
    func AnimationChangePage(Width temp: CGFloat) {
        //Cap nhat so trang tren giao dien
        self.CurrentPageLabel.text = "\(self.CurrentPage) / \(self.TotalPage)"
        
        //Backup trang thai cac nut
        let tempButtonList: [(btn: UIButton, enable: Bool)] = [(FirstPageButton, FirstPageButton.isEnabled), (PrevPageButton, PrevPageButton.isEnabled), (NextPageButton, NextPageButton.isEnabled), (LastPageButton, LastPageButton.isEnabled)]
        
        //Vo hieu hoa cac nut khi dang thuc hien Animation
        FirstPageButton.isEnabled = false
        PrevPageButton.isEnabled = false
        NextPageButton.isEnabled = false
        LastPageButton.isEnabled = false
        
        //Animation di chuyen danh sach mon an hien tai ra ngoai khung hinh
        ShadowViewLeftConstraint.constant -= temp
        ShadowViewRightConstraint.constant += temp
        UIView.animate(withDuration: 0.8) { [weak self] in
          self?.view.layoutIfNeeded()
        }
        
        //Di chuyen danh sach mon an sang phai khung hinh
        ShadowViewLeftConstraint.constant += temp * 2
        ShadowViewRightConstraint.constant -= temp * 2
        UIView.animate(withDuration: 0,
                       delay: 0.8,
                     animations: { [weak self] in
                      self?.view.layoutIfNeeded()
        }, completion: { //Thay doi mon an
            (value: Bool) in
            //Cap nhat 6 mon an
            self.LoadFoodInfo()
        })
        //Animation di chuyen danh sach mon an moi vao khung hinh
        ShadowViewLeftConstraint.constant -= temp
        ShadowViewRightConstraint.constant += temp
        UIView.animate(withDuration: 0.8,
                       delay: 0.8,
                     animations: { [weak self] in
                      self?.view.layoutIfNeeded()
            }, completion: { //Active cac nut sau khi thuc hien xong Animation
                (value: Bool) in
                for i in 0...3 {
                    tempButtonList[i].btn.isEnabled = tempButtonList[i].enable
                }
            })
    }
}

//Delegate
extension ViewController: ReloadDataDelegate {
    func Reload() {
        LoadFoodInfo()
    }
}

//Delegate them mon an moi
extension ViewController: AddNewFoodDelegate {
    func UpdateUI() {
        //Xoa cache
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        UpdateFoodList()
    }
    
    func DismissWithCondition(_ index: Int) {
        if (index == 0) { //Quay ve man hinh Home
            HomeView.isHidden = false
            HomeButton.tintColor = UIColor.systemGreen
        }
        else if (index == 1) { //Hien thi man hinh them mon an moi
            let dest = self.storyboard?.instantiateViewController(identifier: "AddNewFoodViewController") as! AddNewFoodViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            dest.delegate = self
            self.present(dest, animated: true, completion: nil)
        }
        else { //Hien thi man hinh thuc don mua sam
            let dest = self.storyboard?.instantiateViewController(identifier: "ShoppingListViewController") as! ShoppingListViewController
            dest.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            dest.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            dest.delegate = self
            HomeView.isHidden = true
            self.present(dest, animated: true, completion: nil)
        }
    }
}

//Delegate chon so trang nguoi dung tuy chinh
extension ViewController: ChangeCurrentPagePopUpDelegate {
    func UpdateCurrentPage(index: Int) {
        var temp = view.bounds.width
        //temp < 0 thi animation tu phai sang trai
        //temp > 0 thi animation tu trai sang phai
        if (index < CurrentPage) {
            temp *= -1
        }
        
        //Cap nhat gia tri cho trang hien tai
        CurrentPage = index
        
        //Chon trang lon hon trang hien tai
        if (temp > 0) {
            //Neu dang o trang cuoi cung thi vo hieu hoa 2 nut Next va Last Page
            if (CurrentPage == TotalPage) {
                ChangButtonState(NextPageButton, false)
                ChangButtonState(LastPageButton, false)
            }
            //Active 2 nut Prev va First Page
            if (PrevPageButton.isEnabled == false) {
                ChangButtonState(PrevPageButton, true)
                ChangButtonState(FirstPageButton, true)
            }
        }
        else { //Chon trang nho hon trang hien tai
            //Neu dang o trang dau tien thi vo hieu hoa 2 nut Prev va First Page
            if (CurrentPage == 1) {
                ChangButtonState(PrevPageButton, false)
                ChangButtonState(FirstPageButton, false)
            }
            //Active 2 nut Next va Last Page
            if (NextPageButton.isEnabled == false) {
                ChangButtonState(NextPageButton, true)
                ChangButtonState(LastPageButton, true)
            }
        }
        AnimationChangePage(Width: temp)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == CategoryCollectionView) {
            return CategoryList.count
        }
        else {
            return MealList.count
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Xu ly loai do an
        if (collectionView == CategoryCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
            
            cell.CategoryLabel.text = CategoryList[indexPath.row]
            cell.layer.cornerRadius = 20
            
            if (SelectedCategory[indexPath.row] == true) {
                cell.CategoryLabel.font = UIFont(name: cell.CategoryLabel.font.familyName, size: 20)
                cell.CategoryLabel.backgroundColor = UIColor.systemGreen
                cell.CategoryLabel.textColor = UIColor.white
                cell.layer.borderWidth = 0
            }
            else {
                cell.CategoryLabel.font = UIFont(name: cell.CategoryLabel.font.familyName, size: 17)
                cell.CategoryLabel.backgroundColor = UIColor.white
                cell.CategoryLabel.textColor = UIColor.black
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.gray.cgColor
            }
            
            return cell
        }
        else { //Xu ly bua an
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCell", for: indexPath as IndexPath) as! MealCollectionViewCell
            
            cell.MealLabel.text = MealList[indexPath.row]
            
            if (SelectedMeal[indexPath.row] == true) {
                cell.MealLabel.font = UIFont(name: cell.MealLabel.font.familyName, size: 20)
                cell.MealLabel.textColor = UIColor.black
                cell.DashLabel.isHidden = false
            }
            else {
                cell.MealLabel.font = UIFont(name: cell.MealLabel.font.familyName, size: 17)
                cell.MealLabel.textColor = UIColor.gray
                cell.DashLabel.isHidden = true
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 110, height: 40)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == CategoryCollectionView) {
            //Neu dang duoc chon thi loai bo va nguoc lai
            if (SelectedCategory[indexPath.row] == true) {
                SelectedCategory[indexPath.row] = false
            }
            else {
                SelectedCategory[indexPath.row] = true
            }
            CategoryCollectionView.reloadData()
        }
        else {
            //Neu dang duoc chon thi loai bo va nguoc lai
            if (SelectedMeal[indexPath.row] == true) {
                SelectedMeal[indexPath.row] = false
            }
            else {
                SelectedMeal[indexPath.row] = true
            }
            MealCollectionView.reloadData()
        }
        UpdateFoodList()
    }
}
