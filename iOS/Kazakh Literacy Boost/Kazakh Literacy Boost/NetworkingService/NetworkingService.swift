//
//  NetworkingService.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 13.04.2024.
//

import Foundation

class NetworkingService {
    let baseURL = "https://cheap-stew-production.up.railway.app"
    var readingTextDelegate: ReadingTextRequestDelegate? = nil
    var listeningAudioDelegate: ListeninAudioRequestDelegate? = nil
    var speakingMeetingDelegate: SpeakingMeetingRequestDelegate? = nil
    var wordsDelegate: WordsRequestDelegate? = nil
    
}
