//
//  ChartMainVC.swift
//  iOSChartsDemo
//
//  Created by Admin on 11/29/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit
import Charts
var GpriceData: [Double] = []
var GopenPrice: [Double] = []
var GclosePrice: [Double] = []
var Glowest: [Double] = []

var Ghighest: [Double] = []
var GvolData: [Double] = []
var GxData: [String] = []

class ChartMainVC: UIViewController, ChartViewDelegate{
//    let xData: [String] = ["10:00","10:10","10:20","10:30","10:40","10:50","11:00","11:10","11:20","11:30","11:40","11:50","10:00","10:10","10:20","10:30","10:40","10:50","11:00","11:10","11:20","10:00","10:10","10:20","10:30","10:40","10:50","11:00","11:10","11:20","11:30","11:40","11:50","10:00","10:10","10:20","10:30","10:40","10:50","11:00","11:10","11:20"]
    
    var xData: [String] = []
    var priceData: [Double] = []
    var openPrice: [Double] = []
    var closePrice: [Double] = []
    var lowest: [Double] = []
    var highest: [Double] = []
    var volData: [Double] = []
    var vol5Data: [Double] = []
    var vol10Data: [Double] = []
    var vol20Data: [Double] = []
    
    @IBOutlet weak var guNameLbl: UILabel!
    @IBOutlet weak var codeCountryLbl: UILabel!
    @IBOutlet weak var guPriceLbl: UILabel!
    @IBOutlet weak var uDandRateLbl: UILabel!
    @IBOutlet weak var highestLbl: UILabel!
    @IBOutlet weak var lowestLbl: UILabel!
    @IBOutlet weak var openPriceLbl: UILabel!
    @IBOutlet weak var preClosedPriceLbl: UILabel!
    @IBOutlet weak var totalVolumnLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var avMethodLbl: UILabel!
    @IBOutlet weak var av5Lbl: UILabel!
    @IBOutlet weak var av10Lbl: UILabel!
    @IBOutlet weak var av20Lbl: UILabel!
    @IBOutlet weak var pubDateLbl: UILabel!


    @IBOutlet weak var mainView: CombinedChartView!
    var mainChartData =  CombinedChartData()
    //AverageLineChartView Part
    var mainPriceChart = LineChartDataSet()
    var avPriceChart = LineChartDataSet()
    var mainVolChart = BarChartDataSet()
    var mainVolColors: [UIColor] = []
    var mainMacdHistColors: [UIColor] = []
    
    // K-chart view items
    var av5PriceChart = LineChartDataSet()
    var av10PriceChart = LineChartDataSet()
    var av20PriceChart = LineChartDataSet()
    var candleChart = CandleChartDataSet()
    
    var volChart = BarChartDataSet()
    var vol20Chart = LineChartDataSet()
    var vol10Chart = LineChartDataSet()
    var vol5Chart = LineChartDataSet()
    // Technical parameters
    var macdChart = LineChartDataSet()
    var macdHistBar = BarChartDataSet()
    var signalLineChart = LineChartDataSet()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDisplayedItems()
        self.mainView.delegate = self
        self.mainView.gridBackgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.mainView.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        self.mainView.clearsContextBeforeDrawing = true
        self.mainView.legend.enabled = false
        self.mainView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .EaseInCubic)
        
        self.fenshiBtnWasTapped()
        // small windows define
        self.detailWindows.alpha = 0.75
        self.detailWindows.tag = 200
        self.detailWindows.userInteractionEnabled = false
        
    }
    // Drawing of firstChart
    func fenshiBtnWasTapped(){
        var macdPrice: [Double] = []
        let ema12 = self.calcEMA(self.priceData, tT: 12)
        let ema26 = self.calcEMA(self.priceData, tT: 26)
        for i in 0..<ema12.count{
            let macd = ema12[i]-ema26[i]
            macdPrice.append(macd)
        }
        let vol5Data = self.calcSMA(self.volData, tT: 5)
        let vol10Data = self.calcSMA(self.volData, tT: 10)
        let vol20Data = self.calcSMA(self.volData, tT: 20)
        self.setChart(self.xData, price: self.priceData, opened: self.openPrice, closed: self.closePrice, highest: self.highest, lowest: self.lowest, vol: self.volData, macd: macdPrice, vol5: vol5Data, vol10: vol10Data, vol20: vol20Data)
    }
    
    //MARK: - Calculate the line data and setting
    func setChart(dataPoints: [String], price: [Double], opened: [Double], closed:[Double], highest: [Double], lowest: [Double],vol:[Double], macd:[Double], vol5:[Double], vol10: [Double], vol20: [Double]){
        // calc SMA of main Price
        let mainAV = self.calcSMA(self.priceData, tT: 7)//
        // initialization
        var mainPriceEntries: [ChartDataEntry] = []
        var avPriceEntries: [ChartDataEntry] = []
        var mainVolEntries: [BarChartDataEntry] = []
        
        var candleEntries: [ChartDataEntry] = []
        var volBarEntries: [BarChartDataEntry] = []
        var vol5Entries: [ChartDataEntry] = []
        var vol10Entries: [ChartDataEntry] = []
        var vol20Entries: [ChartDataEntry] = []
        
        var macdEntries: [ChartDataEntry] = []
        var signalEntries: [ChartDataEntry] = []
        var macdHistEntries: [BarChartDataEntry] = []
        let ema9 = self.calcEMA(macd, tT: 9)
       
        for i in 0..<dataPoints.count
        {
            // according time
            let mainPriceEntry = ChartDataEntry(value: price[i], xIndex: i)
            mainPriceEntries.append(mainPriceEntry)
            let avPriceEntry = ChartDataEntry(value: mainAV[i], xIndex: i)
            avPriceEntries.append(avPriceEntry)
            let mainVolEntry = BarChartDataEntry(value: vol[i], xIndex: i)
            mainVolEntries.append(mainVolEntry)
            //K-chart
            let volBarEntry = BarChartDataEntry(value: vol[i]/100000, xIndex: i)
            volBarEntries.append(volBarEntry)
            let vol5Entry = ChartDataEntry(value: vol5[i]/100000, xIndex: i)
            vol5Entries.append(vol5Entry)
            let vol10Entry = ChartDataEntry(value: vol10[i]/100000, xIndex: i)
            vol10Entries.append(vol10Entry)
            let vol20Entry = ChartDataEntry(value: vol20[i]/100000, xIndex: i)
            vol20Entries.append(vol20Entry)
            let macdEntry = ChartDataEntry(value: macd[i], xIndex: i)
            macdEntries.append(macdEntry)
            let signalEntry = ChartDataEntry(value: ema9[i], xIndex: i)
            signalEntries.append(signalEntry)
            let macdHistEntry = BarChartDataEntry(value: macd[i]-ema9[i], xIndex: i)
            macdHistEntries.append(macdHistEntry)
            if (macd[i]-ema9[i])<0{
                self.mainMacdHistColors.append(UIColor(red: 20/255, green: 240/255, blue: 20/255, alpha: 0.8))
            }else{
                self.mainMacdHistColors.append(UIColor(red: 240/255, green: 20/255, blue: 20/255, alpha: 0.8))
            }
            // CandleStick ChartDataEntering
            let candleEntry = CandleChartDataEntry(xIndex: i, shadowH: highest[i], shadowL: lowest[i], open: opened[i], close: closed[i])
            candleEntries.append(candleEntry)
            
            //CandleStick Chart color
            if opened[i]>closed[i]{
                self.mainVolColors.append(UIColor(red: 0.95, green: 0.2, blue: 0.2, alpha: 1.0))
            }else{
                self.mainVolColors.append(UIColor(red: 0.2, green: 0.95, blue: 0.2, alpha: 1.0))
            }
        }
        //First screen of main price
        self.mainPriceChart = LineChartDataSet(yVals: mainPriceEntries)
        self.mainPriceChart.drawCircleHoleEnabled = false
        self.mainPriceChart.circleRadius = 2.0
        self.mainPriceChart.colors = [UIColor(red: 40/255, green: 200/255, blue: 20/255, alpha: 1.0)]
        self.mainPriceChart.fillColor = UIColor(red: 40/255, green: 200/255, blue: 20/255, alpha: 1.0)
        self.mainPriceChart.lineWidth = 2.0
        self.mainPriceChart.drawValuesEnabled = false
        self.mainPriceChart.circleColors = [UIColor(red: 40/255, green: 200/255, blue: 20/255, alpha: 1.0)]
        // average of main price of stocks
        self.avPriceChart = LineChartDataSet(yVals: avPriceEntries)
        self.avPriceChart.drawCircleHoleEnabled = false
        self.avPriceChart.drawCircleHoleEnabled = false
        self.avPriceChart.drawCirclesEnabled = false
        self.avPriceChart.drawValuesEnabled = false
        self.avPriceChart.drawFilledEnabled = true
        self.avPriceChart.fillColor = UIColor(red: 57/255, green: 100/255, blue: 73/255, alpha: 0.75)
        self.avPriceChart.circleRadius = 2.0
        self.avPriceChart.colors = [UIColor(red: 57/255, green: 100/255, blue: 73/255, alpha: 1)]
        self.avPriceChart.lineWidth = 3.0
        // Second View data prepare
        self.candleChart = CandleChartDataSet(yVals: candleEntries, label: "")
        self.candleChart.drawValuesEnabled = false
        self.candleChart.decreasingColor = UIColor(red: 20/255, green: 200/255, blue: 20/255, alpha: 0.85)
        self.candleChart.increasingColor = UIColor(red: 240/255, green: 20/255, blue: 20/255, alpha: 0.85)
        self.candleChart.shadowColorSameAsCandle = true
        self.candleChart.shadowWidth = 0.5

        
        self.macdHistBar = BarChartDataSet(yVals: macdHistEntries, label: "")
        self.macdHistBar.drawValuesEnabled = false
        self.macdHistBar.colors = self.mainMacdHistColors
        self.macdChart = LineChartDataSet(yVals: macdEntries, label: "")
        self.macdChart.drawValuesEnabled = false
        self.macdChart.lineWidth = 2.0
        self.macdChart.drawCirclesEnabled = false
        self.macdChart.drawCircleHoleEnabled = false

//        self.macdChart.colors = [UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)]
        self.signalLineChart = LineChartDataSet(yVals: signalEntries, label: "")
        self.signalLineChart.drawCircleHoleEnabled = false
        self.signalLineChart.drawCirclesEnabled = false
        self.signalLineChart.drawValuesEnabled = false
        self.signalLineChart.lineWidth = 1.5
        self.signalLineChart.colors = [UIColor(red: 20/255, green: 20/255, blue: 200/255, alpha: 1.0)]


        
        //VolChart
        self.volChart = BarChartDataSet(yVals: volBarEntries, label: "")
        self.volChart.colors = self.mainVolColors
        self.volChart.drawValuesEnabled = false
        self.vol5Chart = LineChartDataSet(yVals: vol5Entries, label: "")
        self.vol10Chart = LineChartDataSet(yVals: vol10Entries, label: "")
        self.vol20Chart = LineChartDataSet(yVals: vol20Entries, label: "")
        let barChartDatas = BarChartData(xVals: self.xData, dataSets: [self.volChart])
        
        
        let lineChartDatas = LineChartData(xVals: self.xData, dataSets: [self.mainPriceChart, self.avPriceChart])
        // define main chart data
        self.mainChartData = CombinedChartData(xVals: self.xData)
        
        self.mainChartData.lineData = lineChartDatas
        self.mainChartData.barData = barChartDatas
        self.mainView.data = self.mainChartData
        self.mainView.xAxis.labelPosition = .TopInside
        self.mainView.leftAxis.labelPosition = .InsideChart
        self.mainView.descriptionText = ""
        self.mainView.rightAxis.enabled = false
    }
    // Button define
    @IBAction func zhouqiBtn(sender: AnyObject) {
    }
    @IBOutlet weak var fenshiBtn: UIButton!
    @IBAction func fenshiBtnTapped(sender: AnyObject) {
        //VolChart
        
        self.volChart.colors = self.mainVolColors
        self.volChart.drawValuesEnabled = false
        
        let barChartDatas = BarChartData(xVals: self.xData, dataSets: [self.volChart])
        
        
        let lineChartDatas = LineChartData(xVals: self.xData, dataSets: [self.mainPriceChart, self.avPriceChart])
        // define main chart data
        self.mainChartData = CombinedChartData(xVals: self.xData)
        
        self.mainChartData.lineData = lineChartDatas
        self.mainChartData.barData = barChartDatas
        self.mainView.data = self.mainChartData
        self.mainView.xAxis.labelPosition = .TopInside
        self.mainView.leftAxis.labelPosition = .InsideChart
        self.mainView.descriptionText = ""
        self.mainView.rightAxis.enabled = false
        self.mainView.drawValueAboveBarEnabled = false
        
    }
    @IBOutlet weak var KriBtn: UIButton!
    @IBAction func KriBtnTapped(sender: AnyObject) {
        
        let candleChartData = CandleChartData(xVals: self.xData, dataSet: self.candleChart)
        //MACD
        let macdHistBarChartData = BarChartData(xVals: self.xData, dataSet: self.macdHistBar)
        let macdLineChartData = LineChartData(xVals: self.xData, dataSets: [self.macdChart, self.signalLineChart])
        let combinedChartDatas = CombinedChartData(xVals: self.xData)
        // Vol
        self.volChart.colors = self.mainVolColors
        self.volChart.drawValuesEnabled = false
        self.vol5Chart.drawValuesEnabled = false
        self.vol5Chart.drawCircleHoleEnabled = false
        self.vol5Chart.drawCirclesEnabled = false
        self.vol5Chart.colors = [UIColor(red: 225/255, green: 128/255, blue: 0, alpha: 0.8)]
        
        self.vol10Chart.drawValuesEnabled = false
        self.vol10Chart.drawCircleHoleEnabled = false
        self.vol10Chart.drawCirclesEnabled = false
        self.vol10Chart.colors = [UIColor(red: 20/255, green: 20/255, blue: 200/255, alpha: 0.8)]
        
        self.vol20Chart.drawValuesEnabled = false
        self.vol20Chart.drawCircleHoleEnabled = false
        self.vol20Chart.drawCirclesEnabled = false
        self.vol20Chart.colors = [UIColor(red: 186/255, green: 67/255, blue: 186/255, alpha: 0.8)]
        
        
        let volLineData = LineChartData(xVals: self.xData, dataSets: [self.vol5Chart,self.vol10Chart,self.vol20Chart])
        let volBarData = BarChartData(xVals: self.xData, dataSets: [self.volChart])
        combinedChartDatas.candleData = candleChartData
        if maIsTapped{
            combinedChartDatas.barData = volBarData
            combinedChartDatas.lineData = volLineData
        }else{
            combinedChartDatas.barData = macdHistBarChartData
            combinedChartDatas.lineData = macdLineChartData
        }
        self.mainView.data = combinedChartDatas
    }
    @IBOutlet weak var KzhouBtn: UIButton!
    @IBAction func KzhouBtnTapped(sender: AnyObject) {
    }
    @IBOutlet weak var KyueBtn: UIButton!
    @IBAction func KyueBtnTapped(sender: AnyObject) {
    }
    @IBOutlet weak var yifenBtn: UIButton!
    @IBAction func yifenBtnTapped(sender: AnyObject) {
    }
    @IBOutlet weak var sanfenBtnTapped: UIButton!
    @IBAction func sanfenBtnTapped(sender: AnyObject) {
    }
    @IBOutlet weak var wufenBtn: UIButton!
    @IBAction func wufenBtnTapped(sender: AnyObject) {
    }
    @IBOutlet weak var shiwufenBtn: UIButton!
    @IBAction func shiwufenBtnTapped(sender: AnyObject) {
    }
    @IBOutlet weak var sanshifenBtn: UIButton!
    @IBAction func sanshifenBtnTapped(sender: AnyObject) {
    }
    @IBOutlet weak var liushifenBtn: UIButton!
    @IBAction func liushifenBtnTapped(sender: AnyObject) {
    }
    @IBOutlet weak var unxianLbl: UILabel!
    @IBOutlet weak var maLbl: UILabel!
    
    
    
    @IBOutlet weak var macdBtn: UIButton!
    @IBAction func macdBtnTapped(sender: AnyObject) {
        self.maIsTapped = false
        let macdHistBarChartData = BarChartData(xVals: self.xData, dataSet: self.macdHistBar)
        let macdLineChartData = LineChartData(xVals: self.xData, dataSets: [self.macdChart, self.signalLineChart])
        let combinedChartDatas = CombinedChartData(xVals: self.xData)
        combinedChartDatas.barData = macdHistBarChartData
        combinedChartDatas.lineData = macdLineChartData
        self.mainView.data = combinedChartDatas
    }
    var maIsTapped: Bool = true// MACD is the case of false
    @IBOutlet weak var maBtn: UIButton!
    @IBAction func maBtnTapped(sender: AnyObject) {
        self.maIsTapped = true
        let volLineData = LineChartData(xVals: self.xData, dataSets: [self.vol5Chart,self.vol10Chart,self.vol20Chart])
        let volBarData = BarChartData(xVals: self.xData, dataSets: [self.volChart])
        let combinedChartDatas = CombinedChartData(xVals: self.xData)
        combinedChartDatas.barData = volBarData
        combinedChartDatas.lineData = volLineData
        self.mainView.data = combinedChartDatas
    }
    @IBAction func zhiBiaobtn(sender: AnyObject) {
    }
    
    // small windows define
    var detailWindows: detailView = detailView(frame: CGRect(x: 20, y: 20, width: 120, height: 180))
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        detailWindows.ymdwLbl.text = "\(self.xData[entry.xIndex])"
        detailWindows.kaipanLbl.text = String(format: "%.3f", self.openPrice[entry.xIndex])
        detailWindows.chengjiaoliangLbl.text = String(format: "%.3f", self.volData[entry.xIndex])
        detailWindows.zuigaoLbl.text = String(format: "%.3f", self.highest[entry.xIndex])
        detailWindows.zuidiLbl.text = String(format: "%.3f", self.lowest[entry.xIndex])
        detailWindows.shoupanLbl.text = String(format: "%.3f", self.closePrice[entry.xIndex])
        
        self.mainView.addSubview(detailWindows)
        
    }
    func chartValueNothingSelected(chartView: ChartViewBase) {
        if let viewWithTag = self.view.viewWithTag(100)
        {
            print("View has just dismissed.")
            viewWithTag.removeFromSuperview()
        }else{
            print("Not removed!")
        }
    }
   
    
    
    
    
    
    
    // SMA tT: T-period SMA
    func calcSMA(datas: [Double], tT: Int) -> [Double]{
        var returnDatas: [Double] = []
        var sumN: Double = 0
        
        for nn in 0..<datas.count{
            var sumNN: Double = 0
            if nn<tT{
                sumN += datas[nn]
                let val = sumN/Double(nn+1)
                returnDatas.append(val)
            }else{
                for i in nn-tT..<nn{
                    sumNN += datas[i]
                }
                sumN = sumNN/Double(tT)
                returnDatas.append(sumN)
            }
        }
        return returnDatas
    }
    
    //EMA tT: T-period EMA calculation
    func calcEMA(datas: [Double], tT: Int) -> [Double]{
        let sma = self.calcSMA(datas, tT: tT)
        let kk = Double(2/(Double(tT)+1))
        var returnedData: [Double] = []
        var preVal: Double = 0
        var val = sma[0]
        returnedData.append(val)
        for nn in 1..<datas.count{
            val = sma[nn]*kk+preVal*(1-kk)
            returnedData.append(val)
            preVal = val
        }
        return returnedData
    }
    // MARK: - Initialization of UILabels
    func initDisplayedItems(){
        
        // variables initialization
        self.xData = GxData
        self.priceData = GpriceData
        self.openPrice = GopenPrice
        self.closePrice = GclosePrice
        self.lowest = Glowest
        self.highest = Ghighest
        self.volData = GvolData
        
        self.codeCountryLbl.text = "\(midSumData.guCode)"+"."+"\(midSumData.guCountry)"
        self.guNameLbl.text = midSumData.guName
        self.guPriceLbl.text = String(format: "%.3f",midSumData.guPrice)
        self.uDandRateLbl.text = "\(midSumData.guUDValue)" + " " + "\(midSumData.guUDRate)%"
        self.highestLbl.text = String(format: "%.3f",midSumData.highestPrice)
        self.lowestLbl.text = String(format: "%.3f",midSumData.lowestPrice)
        self.openPriceLbl.text = String(format: "%.3f",midSumData.openPrice)
        self.preClosedPriceLbl.text = String(format: "%.3f", midSumData.preClosed)
        self.totalVolumnLbl.text = String(format: "%.3f",midSumData.totVolumn)
        self.totalPriceLbl.text = String(format: "%.3f",midSumData.turnOver)
        self.gettingDate()// getting update data published from server
        self.avMethodLbl.text = "MA"
    }

    //MARK: - Getting published Date
    func gettingDate(){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year, .Hour, .Minute], fromDate: date)
        
//        let currentYear =  components.year
        let currentMonth = components.month
        let currentDay = components.day
        let currentHour = components.hour
        let currentMinute = components.minute
        self.pubDateLbl.text = "已收盘 \(currentMonth)/\(currentDay) \(currentHour):\(currentMinute)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func returnBtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.LandscapeRight
    }
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeRight
    }

}
