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
//        NavigationView {
            HStack{
                Button("+"){
                    self.showingAddForm.toggle()
//                    self.filterGroup.add(item: JFFilterItem.example)
                }
                .padding(1)
                .popover(isPresented: $showingAddForm, content: {
                    JFFilterItemList()
                        .environmentObject(filterGroup)
                        .frame(minWidth:400)
                })
                Spacer()
            }
            List {
                Section {
                    ForEach(filterGroup.filters) { filter in
                        JFFilterView(filter: filter)
                    }
                    .onDelete(perform: deleteItems)
                    .onMove(perform: moveItems)
                }
            }
//            .navigationBarTitle("Active Filters")
            .listStyle(PlainListStyle())
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
