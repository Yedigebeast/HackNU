//
//  ListeningAudioPage.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 13.04.2024.
//

import SwiftUI
import AVFoundation

fileprivate struct Constants {
    struct Images {
        static let buttonBackground = UIImage(named: "buttonBackground")!
    }
}

struct ListeningAudioPage: View {
    @StateObject var dataModel: ModulePageModel
    @Binding var shouldHideCheckButton: Bool
    @Binding var checkButtonPressed: Bool
    
    @State var listeningText = [String]()
    @State var progress: CGFloat = 0.0
    @State var downloadedAudio = false
    @State var text = ""
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Button {
                        playAudio()
                    } label: {
                        ZStack {
                            if downloadedAudio {
                                Image(systemName: "play.circle")
                                    .resizable()
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 64, height: 64)
                    }
                    Spacer()
                        .frame(width: 16)
                    ProgressView("Progress bar", value: progress, total: 1)
                        .labelsHidden()
                }
                .foregroundStyle(.black)
                Spacer()
                    .frame(height: 64)
                TextEditor(text: $text)
                    .navigationTitle("Аудиода қандай текст айтылды?")
                    .frame(height: 300)
                    .cornerRadius(16)
                Spacer()
                    .frame(height: 16)
            }
            .padding(.horizontal)
            if checkButtonPressed {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                    ZStack {
                        VStack {
                            Spacer()
                                .frame(height: 8)
                            HStack {
                                Spacer()
                                    .frame(width: 8)
                                Button {
                                    checkButtonPressed = false
                                    start()
                                } label: {
                                    ZStack {
                                        Image(uiImage: Constants.Images.buttonBackground)
                                        Image(systemName: "goforward")
                                            .foregroundStyle(.black)
                                    }
                                }
                                
                                Spacer()
                                
                                Button {
                                    checkButtonPressed = false
                                } label: {
                                    ZStack {
                                        Image(uiImage: Constants.Images.buttonBackground)
                                        Image(systemName: "xmark")
                                            .foregroundStyle(.black)
                                    }
                                }
                                Spacer()
                                    .frame(width: 8)
                            }
                            Spacer()
                        
                            Button {
                                checkButtonPressed = false
                                putCorrectAnswer()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(red: 0.46, green: 0.46, blue: 0.5))
                                        .opacity(0.12)
                                    VStack {
                                        Text("Жауабын көрсету")
                                            .font(.system(size: 16))
                                    }
                                }
                                .frame(width: 200, height: 32)
                            }

                            Spacer()
                                .frame(height: 16)
                        }
                        Text(checkAnswer() ? "✅" : "❌")
                    }
                }.frame(width: 250, height: 250)
            }
        }
        .onAppear {
            shouldHideCheckButton = false
            dataModel.networkingService.listeningAudioDelegate = self
            start()
        }
    }
    
    private func putCorrectAnswer() {
        text = listeningText.joined(separator: " ")
    }
    
    private func checkAnswer() -> Bool {
        if (text == listeningText.joined(separator: " ")) {
            return true
        }
        return false
    }
    
    private func start() {
        downloadedAudio = false
        listeningText = [String]()
        text = ""
        dataModel.requestRunCount = 0
        performListeningAudioRequest()
    }
    
    private func performListeningAudioRequest() {
        dataModel.requestRunCount += 1
        if (dataModel.requestRunCount >= 5 && listeningText.isEmpty) {
            print("yedige, please turn on the internet")
        } else {
            dataModel.networkingService.getListeningAudio()
        }
    }
    
    private func playAudio() {
        if let audioPlayer = dataModel.audioPlayer {
            audioPlayer.play()
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if !audioPlayer.isPlaying {
                    timer.invalidate()
                }
                progress = CGFloat(audioPlayer.currentTime / audioPlayer.duration)
            }
        } else {
            print("I can not play audio because it is nil")
        }
    }
}

extension ListeningAudioPage: ListeninAudioRequestDelegate {
    func didReceive(text: [String], audioLink: String) {
        print("listening text is:", text)
        self.listeningText = text
        dataModel.networkingService.downloadAudioFileFromURL(urlString: audioLink) { url in
            downloadedAudio = true
            do {
                dataModel.audioPlayer = try AVAudioPlayer(contentsOf: url)
                dataModel.audioPlayer?.prepareToPlay()
                dataModel.audioPlayer?.volume = 1.0
            } catch let error as NSError {
                print(#function, error.localizedDescription)
            } catch {
                print("AVAudioPlayer init failed")
            }
        }
    }
    
    func failWithError(error: any Error) {
        print("ты далбан едіге, ошибка в ListeningAudioPage:, \(error)")
        performListeningAudioRequest()
    }
}
