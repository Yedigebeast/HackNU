//
//  NetworkingService+Words.swift
//  Kazakh Literacy Boost
//
//  Created by Yedige Ashirbek on 14.04.2024.
//

import Foundation

protocol WordsRequestDelegate {
    func didReceive(wordsData: [WordsData])
    func failWithError(error: Error)
}

extension NetworkingService {
    func getWords() {
        let url = "\(baseURL)/dictionary/item"
        performWordsRequest(with: url)
    }
    
    private func performWordsRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error {
                    self.wordsDelegate?.failWithError(error: error)
                    return
                }
                if let safedata = data {
                    if let wordsData = self.wordsJson(safedata) {
                        self.wordsDelegate?.didReceive(wordsData: wordsData)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    private func wordsJson(_ data: Data) -> [WordsData]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WordsListData.self, from: data)
            return decodedData.words
        } catch {
            self.wordsDelegate?.failWithError(error: error)
            return nil
        }
    }
}

struct WordsListData: Decodable {
    var words: [WordsData]
}

struct WordsData: Decodable {
    var word: String
    var rus: String
    var eng: String
    var description: String
}

