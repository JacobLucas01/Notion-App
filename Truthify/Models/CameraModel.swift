//
//  RecordView.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/7/23.
//

import SwiftUI
import AVFoundation

class CameraModel: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    
    @Published var session = AVCaptureSession()
    @Published var videoOutput = AVCaptureMovieFileOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var previewURL: URL?
    @Published var showPreview: Bool = false
    @Published var recordedDuration: CGFloat = 0
    @Published var maxDuration: CGFloat = 60
    
    @Published var alert: Bool = false
    @Published var isRecording: Bool = false
    @Published var recordingURLs: [URL] = []
    
    func checkCameraPermissions() {
        
        let permissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch (permissionStatus) {
        case .authorized:
            setUpCamera()
            return
        case .notDetermined:
            requestCameraAccess()
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { (status) in
            if status {
                self.setUpCamera()
            }
        }
    }
    
    func setUpCamera() {
        do {
            
            self.session.beginConfiguration()
            let cameraDevice = AVCaptureDevice.default(for: .video)
            let cameraInput = try AVCaptureDeviceInput(device: cameraDevice!)
            let audioDevice = AVCaptureDevice.default(for: .audio)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice!)
            
            if self.session.canAddInput(cameraInput) && self.session.canAddInput(audioInput) {
                self.session.addInput(cameraInput)
                self.session.addInput(audioInput)
            }
            
            if  self.session.canAddOutput(videoOutput) {
                self.session.addOutput(videoOutput)
            }
            
            self.session.commitConfiguration()
            
        } catch {
            print("Error setting up camera.")
            print(error.localizedDescription)
        }
    }
    
    func startRecording() {
        let tempURL = NSTemporaryDirectory() + "\(Date()).mov"
        videoOutput.startRecording(to: URL(fileURLWithPath: tempURL), recordingDelegate: self)
        isRecording = true
    }
    
    func stopRecording() {
        videoOutput.stopRecording()
        self.isRecording = false
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print(outputFileURL)
        self.recordingURLs.append(outputFileURL)
        if self.recordingURLs.count == 1 {
            self.previewURL = outputFileURL
            return
        }
    }
}
    
    //    func takePicture() {
    //
    //        DispatchQueue.global(qos: .background).async {
    //            self.cameraOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    //            self.session.stopRunning()
    //
    //            DispatchQueue.main.async {
    //                withAnimation {
    //                    self.isTaken.toggle()
    //                }
    //            }
    //        }
    //
    //    }
    //
    //    func retakePicture() {
    //
    //        DispatchQueue.global(qos: .background).async {
    //            self.session.startRunning()
    //
    //            DispatchQueue.main.async {
    //                self.isTaken.toggle()
    //            }
    //        }
    //
    //    }
    
    //    func savePicture() {
    //        let image = UIImage(data: self.pictureData)!
    //
    //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    //        print("Image saved successfully.")
    //
    //        self.isSaved = true
    //    }
    
    struct CameraPreview: UIViewRepresentable {
        
        @EnvironmentObject var camera: CameraModel
        
        func makeUIView(context: Context) -> UIView {
            
            let view = UIView(frame: UIScreen.main.bounds)
            camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
            camera.preview.frame = view.frame
            camera.preview.videoGravity = .resizeAspectFill
            view.layer.addSublayer(camera.preview)
            
            camera.session.startRunning()
            
            return view
            
        }
        
        func updateUIView(_ uiView: UIView, context: Context) {
            
        }
    }
