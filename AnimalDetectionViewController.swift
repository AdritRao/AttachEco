
import UIKit
import AVKit
import Vision

class AnimalDetectionViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    
    @IBOutlet weak var identifierLabel: UILabel!
    
    var translation = String()
    
//    let identifierLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .white
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        identifierLabel.layer.borderWidth = 1
        identifierLabel.layer.borderColor = UIColor(red: 0.28, green: 0.58, blue: 0.38, alpha: 1.00).cgColor
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        
//        VNImageRequestHandler(cgImage: <#T##CGImage#>, options: [:]).perform(<#T##requests: [VNRequest]##[VNRequest]#>)
        
//        setupIdentifierConfidenceLabel()
    }

    
//    fileprivate func setupIdentifierConfidenceLabel() {
//        view.addSubview(identifierLabel)
//        identifierLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
//        identifierLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        identifierLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        identifierLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("Camera was able to capture a frame:", Date())
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // !!!Important
        // make sure to go download the models at https://developer.apple.com/machine-learning/ scroll to the bottom
        guard let model = try? VNCoreMLModel(for: Animals().model) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            //perhaps check the err
            
//            print(finishedReq.results)
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            
            guard let firstObservation = results.first else { return }
            
            print(firstObservation.identifier, firstObservation.confidence)
            
            DispatchQueue.main.async {
                if firstObservation.identifier == "cane" {
                    self.translation = "dog"
                } else if firstObservation.identifier == "cavallo" {
                    self.translation = "horse"
                } else if firstObservation.identifier == "elefante" {
                    self.translation = "elephant"
                } else if firstObservation.identifier == "farfalla" {
                    self.translation = "butterfly"
                } else if firstObservation.identifier == "gallina" {
                    self.translation = "chicken"
                } else if firstObservation.identifier == "gatto" {
                    self.translation = "cat"
                } else if firstObservation.identifier == "mucca" {
                    self.translation = "cow"
                } else if firstObservation.identifier == "pecora" {
                    self.translation = "sheep"
                } else if firstObservation.identifier == "scoiattolo" {
                    self.translation = "squirrel"
                } else { self.translation = "unknown" }
                self.identifierLabel.text = "\(self.translation) \(firstObservation.confidence * 100)"
            }
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }

}

