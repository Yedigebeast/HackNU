//
//  ListeningAudioPage.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 13.04.2024.
//

import SwiftUI
import AVFoundation

struct ListeningAudioPage: View {
    @StateObject var dataModel: ModulePageModel
    
    var player: AVPlayer?

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("au brat")
                Spacer()
            }
        }
        .onAppear {
            dataModel.networkingService.listeningAudioDelegate = self
            start()
        }
    }
    
    private func start() {
        dataModel.requestRunCount = 0
        performListeningAudioRequest()
    }
    
    private func performListeningAudioRequest() {
        dataModel.requestRunCount += 1
//        if (dataModel.requestRunCount >= 5) {
//            print("yedige, please turn on the internet")
//        } else {
            dataModel.networkingService.getListeningAudio()
//        }
    }
    
    private mutating func play(urlString : String) {
        guard let url = URL(string: urlString) else { return }
        print("playing \(url)")
        let playerItem = AVPlayerItem(url: url)

        self.player = AVPlayer(playerItem: playerItem)
        player!.volume = 1.0
        player!.play()
    }
}

extension ListeningAudioPage: ListeninAudioRequestDelegate {
    func didReceive(text: [String], audioLink: String) {
        print(text, audioLink)
    }
    
    func failWithError(error: any Error) {
        print("ты далбан едіге, ошибка в ListeningAudioPage:, \(error)")
        performListeningAudioRequest()
    }
}

#Preview {
    ListeningAudioPage(
        dataModel: ModulePageModel(
            module: .listening,
            router: Router(navigationController: UINavigationController()),
            networkingService: NetworkingService()
        )
    )
}
