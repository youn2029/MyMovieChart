//
//  ListViewController.swift
//  MyMovieChart
//
//  Created by 윤성호 on 07/02/2019.
//  Copyright © 2019 윤성호. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    @IBOutlet var moreBtn: UIButton!    // 더보기 버튼
    
    // 현재까지 일어온 데이터의 페이지 정보
    var page = 1
    
    // 테이블 뷰를 구성할 리스트 데이터
    lazy var list : [MovieVO] = [MovieVO]()
    
//    lazy var list : [MovieVO] = {
//
//        var datalist = [MovieVO]()
//
//        for (title, desc, opendate, rating, thumbnail) in self.dataset {
//
//            let mvo = MovieVO()
//
//            mvo.title = title
//            mvo.description = desc
//            mvo.opendate = opendate
//            mvo.rating = rating
//            mvo.thumbnail = thumbnail
//
//            datalist.append(mvo)
//        }
//
//        return datalist
//    }()
    /**
     lazy 키워드
         1. lazy키워드를 붙여서 변수를 정의하면 참조되는 시점에 맞추어 초기화되므로 메모리 낭비를 줄임
         2. 다른 프로퍼티를 참조하기 위해
     */
    
    // 뷰 컨트롤러가 초기화되면서 뷰가 메모리에 로딩될 때 호출되는 메소드
    override func viewDidLoad() {
        
        // 영화 차트 API를 호출
        self.callMovieAPI()
    }
    
    // 테이블 뷰 행의 개수를 반환하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    // 테이블 뷰 행을 구성하는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // 주어진 행에 맞는 데이터 소스를 읽어온다
        let row = self.list[indexPath.row]  // indexPath.row : 행 번호
        
        NSLog("호출된 행번호: \(indexPath.row), 제목: \(row.title!)")
        
        //NSLog("\(row.title)---")
        
        /// ============ 커스텀 style (커스텀 클래스) ============
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        
        // 데이터 소스에 저장된 값을 각 아울렛 변수에 할당
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        
        // 수정) 비동기 방식으로 섬네일 이미지를 읽어옴
        DispatchQueue.main.async(execute: {
            cell.thumbnail.image = self.getThubnailImage(indexPath.row) //
        })
        
        /// ============ 커스텀 style (태그속성) ============
//        // 테이블 셀 객체를 직접 생성하는 대신 큐로부터 가져온다
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell")!
//
//        // 각각의 레이블을 변수로 받음
//        let title = cell.viewWithTag(101) as? UILabel       // 영화제목
//        let desc = cell.viewWithTag(102) as? UILabel        // 영화요약
//        let opendate = cell.viewWithTag(103) as? UILabel    // 영화 개봉일
//        let rating = cell.viewWithTag(104) as? UILabel      // 평점
//
//        // 데이터 소스에 저장된 값을 각 레이블 변수에 할당
//        title?.text = row.title
//        desc?.text = row.description
//        opendate?.text = row.opendate
//        rating?.text = "\(row.rating!)"
        
        /// ============ subtitle style ============
//        cell.textLabel?.text = row.title
//        cell.detailTextLabel?.text = row.description    // 추가 사항 : 서브 타이틀에 데이터 연결

        return cell
    }
    
    // 데이블 셀을 선택했을때 호출되는 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행입니다.")
    }
    
    // 더보기 버튼 이벤트
    @IBAction func more(_ sender: Any) {
        
        // 현재 페이지 값에 1을 추가한다
        self.page += 1
        
        // 영화차트 API를 호출한다.
        self.callMovieAPI()
        
        // 데이터를 다시 읽어오도록 테이블 뷰를 갱신한다.
        self.tableView.reloadData()
        
    }
    
    // 영화 차트 API를 호출해주는 메소드
    func callMovieAPI() {
        
        // 1. 호핀 API 호출을 위한 URI를 생성
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=&order=releasedateasc"
        let apiURI : URL! = URL(string: url)
        
        // 2. REST API를 호출
        let apidata = try! Data(contentsOf: apiURI)
        
        // 3. 데이터 전송 결과를 로그로 출력 (반드시 필요한 코드는 아님)
//        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? "데이터가 없습니다"
//        NSLog("API Result=\(log)")
        
        // 4. JSON 객체를 파싱하여 NSDictionary 객체로 받음
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            // 5. 데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            // 6. lterator 처리를 하면서 API 데이터를 MoviewVO 객체에 저장한다
            for row in movie {
                // 순회 상수를 NSDictionary 타입으로 캐스팅
                let r = row as! NSDictionary
                
                // 데이블 뷰 리스트를 구성할 데이터 형식
                let mvo = MovieVO()
                
                //  movie 배열의 각 데이터를 mvo 상수의 속성에 대입
                mvo.title = r["title"] as? String               // 제목
                mvo.description = r["genreNames"] as? String    // 영화 설명
                mvo.rating = (r["ratingAverage"] as! NSString).doubleValue      // 평점
                mvo.thumbnail = r["thumbnailImage"] as? String  // 썸네일
                mvo.detail = r["linkUrl"] as? String            // 상세 내용
                
                let url : URL! = URL(string: mvo.thumbnail!)
                let imageData = try! Data(contentsOf: url)
                mvo.thumbnailImage = UIImage(data: imageData)
                
                
                // list 배열에 추가
                list.append(mvo)
            }
            
            // 7. 전체 데이터 카운트를 얻는다.
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            
            // 8. totalCount가 읽어온 데이터 크기와 같거나 클 경우 더보기 버튼을 막는다.
            if (self.list.count >= totalCount) {
                
                let alert = UIAlertController(title: "알림", message: "마지막 목록입니다.", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(ok)
                
                self.present(alert, animated: false)
                
                self.moreBtn.isHidden = true    // 숨김
                
            }
            
        } catch  {
            NSLog("Parse Error!!")
        }
    }
    
    // 섬네일 이미지를 받는 메소드
    func getThubnailImage(_ index : Int) -> UIImage {
        
        // 인자값으로 받는 인덱스를 기반으로 해당하는 배열 데이터를 읽어옴
        let mvo = self.list[index]
        
        // 메모이제이션 : 저장된 이미지가 있으면 그것을 반환하고, 없을 경우 내려받아 저장한 후 반환
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        } else {
            
            let url : URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            mvo.thumbnailImage = UIImage(data: imageData)   // UIImage를 MovieVO 객체에 우선저장
            
            return mvo.thumbnailImage!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 실행된 세그웨이의 식별자가 "seque_detail"이라면
        if segue.identifier == "segue_detail" {
            
            // 첫 번째 인자값을 이용하여 사용자가 몇 번째 행을 선택했는지 확인
            let path = self.tableView.indexPath(for: sender as! MovieCell)
            
            // 행 정보를 통해 선택된 영화 데이터를 찾은 다음, 목적지 뷰에 전달
            let detailVC = segue.destination as? DetailViewController            
            detailVC?.mvo = self.list[path!.row]
            
            // tableView.indexPath(for:) = for에 해당되는 indexPath 객체
            // sender는 세그가 발생한 객체
            // segue.destination : 세그웨이의 목적지에 해당되는 viewController
            
        }
    }
}
