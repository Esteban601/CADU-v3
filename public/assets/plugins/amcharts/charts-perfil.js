/**
 * Created by Julio Cesar on 4/5/2016.
 */

if (locale == "es") {
    var margen = "Margen EBITDA";
    var last_p = "1T21";
}
else {
    var margen = "EBITDA Margin";
    var last_p = "1Q21";

}
var bars = AmCharts.makeChart(
    "per_chart", {
        "type": "serial",
        "theme": "light",
        "categoryField": "year",
        "rotate": false,
        "startDuration": 1,
        "categoryAxis": {
            "gridPosition": "start",
            "position": "left"
        },
        "legend":{
            "position":"bottom",
            "align":"center"
        },
        "trendLines": [],
        "graphs": [
            {
                "balloonText": "ROE:[[value]]%",
                "fillAlphas": 0.8,
                "id": "AmGraph-1",
                "lineAlpha": 0.2,
                "title": "ROE",
                "type": "column",
                "valueField": "ROE"
            },
            {
                "balloonText": margen+":[[value]]%",
                "fillAlphas": 0.8,
                "id": "AmGraph-2",
                "lineAlpha": 0.2,
                "title": margen,
                "type": "column",
                "valueField": "EBITDA"
            }
        ],
        "guides": [],
        "valueAxes": [
            {
                "id": "ValueAxis-1",
                "position": "top",
                "axisAlpha": 0
            }
        ],
        "allLabels": [],
        "balloon": {},
        "titles": [],
        "colors":["#ED7D31","#FFC000"],
        "dataProvider": [
            {
                "year": 2012,
                "ROE": 28.8,
                "EBITDA": 26.3
            },
            {
                "year": 2013,
                "ROE": 28.1,
                "EBITDA": 22.9
            },
            {
                "year": 2014,
                "ROE": 26.3,
                "EBITDA": 19.5
            },
            {
                "year": "2015*",
                "ROE": 13.3,
                "EBITDA": 20.9
            },
            {
                "year": "2016",
                "ROE": 16.7,
                "EBITDA": 22.5
            },
            {
                "year": "2017",
                "ROE": 18.5,
                "EBITDA": 23.1
            },
            {
                "year": "2018",
                "ROE": 18.0,
                "EBITDA": 24.0
            },
            {
                "year": "2019",
                "ROE": 11.40,
                "EBITDA": 25.20
            },
            {
                "year": "2020",
                "ROE": 3.00,
                "EBITDA": 14.5
            },
            {
                "year": last_p,
                "ROE": 2.50,
                "EBITDA": 17.7
            }
        ],
        "export": {
            "enabled": true
        }

    });
