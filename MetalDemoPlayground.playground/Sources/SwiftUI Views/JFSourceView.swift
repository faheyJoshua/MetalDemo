//
//  JFSourceView.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 9/27/20.
//

import SwiftUI
import AVFoundation

struct JFSourceView: View {
    
    enum Sources: Int {
        case image = 0
        case camera
    }
    
    @State var sourceID: Sources = .image
    
    var body: some View {
            VStack{
                
                switch sourceID {
                case .image:
                    JFImageView()
                case .camera:
                    JFCameraView()
                }
                
                HStack{
                    Button(action: {switchSource(.image)}) {
                        Text("Image")
                    }
                    Button(action: {switchSource(.camera)}) {
                        Text("Camera")
                    }
                }
            }
//            .onDrag{
//                getImage()
//            }
    }
    

    
    private func checkAuthorization() -> Bool{
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                return true
            
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        sourceID = .camera
                    }
                }
                return false
            default:
                return false
        }
    }
    
    private func switchSource(_ newSource: Sources){
        guard sourceID != newSource else {return}
        
        if newSource == .camera && !checkAuthorization() {
            return
        }
        
        sourceID = newSource
    }
}

struct JFSourceView_Previews: PreviewProvider {
    static var group = JFFilterItemGroup()
    
    static var previews: some View {
        JFSourceView()
            .environmentObject(group)
    }
}
