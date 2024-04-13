//
//  NetworkingService+ReadingText.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 13.04.2024.
//

import Foundation

protocol ReadingTextRequestDelegate {
    func didReceive(readingText: [String])
    func failWithError(error: Error)
}

extension NetworkingService {
    func getReadingText() {
        let url = "\(baseURL)/reading/text"
        performReadingTextRequest(with: url)
    }
    
    private func performReadingTextRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error {
                    self.readingTextDelegate?.failWithError(error: error)
                    return
                }
                if let safedata = data {
                    if let text = self.parseReadingTextJson(safedata) {
                        self.readingTextDelegate?.didReceive(readingText: text)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    private func parseReadingTextJson (_ data: Data) -> [String]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ReadingTextData.self, from: data)
            return decodedData.words_list
        } catch {
            self.readingTextDelegate?.failWithError(error: error)
            return nil
        }
    }
}

fileprivate struct ReadingTextData: Decodable {
    var words_list: [String]
}
