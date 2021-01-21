//
//  JFFilterItemGroup.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 10/13/20.
//

import Foundation
import CoreImage

public class JFFilterItemGroup: ObservableObject {
    @Published var filters = [JFFilter]()
    @Published var filterValues: [UUID : [String : (Int, Any)]] = [:]
     
    private var kernels: [UUID: JFFilterKernel] = [:]
    
    private var extent: CGRect = CGRect(x: 1, y: 1, width: 1, height: 1)
    
    var lastRunImage: CIImage?
    
    public init(){}
    
    func add(item: JFFilterItem) {
        let newFilter = JFFilter(item)
        filters.append(newFilter)
        filterValues[newFilter.id] = newFilter.values


        if let kernel = JFFilterKernel.getKernel(name: item.kernel) {
            let inputs = newFilter.values.map({(name: $0.key, value: $0.value.1, order: $0.value.0)}).sorted(by: {$0.order < $1.order})
            kernel.inputs = inputs.map({$0.value})
            kernels[newFilter.id] = kernel
        }
    }
    
    func update(id: UUID){
        if let kernel = kernels[id],
           let values = filterValues[id]?.map({(name: $0.key, value: $0.value.1, order: $0.value.0)}).sorted(by: {$0.order < $1.order}){
            kernel.inputs = values.map({$0.value})
            kernel.resizeToExtent(extent)
        }
    }
    
    func runImage(_ ciimage: CIImage) -> CIImage {
        let newExtent = ciimage.extent
        let changeImages = newExtent != extent
        extent = newExtent
        let orderedKernels = filters.compactMap({self.kernels[$0.id]})
        
        var output = ciimage
        
        for filter in orderedKernels {
            filter.inputImage = output
            if changeImages {
                filter.resizeToExtent(newExtent)
            }
            output = filter.outputImage ?? output
        }
        lastRunImage = output
        return output
    }
    
    func remove(item: JFFilter) {
        if let index = filters.firstIndex(of: item) {
            filters.remove(at: index)
            filterValues[item.id] = nil
            kernels[item.id] = nil
        }
    }
}
