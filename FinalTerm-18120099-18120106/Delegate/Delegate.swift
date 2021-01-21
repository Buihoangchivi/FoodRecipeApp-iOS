//
//  Delegate.swift
//  FinalTerm-18120099-18120106
//
//  Created by Bui Van Vi on 12/31/20.
//  Copyright © 2020 Bui Van Vi. All rights reserved.
//

import Foundation

protocol AddNewFoodDelegate: class {
    func UpdateUI()
    func DismissWithCondition(_ index: Int)
}

protocol ChangeCurrentPagePopUpDelegate: class {
    func UpdateCurrentPage(index: Int)
}

protocol DatePickerDalegate: class {
    func TransmitDate(Date date: Date)
}

protocol DetailFoodDelegate: class {
    func Reload()
}

protocol DirectionDelegate: class {
    func SaveChange(List: [String])
}

protocol DirectionPopUpDelegate: class {
    func DirectionProcess(index: Int, content: String)
}

protocol ReloadDataDelegate: class {
    func Reload()
}

protocol IngredientDelegate : class {
    func UpdateIngredient(ingredient: (ID: Int, Name: String, Value: Double, Unit: String))
    func SaveChange()
}

protocol EditFoodDelegate: class {
    func UpdateUI()
}

protocol DeleteFoodDelegate: class {
    func Reload()
}
