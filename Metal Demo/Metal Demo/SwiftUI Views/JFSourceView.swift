//
//  JFSourceView.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 9/27/20.
//

import SwiftUI
import AVFoundation

struct JFSourceView: View {
    
    var body: some View {
            VStack{
                HStack {
                    Spacer()
                    Text("Source Media")
                        .fontWeight(.heavy)
                    Spacer()
                }
                TabView{
                    JFImageView()
                        .tabItem {
                            Image(systemName: "1.square.fill")
                            Text("Image")
                        }
                    
                    JFCameraView()
                        .tabItem {
                            Image(systemName: "1.square.fill")
                            Text("Camera")
                        }
                }
            }
    }
}

struct JFSourceView_Previews: PreviewProvider {
    static var group = JFFilterItemGroup()
    
    static var previews: some View {
        JFSourceView()
            .environmentObject(group)
    }
}
