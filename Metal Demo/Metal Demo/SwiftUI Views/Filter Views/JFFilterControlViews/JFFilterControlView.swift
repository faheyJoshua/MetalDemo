//
//  JFFilterControlView.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 11/17/20.
//

import SwiftUI

struct JFFilterControlView: View {
    
    let filterID: UUID
    let control: JFFilterControl
    
    var body: some View {
        Group{
            if control.type == .float {
                JFFilterSlider(filterID: filterID, label: control.label, min: control.min ?? 0, max: control.max ?? 1, order: control.order, sliderValue: control.start ?? 0.5)
            } else if control.type == .image {
                JFFilterImage(filterID: filterID, control: control)
            } else {
                Text(control.label)
            }
        }
    }
}

#if DEBUG
struct JFFilterControlView_Previews: PreviewProvider {
    static var previews: some View {
        JFFilterControlView(filterID: UUID(), control: JFFilterItem.example.controls.first!)
    }
}
#endif
