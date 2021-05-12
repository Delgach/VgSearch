//
//  ViewController.swift
//  Vegan russia search
//
//  Created by Владимир Дельгадильо on 25.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private var stories: [Hit] = []
    private let imageCache = ImageCache()
        
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(StoryTableViewCell.self, forCellReuseIdentifier: StoryTableViewCell.identifier)
        
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 50, width: view.frame.size.width - 20, height: 50)
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 105, width: view.frame.size.width, height: view.frame.size.height - 55)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            stories = []
            tableView.reloadData()
            searchRequest(query: text)
        }
    }
    
    func searchRequest (query: String) {
        let url = URL(string: "https://veganrussian.ru/api/search/")!
        var request = URLRequest(url: url);
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let json = try? JSONSerialization.data(withJSONObject: ["query": query, "offset": 0], options: .fragmentsAllowed)
        request.httpBody = json
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "no data")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.stories = response.hits
                    self.tableView.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate  {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryTableViewCell.identifier, for: indexPath) as! StoryTableViewCell
        cell.configure(with: stories[indexPath.row], imageCache: imageCache)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.5
    }
}

struct Hit: Codable {
    let feature_image: String
    let slug: String
    let title: String
}

struct SearchResponse: Codable {
    let hits: [Hit]
}
