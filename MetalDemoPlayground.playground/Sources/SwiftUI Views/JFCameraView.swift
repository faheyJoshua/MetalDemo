//
//  JFCameraView.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 9/27/20.
//

import SwiftUI

struct JFCameraView: View {
    
    @ObservedObject var cameraLoader = JFCameraLoader()
    
    @StateObject var filteredLoader = JFImageLoader()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
            if let ciImg = cameraLoader.ciImage{
                JFSwiftUIMetalView(newImage: $filteredLoader.ciImage, ciImage: ciImg)
            } else {
                Image(systemName: "camera")
                    .font(.largeTitle)
            }
        }
        .onDrag({ self.getProvider(image: filteredLoader.ciImage) })
    }
    
    private func getProvider(image: CIImage?) -> NSItemProvider{
        guard let ciImg = image else {
            let emptyProvider = NSItemProvider(item: Data() as NSSecureCoding?, typeIdentifier: kUTTypeData as String)
            return emptyProvider
        }
        let rep = NSCIImageRep(ciImage: ciImg)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)

        let data = nsImage.tiffRepresentation
        let provider = NSItemProvider(item: data as NSSecureCoding?, typeIdentifier: kUTTypeTIFF as String)
        provider.suggestedName = "\(Date()).tiff"
        provider.previewImageHandler = { (handler, classType, _) -> Void in
            print("expected class type \(String(describing: classType))")
            handler?(data as NSSecureCoding?, nil)
        }
        return provider
    }
}

struct JFCameraView_Previews: PreviewProvider {
    static var previews: some View {
        JFCameraView()
    }
}


