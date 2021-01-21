//
//  JFFilterView.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 9/29/20.
//

import SwiftUI

struct JFFilterView: View {
    
    @EnvironmentObject var filterGroup: JFFilterItemGroup
    
    var filter: JFFilter
    
    var body: some View {
        VStack {
            HStack {
                Text(filter.filterItem.name)
                Spacer()
                Button("Remove"){
                    filterGroup.remove(item: filter)
                }
            }
            .frame(minHeight: 30, maxHeight: 30)
            .padding(.horizontal, 10)
            
            ForEach(filter.filterItem.controls, id: \.self.label) { control in
                JFFilterControlView(filterID: filter.id, control: control)
                    .frame(minHeight: getHeight(type:control.type), maxHeight: getHeight(type:control.type))
                    .padding(.horizontal, 10)
            }
        }
        .help(filter.filterItem.tip)
        .border(Color.black)
    }
    
    private func getHeight(type: JFFilterControl.ControlType) -> CGFloat{
        switch type {
        case .float:
            return 30
        case.image:
            return 65
        }
    }
}

#if DEBUG
struct JFFilterView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            JFFilterView(filter: JFFilter(JFFilterItem.example))
            JFFilterView(filter: JFFilter(JFFilterItem.example2))
        }
    }
}
#endif
