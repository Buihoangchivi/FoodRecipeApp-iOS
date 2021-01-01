//
//  Method.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/31/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import Foundation
import UIKit

//Chuyển ngày sang dạng chuỗi
func DateToString(_ date: Date, _ format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

//Chuyen thanh chuoi ASCII va xoa ki tu khoang trang trong chuoi
func GetCustomizedString(_ string: String) -> String {
    var result = string.folding(options: .diacriticInsensitive, locale: .current)
    result = result.replacingOccurrences(of: " ", with: "").lowercased()
    //Chuyen thu cong chu đ thanh chu d
    result = result.replacingOccurrences(of: "đ", with: "d")
    return result
}

//Kiểm tra chuỗi UTF-8 có chứa một chuỗi con UTF-8 hay không
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

//Tìm chuỗi ban đầu dạng UTF-8 của chuỗi con ASCII trong chuỗi gốc
func GetOriginSubstring(_ mainString: String, _ subString: String) -> String {
    //Neu chuoi can tim la rong thi tra ve chuoi rong
    if (subString == "") {
        return ""
    }
    //Chuyen chuoi con can tim thanh chuoi ASCII khong co ki tu khoang trang
    var str = "", mainChar = "", subChar = "", subStringTemp = GetCustomizedString(subString)
    var mainStringIndex, subStringIndex: String.Index
    var subIndex = 0, mainIndex = 0
    var check = false
    while mainIndex < mainString.count {
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
                //Xet tu ki tu hien tai
                mainIndex -= 1
            }
        }
        
        //Neu da du so ki tu thi tra va tra ve chuoi str
        if (subIndex == subStringTemp.count) {
            return str
        }
        
        //Tang bien dem mainIndex len 1 don vi
        mainIndex += 1
    }
    //Truong hop chuoi chinh khong chua chuoi con thi tra ve chuoi rong
    return ""
}

//Trả về chuỗi được định dạng sau khi thay đổi màu sắc cho chuỗi con trong chuỗi chính
func AttributedStringWithColor(_ mainString: String, _ string: String, color: UIColor) -> NSAttributedString {
    
    //Lay chuoi 'string' voi dinh dang giong nhu trong 'mainString'
    let subString = GetOriginSubstring(mainString, string)
    
    //Thay doi mau cho chuoi con trong ten mon an trung voi chuoi tim kiem
    let attributedString = NSMutableAttributedString(string: mainString)
    let range = (mainString as NSString).range(of: subString)
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

    return attributedString
}

//Kiem tra ten nguoi dung co ton tai hay chua
func CheckIfUsernameIsExist (_ username: String) -> Bool {
    var result = false
    return result
}

//Kiem tra chuoi co chua toan cac ky tu trong bang ma ASCII hay khong
extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

//Padding cho TextField
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
