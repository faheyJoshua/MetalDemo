//
//  JFImageLoader.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 11/17/20.
//

import AVFoundation
import CoreImage


class JFImageLoader: ObservableObject {
    
    @Published var ciImage: CIImage?

    func loadImage(with url: URL, _ closure: (()->())? = nil) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let ciImage = CIImage(contentsOf: url)
            DispatchQueue.main.async { [weak self] in
                self?.ciImage = ciImage
                closure?()
            }
        }
    }
}
