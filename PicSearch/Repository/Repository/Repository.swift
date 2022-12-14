//
//  Repository.swift
//  JsonParseTest
//
//  Created by Pavel Schulepov on 05.12.2022.
//

import Foundation

final class Repository: RepositoryType {
    
    private let cashe = NSCache<NSString, NSData>()
    
    //MARK: - Network
    
    func getRemoteData(searchText: String, page: Int, completion: @escaping (Result<[DomainResultModel]?, NetworkError>) -> Void) {
        let request = createRequest(searchText: searchText, page: page)
        
        NetworkManager.execute.getModelTask(request: request) { (result: Result<UnsplashModel?, NetworkError>) in
            switch result {
                
            case .success(let data):
                if data?.total == 0 { completion(.failure(NetworkError.nothingFound)); return}
                completion(.success(data?.results.map { $0.domain } ))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRemoteData(searchText: String, completion: @escaping (Result<(DomainModel?), NetworkError>) -> Void) {
        let request = createRequest(searchText: searchText, page: 1)
        
        NetworkManager.execute.getModelTask(request: request) { (result: Result<UnsplashModel?, NetworkError>) in
            switch result {
                
            case .success(let data):
                if data?.total == 0 { completion(.failure(NetworkError.nothingFound)); return }
                let dataModel = data?.results.map { $0.domain }
                completion(.success(DomainModel(total: data!.total, results: dataModel) ))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getRemoteImage(url: String?, completion: @escaping (Data?) -> Void) {
        guard let urlString = url,
              let url = URL(string: urlString) else { return completion(nil) }
        
        if let dataCashe = cashe.object(forKey: NSString(string: urlString)) {
            completion(Data(dataCashe))
        } else {
            NetworkManager.execute.getImageTask(url: url) { data in
                guard let data = data else { completion(nil); return }
                self.cashe.setObject(NSData(data: data), forKey: NSString(string: urlString))
                completion(data)
            }
        }
    }
    
    //MARK: - CoreData
    
    func getLocalData(completion: @escaping (Result<[DomainResultModel]?, CoreDataError>) -> Void) {
        CoreDataManager.execute.getDataTask { (result: Result<[SavePicture]?, CoreDataError>) in
            switch result {
            case .success(let data):
                completion(.success(data?.map { $0.domain }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveLocalFavorite(data: DomainResultModel?, completion: @escaping (CoreDataError?) -> Void) {
        CoreDataManager.execute.saveDataTask(data: data, completion: completion)
    }
    
    func deleteLocalFavorite(data: DomainResultModel?, completion: @escaping (CoreDataError?) -> Void) {
        CoreDataManager.execute.deleteDataTask(data: data, completion: completion)
    }
}
