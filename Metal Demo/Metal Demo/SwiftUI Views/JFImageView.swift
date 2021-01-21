//
//  JFImageView.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 9/27/20.
//

import SwiftUI

struct JFImageView: View {
    
    @EnvironmentObject var saveMenu: SaveMenu
    
    @ObservedObject var imageLoader = JFImageLoader()
    
    @State var document: ImageDocument = ImageDocument(image: nil)
    
    @State var loadingFile = false
    
    private let dropIds = ["public.file-url", "public.url"]
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .onTapGesture {
                        self.loadingFile = true
                    }
                    .fileImporter(
                        isPresented: $loadingFile,
                        allowedContentTypes: [.image],
                        allowsMultipleSelection: false
                    ) { result in
                        guard let selectedFile: URL = try? result.get().first else { return }
                        self.imageLoader.loadImage(with: selectedFile)
                    }
                if let ciImg = imageLoader.ciImage{
                    JFSwiftUIMetalView(newImage: $document.ciImage, ciImage: ciImg)
                } else {
//                    JFSwiftUIMetalView(ciImage: nil)
                    Image(systemName: "photo")
                        .font(.largeTitle)
                }
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button("Save"){
                            saveMenu.isSaving = true
                        }
                        .padding(10)
                    }
                }
            }
            .help("Click or drop an image")
            .onDrag({ self.getProvider(image: document.ciImage) })
            .fileExporter(isPresented: $saveMenu.isSaving,
                          document: document,
                          contentType: .tiff,
                          defaultFilename: "DemoImage.tiff") {
                (result) in
                if case .success = result {
                    // Handle success.
                } else {
                    // Handle failure.
                }
            }
        }
        .onDrop(of: dropIds, isTargeted: nil){
            (providers: [NSItemProvider]) -> Bool in
            
            for dropId in dropIds {
                if let item = providers.first(where: {$0.hasItemConformingToTypeIdentifier(dropId)}) {
                    item.loadItem(forTypeIdentifier: dropId, options: nil){ (urlData, error) in
                        DispatchQueue.main.async {
                            if let urlData = urlData as? Data{
                                let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                                self.imageLoader.loadImage(with: url)
                            }
                        }
                    }
                    return true
                }
            }
            return false
        }
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

struct JFImageView_Previews: PreviewProvider {
    static var previews: some View {
        JFImageView()
    }
}
