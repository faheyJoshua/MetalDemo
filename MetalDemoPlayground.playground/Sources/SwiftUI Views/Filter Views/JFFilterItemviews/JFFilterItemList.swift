//
//  JFFilterItemViews.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 10/13/20.
//

import SwiftUI

struct JFFilterItemList: View {
    
    @EnvironmentObject var filterGroup: JFFilterItemGroup
    @Environment(\.presentationMode) var presentationMode
    
    let filters = Bundle.main.decode([JFFilterSection].self, from: "filters.json")//FILTERDATA.filterJSON.decode([JFFilterSection].self)
    
    var body: some View {
        List {
            ForEach(filters) { section in
                Section(header: Text(section.name)) {
                    ForEach(section.items) { item in
                        JFFilterItemRow(presentationMode: self.presentationMode, item: item)
                            .environmentObject(filterGroup)
                    }
                }
            }
        }
        .listStyle(DefaultListStyle())
    }
}

struct JFFilterItemListView_Previews: PreviewProvider {
    
    static var group = JFFilterItemGroup()
    
    static var previews: some View {
        JFFilterItemList()
            .environmentObject(group)
    }
}
