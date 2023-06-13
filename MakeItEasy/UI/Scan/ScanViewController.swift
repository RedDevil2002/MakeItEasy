//
//  CameraScannerViewController.swift
//  Price Change List
//
//  Created by Brian Seo on 2023-05-31.
//


import SwiftUI
import Vision
import VisionKit
import UIKit
import AVKit

struct ScanViewController: UIViewControllerRepresentable {
    @EnvironmentObject var viewModel: DocumentViewModel
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        //Coordinator is Apple bridge between SwiftUI and ViewController
        return Coordinator(viewModel) // this basically call init of the UIViewControllerRepresentable above`
    }
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        @Environment(\.presentationMode) var presentationMode
        @ObservedObject var viewModel: DocumentViewModel
        
        init(_ viewModel: DocumentViewModel) {
            self.viewModel = viewModel
        }
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            guard scan.pageCount > 0 else {
                controller.dismiss(animated: true)
                return
            }
            self.viewModel.scannedImage = scan.imageOfPage(at: 0)
            self.viewModel.scan(scan.imageOfPage(at: 0))
            controller.dismiss(animated: true)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true)
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }
    }
}
