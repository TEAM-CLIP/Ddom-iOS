// APIManager.swift

import Foundation

class APIManager {
    static let shared = APIManager()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getUserEmail() -> String? {
        return UserDefaults.standard.string(forKey: "lastLoggedInEmail")
    }
    
    func getToken() -> String? {
        guard let email = UserDefaults.standard.string(forKey: "lastLoggedInEmail") else {
            return nil
        }
        
        do {
            return try KeychainManager.retrieve(service: APIConstants.tokenService, account: email)
        } catch {
            print("Failed to retrieve token: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveToken(_ token: String, for email: String) {
        do {
            try KeychainManager.save(token: token,
                                   service: APIConstants.tokenService,
                                   account: email)
            UserDefaults.standard.set(email, forKey: "lastLoggedInEmail")
        } catch KeychainManager.KeychainError.unknown(let status) {
            print("Failed to save token. Unknown error with status: \(status)")
        } catch KeychainManager.KeychainError.encodingError {
            print("Failed to save token. Encoding error.")
        } catch {
            print("Failed to save token: \(error.localizedDescription)")
        }
    }
    
    func clearToken() {
        guard let email = UserDefaults.standard.string(forKey: "lastLoggedInEmail") else {
            return
        }
        
        do {
            try KeychainManager.delete(service: APIConstants.tokenService,
                                     account: email)
            UserDefaults.standard.removeObject(forKey: "lastLoggedInEmail")
        } catch {
            print("Failed to clear token: \(error.localizedDescription)")
        }
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint,
                              method: HTTPMethod = .get,
                              parameters: Parameters? = nil,
                              completion: @escaping (Result<T, APIError>) -> Void) {
        guard !AppState.shared.isGuestMode else { return }
        
        guard var urlComponents = URLComponents(string: APIConstants.baseUrl + endpoint.path) else {
            completion(.failure(.invalidURL))
            return
        }
        
        // GET 메서드일 경우 쿼리 파라미터로 변환
        if method == .get, let parameters = parameters {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 헤더 설정
        if let token = self.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else if APIConstants.isDevelopment {
            request.setValue("Bearer dummyToken", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(.unauthorized))
            return
        }
        
        // POST, PUT, DELETE 등의 경우 body에 파라미터 추가
        if method != .get, let parameters = parameters {
            do {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                completion(.failure(.encodingError))
                return
            }
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    
    func requestWithoutAuth<T: Decodable>(_ endpoint: APIEndpoint,
                                         method: HTTPMethod = .post,
                                         parameters: Parameters? = nil,
                                         completion: @escaping (Result<T, APIError>) -> Void) {
        guard var urlComponents = URLComponents(string: APIConstants.baseUrl + endpoint.path) else {
            completion(.failure(.invalidURL))
            return
        }
        
        if method == .get, let parameters = parameters {
            urlComponents.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method != .get, let parameters = parameters {
            do {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                completion(.failure(.encodingError))
                return
            }
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}

// APIError.swift
enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case serverError(Int)
    case noData
    case decodingError(Error)
    case encodingError
    case unauthorized
}

// HTTPMethod.swift
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

typealias Parameters = [String: Any]
