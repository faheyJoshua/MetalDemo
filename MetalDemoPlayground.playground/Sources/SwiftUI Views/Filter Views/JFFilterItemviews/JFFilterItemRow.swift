//
//  JFFilterItemRow.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 11/17/20.
//

import SwiftUI

struct JFFilterItemRow : View {
    
    @EnvironmentObject var filterGroup: JFFilterItemGroup
    
    @Binding var presentationMode: PresentationMode
    
    var item: JFFilterItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.description)
                    .font(.caption)
            }
            
            Spacer()
            
            Button("Add") {
                self.addFilter()
            }
        }
    }
    
    private func addFilter(){
        filterGroup.add(item: item)
        $presentationMode.wrappedValue.dismiss()
    }
}

#if DEBUG
struct JFFilterItemRow_Previews: PreviewProvider {
    
    static var group = JFFilterItemGroup()
    @Environment(\.presentationMode) static var presentationMode
    
    static var previews: some View {
        JFFilterItemRow(presentationMode: presentationMode, item: JFFilterItem.example)
            .environmentObject(group)
    }
}
#endif
