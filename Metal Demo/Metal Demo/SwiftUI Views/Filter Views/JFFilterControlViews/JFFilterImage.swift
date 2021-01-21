//
//  JFFilterImage.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 11/17/20.
//

import SwiftUI

struct JFFilterImage: View {
    
    @EnvironmentObject var filterGroup: JFFilterItemGroup
    
    @ObservedObject var imageLoader = JFImageLoader()
    
    @State var image: NSImage?
    @State var loadingFile = false
    
    private let dropIds = ["public.file-url", "public.url"]
    
    let filterID: UUID
    let control: JFFilterControl
    //fibkasnYqvanceqpo0
    var body: some View {
        HStack{
            Spacer()
            Text(control.label)
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(imageLoader.ciImage == nil ? Color.yellow.opacity(0.3) : Color.green.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .frame(minWidth: 10, maxWidth: 50, minHeight: 10, maxHeight: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                if let nsImg = image {
//                    JFSwiftUIMetalView(ciImage: ciImg)
                    Image(nsImage: nsImg)
                        .resizable()
                        .frame(minWidth: 10, maxWidth: 50, minHeight: 10, maxHeight: 50)
                        .aspectRatio(contentMode: .fit)
                        .mask(
                            RoundedRectangle(cornerRadius: 20)
                        )
                } else {
                    Image(systemName: "photo")
                        .font(.largeTitle)
                }
            }
            .help("Click or drop an image")
            .onTapGesture {
                self.loadingFile = true
            }
            .onDrop(of: ["public.file-url", "public.url"], isTargeted: nil){
                (providers: [NSItemProvider]) -> Bool in
                
                for dropId in dropIds {
                    if let item = providers.first(where: {$0.hasItemConformingToTypeIdentifier(dropId)}) {
                        item.loadItem(forTypeIdentifier: dropId, options: nil){ (urlData, error) in
                            DispatchQueue.main.async {
                                if let urlData = urlData as? Data{
                                    let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                                    self.imageLoader.loadImage(with: url){
                                        self.imageChanged()
                                    }
                                }
                            }
                        }
                        return true
                    }
                }
                return false
            }
            .fileImporter(
                isPresented: $loadingFile,
                allowedContentTypes: [.image],
                allowsMultipleSelection: false
            ) { result in
                guard let selectedFile: URL = try? result.get().first else { return }
                self.imageLoader.loadImage(with: selectedFile){
                    self.imageChanged()
                }
            }
        }
    }
    
    private func imageChanged(){
        filterGroup.filterValues[filterID]?[control.label] = (control.order, imageLoader.ciImage ?? 0)
        filterGroup.update(id: filterID)
        if let ciImg = imageLoader.ciImage {
        let rep = NSCIImageRep(ciImage: ciImg)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
            image = nsImage
        }
    }
    
}

#if DEBUG
struct JFFilterImage_Previews: PreviewProvider {
    static var group = JFFilterItemGroup()
    
    static var previews: some View {
        let control = JFFilterItem.example2.controls.first!
        return JFFilterImage(filterID: UUID(), control: control)
            .environmentObject(group)
    }
}
#endif
