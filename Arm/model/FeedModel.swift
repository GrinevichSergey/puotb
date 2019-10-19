import Foundation

protocol FeedModelProtocol: class {
    func itemsDownloaded(items: NSArray)

}



class FeedModel: NSObject, URLSessionDataDelegate {

    weak var delegate: FeedModelProtocol!
  
    
    let urlPath = "https://api.xpcom.ru/puotb/select3.php" //Change to the web address of your stock_service.php file
    
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Error")
            }else {
                print("stocks downloaded")
                self.parseJSON(data!)
            }
            
        }
        
        task.resume()
}
    
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        let stocks = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
          
            
            let stock = StockModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let id = jsonElement["arm_id"] as? String,
                let name = jsonElement["arm_name"] as? String,
                let ip = jsonElement["arm_ip"] as? String,
                let login = jsonElement["arm_login"] as? String,
                let note = jsonElement["arm_note"] as? String,
                let tel = jsonElement["armtelnumber"] as? String,
                let rozetka = jsonElement["arm_rozetka"] as? String,
                let password = jsonElement["arm_pass"] as? String,
                let location = jsonElement["arm_cat"] as? String
           
            {
              
                stock.id = id
                stock.name = name
                stock.ip = ip
                stock.login = login
                stock.note = note
                stock.tel = tel
                stock.rozetka = rozetka
                stock.password = password
                stock.location = location
                
                
            
            }
            
            stocks.add(stock)
        //    print(stock)
 
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.delegate.itemsDownloaded(items: stocks)
            
        })
    }
    
    
}
