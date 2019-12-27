var mydash = {};
//var precios = [];
//var ipc = [];
var loaded = 0;
var chartData = [];
var ipcData = [];
var ticker_symbol = "CADUA";
$.ajax({
    dataType: "jsonp",
    url: "https://hkpy.irstrat.com/intradia/history/11?start=2015-12-04",
    data: {},
    jsonpCallback: 'callbackHistory2',
    success: function (data) {
        ipcData= data.precios.reverse() ;
        loaded +=1
        if(loaded>1){
            fillData(precios, ipcData, ticker_symbol);
        }
    }
//   var ipcData = data.ipc
 });
$.ajax({
    url: 'https://hkpy.irstrat.com/intradia/history/147?start=2015-12-04',
    async: false,
    dataType: 'jsonp',
    jsonpCallback: 'jsonCallback',
    success: function (json) {
        precios = json.precios;
        loaded +=1
        if(loaded>1){
            fillData(precios, ipcData, ticker_symbol);
        }
        //            console.dir(json.sites);
    }

});
$.ajax({
    url:'https://hkpy.irstrat.com/intradia/147',
    async: false,
    dataType: 'jsonp',
    success: function(json) {
        intradia = json.intradia;
        Datatabla(intradia);
    }
});
function Datatabla(intradia) {
    $('#table-date').html(intradia["date"] + ", " + intradia["time"] + " EST");
//    $('#table-time').html(intradia["time"]);
    $('#table-price').html(intradia["price"]);
    $('#table-change').html(intradia["change"]);
    $('#table-range').html(intradia["min"] + " - " + intradia["max"]);
    $('#table-volume').html(intradia["volume"]);
    $('#price-ticker').html("$" + intradia["price"]);
    $('#change-ticker').html(intradia["change"]);
}

//filling empty values from non operation
function fillData(precios, ipc, ticker_symbol) {
    var lvva = 0;
    var lvvo = 0;
    precios_fill = $.map(precios, function (n, i) {
        if (n.value !== null) {
            lvva = n.value;
            lvvo = n.volume
        }
        ;
        if (n.volume === null) {
            lvvo = 0
        }
        ;
        return [{"date": n.date, "value": lvva, "volume": lvvo}];
    }).reverse();

    ipc_fill = $.map(ipc, function (n, i) {
        if (n.value !== null) {
            lvva = n.value;
            lvvo = n.volume
        }
        ;
        if (n.volume === null) {
            lvvo = 0
        }
        ;
        return [{"date": n.date, "value": lvva, "volume": lvvo}];
    }).reverse();

    AmCharts.theme = AmCharts.themes.iredge;
    // AmCharts.shortMonthNames=  ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

    ///tercera
    AmCharts.ready(function () {

        createStockChart();
    });

}


function createStockChart() {
    var chart = new AmCharts.AmStockChart();
    chart.dataDateFormat = "YYYY-MM-DD";
    chart.pathToImages = "/assets/plugins/amcharts/images/";


    // DATASETS //////////////////////////////////////////
    // create data sets first
    var dataSet1 = new AmCharts.DataSet();
    dataSet1.title = ticker_symbol;
    dataSet1.fieldMappings = [{
        fromField: "value",
        toField: "value"
    }, {
        fromField: "volume",
        toField: "volume"
    }];
    dataSet1.dataProvider = precios_fill;
    dataSet1.categoryField = "date";

    var dataSet2 = new AmCharts.DataSet();
    dataSet2.title = "IPC";
    dataSet2.fieldMappings = [{
        fromField: "value",
        toField: "value"
    }, {
        fromField: "volume",
        toField: "volume"
    }];
    dataSet2.dataProvider = ipc_fill;
    dataSet2.categoryField = "date";


    // set data sets to the chart
    chart.dataSets = [dataSet1, dataSet2];

    // PANELS ///////////////////////////////////////////
    // first stock panel
    var stockPanel1 = new AmCharts.StockPanel();
    stockPanel1.showCategoryAxis = false;
    stockPanel1.title = "Historical prices at last close";
    stockPanel1.percentHeight = 70;

    // graph of first stock panel
    var graph1 = new AmCharts.StockGraph();
    graph1.valueField = "value";
    graph1.comparable = true;
    graph1.compareField = "value";
    graph1.bullet = "round";
    graph1.hideBulletsCount = 32;
    graph1.bulletBorderColor = "#FFFFFF";
    graph1.bulletBorderAlpha = 1;
    graph1.balloonText = "[[title]]: <b>[[value]]</b>";
    graph1.compareGraphBalloonText = "[[title]]:<b>[[value]]</b>";
    graph1.compareGraphBullet = "round";
    graph1.compareGraphBulletBorderColor = "#FFFFFF";
    graph1.compareGraphBulletBorderAlpha = 1;
    stockPanel1.addStockGraph(graph1);

    // create stock legend
    var stockLegend1 = new AmCharts.StockLegend();
    stockLegend1.periodValueTextComparing = "[[percents.value.close]]%";
    stockLegend1.periodValueTextRegular = "[[value.close]]";
    stockPanel1.stockLegend = stockLegend1;


    // second stock panel
    var stockPanel2 = new AmCharts.StockPanel();
    stockPanel2.title = "Volume";
    stockPanel2.percentHeight = 30;
    var graph2 = new AmCharts.StockGraph();
    graph2.valueField = "volume";
    graph2.type = "column";
    graph2.showBalloon = true;
    graph2.fillAlphas = 1;
    graph2.periodValue = "Sum";
    stockPanel2.addStockGraph(graph2);

    var stockLegend2 = new AmCharts.StockLegend();
    stockLegend2.periodValueTextRegular = "[[value.close]]";
    stockPanel2.stockLegend = stockLegend2;

    // set panels to the chart
    chart.panels = [stockPanel1, stockPanel2];


    // OTHER SETTINGS ////////////////////////////////////
    var sbsettings = new AmCharts.ChartScrollbarSettings();
    sbsettings.graph = graph1;
    chart.chartScrollbarSettings = sbsettings;

    // CURSOR
    var cursorSettings = new AmCharts.ChartCursorSettings();
    cursorSettings.valueBalloonsEnabled = true;
    chart.chartCursorSettings = cursorSettings;


    // PERIOD SELECTOR ///////////////////////////////////
    var periodSelector = new AmCharts.PeriodSelector();
    periodSelector.position = "left";
    periodSelector.fromText = "From:";
    periodSelector.toText = "To:";
    periodSelector.periods = [{
        period: "MM",
        count: 1,
        label: "1 month"
    }, {
        period: "YYYY",
        count: 1,
        label: "1 year"
    },
        {
            period: "YYYY",
            count: 3,
            selected: true,
            label: "3 years"
        }];
    chart.periodSelector = periodSelector;


    // DATA SET SELECTOR
    var dataSetSelector = new AmCharts.DataSetSelector();
    dataSetSelector.position = "left";
    dataSetSelector.compareText = "Compared to:";
    dataSetSelector.selectText = "Select:";

    chart.dataSetSelector = dataSetSelector;

    var categoryAxesSettings = new AmCharts.CategoryAxesSettings();
    categoryAxesSettings.maxSeries = 0;
    chart.categoryAxesSettings  = categoryAxesSettings;

    chart.write('chartdiv3');
}
