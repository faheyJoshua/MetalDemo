//
//  ImageDocument.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 1/21/21.
//

import SwiftUI
import UniformTypeIdentifiers


class ImageDocument: FileDocument {
    
    static var readableContentTypes: [UTType] { [.tiff] }

    @Published var ciImage: CIImage? {
        didSet {
            imageData = getData(image: ciImage)
        }
    }
    
    var imageData: Data?

    init(image: CIImage?) {
        ciImage = image
        imageData = getData(image: image)
    }
    
    private func getData(image: CIImage?) -> Data? {
        guard let img = image else {return nil}
        let rep = NSCIImageRep(ciImage: img)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)

        return nsImage.tiffRepresentation
    }

    required init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        imageData = data
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: imageData ?? Data())
    }
    
}
