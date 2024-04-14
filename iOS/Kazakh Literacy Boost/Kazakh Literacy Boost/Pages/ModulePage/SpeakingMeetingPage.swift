//
//  SpeekingMeetingPage.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 14.04.2024.
//

import SwiftUI
import SafariServices

struct SpeakingMeetingPage: View {
    @StateObject var dataModel: ModulePageModel
    
    @State var meetingLink = ""
    
    var body: some View {
        ZStack {
            if let url = URL(string: meetingLink) {
                SafariWebView(url: url)
                    .ignoresSafeArea()
            } else {
                Spacer()
            }
        }.onAppear {
            dataModel.networkingService.speakingMeetingDelegate = self
            start()
        }
    }
    
    private func start() {
        dataModel.requestRunCount = 0
        performReadingTextRequest()
    }
    
    private func performReadingTextRequest() {
        dataModel.requestRunCount += 1
        if (dataModel.requestRunCount >= 5 && meetingLink.isEmpty) {
            print("yedige, please turn on the internet")
        } else {
            dataModel.networkingService.getSpeakingMeetingLink()
        }
    }
}

fileprivate struct SafariWebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
}

extension SpeakingMeetingPage: SpeakingMeetingRequestDelegate {
    func didReceive(meetingLink: String) {
        DispatchQueue.main.async {
            print("speaking meeting room link is: \(meetingLink)")
            self.meetingLink = meetingLink
        }
    }
    
    func failWithError(error: any Error) {
        print("ты далбан едіге, ошибка в SpeakingMeetingPage: \(error)")
        performReadingTextRequest()
    }
}
