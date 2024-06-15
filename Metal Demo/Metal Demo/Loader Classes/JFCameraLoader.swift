//
//  JFCameraLoader.swift
//  Metal Demo
//
//  Created by Joshua Fahey on 11/17/20.
//

import AVFoundation
import CoreImage


class JFCameraLoader: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @Published var ciImage: CIImage?
    
    private var captureSession = AVCaptureSession()
    
    
    override init() {
        super.init()
        setupCamera()
    }
    
    
    private func setupCamera(){
        captureSession.beginConfiguration()
        if captureSession.canSetSessionPreset(.photo) {
            captureSession.sessionPreset = .photo
        }
        
        setupInputs()
        
        setupOutput()
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    
    private func setupInputs(){
        //get front camera
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
           let input = try? AVCaptureDeviceInput(device: device),
           captureSession.canAddInput(input){
            captureSession.addInput(input)
        }
    }
    
    private func setupOutput(){
        let videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            fatalError("could not add video output")
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        //get a CIImage out of the CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        //filter it
//        guard let filteredCIImage = applyFilters(inputImage: ciImage) else {
//            return
//        }
        
        
        DispatchQueue.main.async {
            self.ciImage = ciImage
        }
    }
}
