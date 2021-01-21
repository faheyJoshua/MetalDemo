//
//  JFFilterSlider.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 11/17/20.
//

import SwiftUI

struct JFFilterSlider: View {
    
    @EnvironmentObject var filterGroup: JFFilterItemGroup
    
    let filterID: UUID
    let label: String
    let min: Float
    let max: Float
    let order: Int
    
    @State var sliderValue: Float
    
    var body: some View {
        Slider(value: $sliderValue.onChange(sliderChanged(_:)),
               in: min...max,
               minimumValueLabel: {
            Text("\(min, specifier: "%.1f")")
        }(), maximumValueLabel: {
            Text("\(max, specifier: "%.1f")")
        }()) {
            Text("\(label): \(sliderValue, specifier: "%.2f")")
        }
    }
    
    private func sliderChanged(_ newValue: Float){
        filterGroup.filterValues[filterID]?[label] = (order, newValue)
        filterGroup.update(id: filterID)
    }
}

#if DEBUG
struct JFFilterSlider_Previews: PreviewProvider {
    
    static var group = JFFilterItemGroup()
    
    static var previews: some View {
        let control = JFFilterItem.example.controls.first!
        return JFFilterSlider(filterID: UUID(), label: control.label, min: control.min!, max: control.max!, order: control.order, sliderValue: control.start!)
            .environmentObject(group)
    }
}
#endif
