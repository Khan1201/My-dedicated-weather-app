//
//  MailView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/8/23.
//

import SwiftUI
import MessageUI
import Domain

public struct MailView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    
    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["caa789@naver.com"])
        vc.setSubject("<날씨모아> 오류 신고 및 기능 제안")
        let bodyString = """
        
        
        
        
        
        
        
        
        
        
        
        -------------------
        Device Identifier : \(CommonUtil.shared.getDeviceIdentifier())
        Device OS : \(UIDevice.current.systemVersion)
        App Version : \(CommonUtil.shared.getCurrentVersion())
        """
        
        vc.setMessageBody(bodyString, isHTML: false)
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented)
    }
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isPresented: Bool
        
        public init(isPresented: Binding<Bool>) {
            _isPresented = isPresented
        }
        
        public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                isPresented = false
            }
            
            guard error == nil else {
                CommonUtil.shared.printError(
                    funcTitle: "mailComposeController",
                    description: error?.localizedDescription ?? ""
                )
                return
            }
        }
    }
}
