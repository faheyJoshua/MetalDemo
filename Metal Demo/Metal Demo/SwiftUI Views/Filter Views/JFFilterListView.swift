//
//  JFFilterView.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 9/27/20.
//

import SwiftUI

struct JFFilterListView: View {
    
    @EnvironmentObject var filterGroup: JFFilterItemGroup
    
    @State var showingAddForm = false
    
    var body: some View {
        VStack{
            ZStack{
                HStack{
                    Button("New Filter"){
                        self.showingAddForm.toggle()
                    }
                    .padding(1)
                    .popover(isPresented: $showingAddForm, content: {
                        JFFilterItemList()
                            .environmentObject(filterGroup)
                    })
                    Spacer()
                }
                HStack{
                    Spacer()
                    Text("Active Filters")
                        .fontWeight(.heavy)
                    Spacer()
                }
            }
            List {
                ForEach(filterGroup.filters) { filter in
                    JFFilterView(filter: filter)
                }
                .onDelete(perform: deleteItems)
                .onMove(perform: moveItems)
            }
            .listStyle(InsetListStyle())
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        filterGroup.filters.remove(atOffsets: offsets)
    }
    
    func moveItems(at offsets: IndexSet, to: Int) {
        filterGroup.filters.move(fromOffsets: offsets, toOffset: to)
    }
}

struct JFFilterListView_Previews: PreviewProvider {
    
    static var group = JFFilterItemGroup()
    
    static var previews: some View {
        JFFilterListView()
            .environmentObject(group)
    }
}
