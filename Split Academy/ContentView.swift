//
//  ContentView.swift
//  Split Academy
//
//  Created by Manuel Lotti on 21/03/23.
//

//
//  ContentView.swift
//  Split Academy
//
//  Created by Manuel Lotti on 21/03/23.
//

import SwiftUI
import WebKit
import AVFoundation


struct ContentView: View {
    @State private var showWebView = false
    private let urlString1: String = "https://splitacademy.root8tech.com/"
    private let urlString2: String = "https://splitacademy.root8tech.com/register"
   // private let urlString3: String = "https://splitacademy.root8tech.com/time-table"
    
    @State private var showScanner = false
    
    
    // Color(red: 172, green: 145, blue: 206) // HEX AC91CE
    let mainColor = UIColor(
        red: CGFloat(0xAC) / 255.0,
        green: CGFloat(0x91) / 255.0,
        blue: CGFloat(0xCE) / 255.0,
        alpha: 1.0
    )
    
    
        var body: some View {

           ZStack {
                
                Color(mainColor)
                .edgesIgnoringSafeArea(.top)
                Color.black
                .edgesIgnoringSafeArea(.bottom)
               
               
            VStack {
                
                TabView {
                   WebView(url: URL(string: urlString1)!).frame(maxWidth: .infinity, maxHeight: .infinity)
                                .tabItem {
                                    Image(systemName: "house")
                                    Text("Desk")
                                }
                            
                   WebView(url: URL(string: urlString2)!).frame(maxWidth: .infinity, maxHeight: .infinity)
                                .tabItem {
                                    Image(systemName: "person.crop.circle")
                                    Text("Register")
                                }
                            
                    QRScannerView()
                                .tabItem {
                                    Image(systemName: "qrcode")
                                    Text("Evaluation")
                                }
                    
                    
                        }


              // Normal WebView
             
                    //.shadow(color: .black.opacity(0.3), radius: 20.0, x: 5, y: 5)

                /*
                
                // Create a link that opens in a new window
                Link(destination: URL(string: urlString)!, label: {
                    Text("Open in new window")
                        .foregroundColor(.blue)
                })
                
                 
                // Present WebView as a Bottom Sheet
                Button {
                    showWebView.toggle()
                } label: {
                    Text("Open in a sheet")
                }
                .sheet(isPresented: $showWebView) {
                    WebView(url: URL(string: urlString)!)
                }
                Spacer()
                 
                 */
                
                // other views here
                                
                

             } //V
               
        } //Z
            
        

    }

    // WebView Struct
    struct WebView: UIViewRepresentable {
        
        var url: URL
        
        func makeUIView(context: Context) -> WKWebView {
            return WKWebView()
        }
        
        func updateUIView(_ webView: WKWebView, context: Context) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }


    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

}

struct QRScannerView: View {
    @State private var isPresentingCameraView = false
    @State private var scannedText: String?
    @State private var showWebView2 = false
    
    
    
    var body: some View {
        VStack {
            if let text = scannedText {
                Text("Scanned Text: \(text)")
                
                
                Link(destination: URL(string: text)!, label: {
                    Text("Open in new window")
                        .foregroundColor(.blue)
                })
                
     
               
                
            } else {
                Button(action: {
                    isPresentingCameraView = true
                }) {
                    Text("Scan QR Code")
                }
            }
        }
        .sheet(isPresented: $isPresentingCameraView) {
            ScannerView(scannedText: $scannedText)
        }
    }
}

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedText: String?
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let scannerViewController = ScannerViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannedText: $scannedText)
    }
    
    class Coordinator: NSObject, ScannerViewControllerDelegate {
        @Binding var scannedText: String?
        
        init(scannedText: Binding<String?>) {
            _scannedText = scannedText
        }
        
        func didScanText(text: String) {
            scannedText = text
        }
    }
}

protocol ScannerViewControllerDelegate: AnyObject {
    func didScanText(text: String)
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    weak var delegate: ScannerViewControllerDelegate?
    let session = AVCaptureSession()
    let output = AVCaptureMetadataOutput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            print(error.localizedDescription)
            return
        }
        
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = [.qr]
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metadataObject = metadataObjects.first else {
            return
        }
        
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        guard let stringValue = readableObject.stringValue else {
            return
        }
        
        session.stopRunning()
        delegate?.didScanText(text: stringValue)
    }
}
