//
//  JFFilter.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 11/17/20.
//

import Foundation



class JFFilter: Identifiable, Equatable {
    static func == (lhs: JFFilter, rhs: JFFilter) -> Bool {
       lhs.id == rhs.id
   }

    let id = UUID()
    let filterItem: JFFilterItem
   
    var values: [String : (Int, Any)] = [:]
   
    
    init(_ item: JFFilterItem){
       filterItem = item
       filterItem.controls.forEach{
           control in
            self.values[control.label] = (control.order, control.startValue ?? 0)
       }
   }
}
