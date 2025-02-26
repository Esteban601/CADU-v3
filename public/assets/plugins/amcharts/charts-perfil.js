/**
 * Created by Julio Cesar on 4/5/2016.
 */

if (locale == "es") {
    var margen = "Margen EBITDA";
    var last_p = "2021";
}
else {
    var margen = "EBITDA Margin";
    var last_p = "2021";

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
                "year": "2020*",
                "ROE": 2.8,
                "EBITDA": 14.8
            },
            {
                "year": "2021*",
                "ROE": -2.1,
                "EBITDA": 11.5
            },
            {
                "year": 2022,
                "ROE": 5.2,
                "EBITDA": 17.2
            },
            {
                "year": 2023,
                "ROE": 5.7,
                "EBITDA": 16.5
            },
            {
                "year": 2024,
                "ROE": 4.2,
                "EBITDA": 15.9
            },
            
        ],
        "export": {
            "enabled": true
        }

    });
