//
//  JFFilterModels.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 10/13/20.
//

import Foundation

struct JFFilterSection: Codable, Identifiable {
    let id: String
    let name: String
    let items: [JFFilterItem]
}

struct JFFilterItem: Codable, Equatable, Identifiable {
    let id: String
    let name: String
    let kernel: String
    let description: String
    let tip: String
    let controls: [JFFilterControl]
    
    #if DEBUG
    static let example = JFFilterItem(id: "TEST", name: "Brightness", kernel: "JFBrightness", description: "brightening stuff", tip: "brightens stuff", controls: [JFFilterControl(type: .float, label: "Brightness:", order: 0, min: 0, max: 1, start: 0.5)])
    static let example2 = JFFilterItem(id: "TEST", name: "Blend", kernel: "JFBrightness", description: "blending stuff", tip: "brightens stuff", controls: [JFFilterControl(type: .image, label: "Blend:", order: 0, min: 0, max: 1, start: 0.5)])
    #endif
}

struct JFFilterControl: Codable, Equatable {
    let type: ControlType
    let label: String
    
    let order: Int
   
    enum ControlType: String, Codable {
       case float
       case image
   }
   
    let min: Float?
    let max: Float?
    let start: Float?
   
    var startValue: Any? {
       switch type {
       case .float:
           return start
       default:
           return nil
       }
   }
}
