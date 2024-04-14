//
//  NetworkingService+Speaking.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 14.04.2024.
//

import Foundation

protocol SpeakingMeetingRequestDelegate {
    func didReceive(meetingLink: String)
    func failWithError(error: Error)
}

extension NetworkingService {
    func getSpeakingMeetingLink() {
        let url = "\(baseURL)/speaking/gogo"
        performSpeakingRequest(with: url)
    }
    
    private func performSpeakingRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error {
                    self.speakingMeetingDelegate?.failWithError(error: error)
                    return
                }
                if let safedata = data {
                    if let meetingLink = self.speakingMeetingJson(safedata) {
                        self.speakingMeetingDelegate?.didReceive(meetingLink: meetingLink)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    private func speakingMeetingJson(_ data: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SpeakingMeetingData.self, from: data)
            return decodedData.meeting_link
        } catch {
            self.speakingMeetingDelegate?.failWithError(error: error)
            return nil
        }
    }
}

fileprivate struct SpeakingMeetingData: Decodable {
    var meeting_link: String
}


