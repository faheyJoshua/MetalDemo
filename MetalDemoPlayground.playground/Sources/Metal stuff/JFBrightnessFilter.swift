//
//  JFBrightnessFilter.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 11/17/20.
//

import CoreImage

class JFBrightnessFilter: CIFilter {
    var inputImage: CIImage?
    var inputBrightness: Float = 0
    
    static var kernel: CIColorKernel = {()-> CIColorKernel in
        let url = Bundle.main.url(forResource: "JFKernels", withExtension: "ci.metallib")!
        let data = try! Data.init(contentsOf: url)
        return try! CIColorKernel(functionName: "JFBrightness", fromMetalLibraryData: data)
    }()
    
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else {return nil}
            return JFBrightnessFilter.kernel.apply(extent: input.extent, arguments: [input, inputBrightness])
        }
    }
}
