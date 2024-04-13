//
//  NetworkingService+ListeningAudio.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 13.04.2024.
//

import Foundation

protocol ListeninAudioRequestDelegate {
    func didReceive(text: [String], audioLink: String)
    func failWithError(error: Error)
}

extension NetworkingService {
    func downloadAudioFileFromURL(urlString: String,  audioURL: @escaping ((URL) -> ())) {
        if let url = URL(string: urlString){
            let task = URLSession.shared.downloadTask(with: url) { [audioURL] newAudioURL, response, error in
                if let error {
                    print(#function, "error: \(error)")
                }
                if let newAudioURL {
                    audioURL(newAudioURL)
                }
            }
            task.resume()
        }
    }
    
    func getListeningAudio() {
        let url = "\(baseURL)/listening/audio"
        performListeningAudioRequest(with: url)
    }
    
    private func performListeningAudioRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error {
                    self.listeningAudioDelegate?.failWithError(error: error)
                    return
                }
                if let safedata = data {
                    let (text, audio) = self.parseListeningAudioJson(safedata)
                    if let text, let audio {
                        self.listeningAudioDelegate?.didReceive(text: text, audioLink: audio)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseListeningAudioJson(_ data: Data) -> ([String]?, String?) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(audioData.self, from: data)
            return (decodedData.text, decodedData.audio)
        } catch {
            self.listeningAudioDelegate?.failWithError(error: error)
            return (nil, nil)
        }
    }
}

fileprivate struct audioData: Decodable {
    var text: [String]
    var audio: String
}
