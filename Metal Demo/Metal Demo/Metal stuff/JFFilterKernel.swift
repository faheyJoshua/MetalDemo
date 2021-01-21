//
//  JFFilterKernel.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 11/17/20.
//

import CoreImage

class JFFilterKernel: CIFilter {
    var inputImage: CIImage?
    var kernelName: String = ""
    var inputs: [Any] = []
    
    private static let resizeFilter = CIFilter(name: "CILanczosScaleTransform")
    
    private static var data: Data = {
        let url = Bundle.main.url(forResource: "JFKernels", withExtension: "ci.metallib")!
        return try! Data.init(contentsOf: url)
    }()
    
    private static var kernelNames: [String] {
        get {
            return CIKernel.kernelNames(fromMetalLibraryData: data)
        }
    }
    
    static func getKernel(name: String) -> JFFilterKernel? {
        guard kernelNames.contains(name) else {return nil}
        let kernel = JFFilterKernel()
        kernel.kernelName = name
        
        return kernel
    }
    
    lazy var kernel: CIKernel = {()-> CIKernel in
        return try! CIKernel(functionName: kernelName, fromMetalLibraryData: JFFilterKernel.data)
    }()
    
    func resizeToExtent(_ extent: CGRect){
        guard let filter = JFFilterKernel.resizeFilter else {return}
        for (offset, ciimage) in inputs.enumerated().filter({$0.element is CIImage}).map({($0.offset, $0.element as! CIImage)}){
            filter.setValue(ciimage, forKey: kCIInputImageKey)
            let kernelExtent = ciimage.extent
            let scale = min(extent.width / kernelExtent.width, extent.height / kernelExtent.height)
            filter.setValue(scale, forKey: kCIInputScaleKey)
            inputs[offset] = filter.outputImage!
        }
    }
    
    private func roiCallback(index: Int32, rect: CGRect) -> CGRect{
        return rect
    }
    
    override var outputImage: CIImage? {
        get {
            guard let input = inputImage else {return nil}
            return kernel.apply(extent: input.extent, roiCallback: roiCallback(index:rect:), arguments: [input] + inputs)
        }
    }
}
