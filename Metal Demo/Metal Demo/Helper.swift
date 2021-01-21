//
//  File.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 10/13/20.
//

import Foundation
import SwiftUI

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}


extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}


//extension NSImage: NSItemProviderWriting {
//    public static var writableTypeIdentifiersForItemProvider: [String] {
//        return [kUTTypeData as String, kUTTypeImage as String, kUTTypeTIFF as String]
//    }
//    
//    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
//        let progress = Progress(totalUnitCount: 100)
//        
//        let data = tiffRepresentation
//        
//        let error: Error? = data == nil ? NSError(domain: "Unable to make a tiff of this ns image", code: 0, userInfo: nil) : nil
//        
//        if data != nil {
//            progress.completedUnitCount = 100
//        }
//        
//        completionHandler(data, error)
//        
//        return progress
//    }
//    
//    
//}
