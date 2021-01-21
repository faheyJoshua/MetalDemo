//
//  JFMetalView.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 9/27/20.
//

import SwiftUI
import MetalKit

//#if defined(TARGET_IOS) || defined(TARGET_TVOS)
//import UIKit
//struct JFSwiftUIMetalView: UIViewRepresentable {
//    let ciImage: CIImage?
//
//    func makeUIView(context: Context) -> MTKView {
//        let metalView = MTKView()
//        metalView.delegate = context.coordinator
//        metalView.device = context.coordinator.device
//        metalView.clearColor = MTLClearColorMake(0, 0.5, 1, 1)
//
//        metalView.framebufferOnly = false
//        return metalView
//    }
//
//    func updateUIView(_ uiView: MTKView, context: Context) {
//        context.coordinator.currentCIImage = ciImage
//    }
//}
//#else
import AppKit
struct JFSwiftUIMetalView: NSViewRepresentable {
    
    @EnvironmentObject var filterGroup: JFFilterItemGroup
    
    @Binding var newImage: CIImage?
    
    let ciImage: CIImage?
    
    func makeNSView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.delegate = context.coordinator
        metalView.device = context.coordinator.device
        
        context.coordinator.updateImage = updateImage(image:)

        metalView.framebufferOnly = false
        return metalView
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
        context.coordinator.currentCIImage = ciImage
        context.coordinator.filterGroup = filterGroup
    }
    
    func updateImage(image: CIImage) {
        newImage = image
    }
}
//#endif

extension JFSwiftUIMetalView {
    class Coordinator: NSObject, MTKViewDelegate {
        
        let device: MTLDevice?
        let commandQueue: MTLCommandQueue?
        let ciContext: CIContext?
        
        var filterGroup: JFFilterItemGroup?
        
        var currentCIImage: CIImage?
        var lastImage: CIImage?
        
        var updateImage: ((CIImage)->())?
        
        init(device d: MTLDevice?) {
            device = d
            commandQueue = device?.makeCommandQueue()
            ciContext = device == nil ? nil : CIContext(mtlDevice: device!)
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            
        }
        
        func draw(in view: MTKView) {
            guard let renderPassDescriptor = view.currentRenderPassDescriptor else {return}
            if let commandBuffer = commandQueue?.makeCommandBuffer(),
               let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
                commandEncoder.endEncoding()

                if let drawable = view.currentDrawable {
                    if let ciimg = currentCIImage,
                       let ciImage = filterGroup?.runImage(ciimg){
                        updateImage?(ciImage)
                        var transform = CGAffineTransform.identity
                        
                        let (xScale, yScale) = (view.drawableSize.width / ciImage.extent.width,
                                                view.drawableSize.height / ciImage.extent.height)
                        let scale = xScale < yScale ? xScale : yScale
                        transform = transform.scaledBy(x: scale, y: scale)
                        let newImg = ciImage.transformed(by: transform)
                        
                        let yOffsetFromBottom = (view.drawableSize.height - newImg.extent.height)/2
                        let xOffsetFromBottom = (view.drawableSize.width - newImg.extent.width)/2
                        
                        ciContext?.render(newImg,
                                         to: drawable.texture,
                              commandBuffer: commandBuffer,
                              bounds: CGRect(origin: CGPoint(x: -xOffsetFromBottom, y: -yOffsetFromBottom), size: view.drawableSize),
                                 colorSpace: CGColorSpaceCreateDeviceRGB())
                    }
                    commandBuffer.present(drawable)
                }
                commandBuffer.commit()
            }
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(device: MTLCreateSystemDefaultDevice())
    }
}

