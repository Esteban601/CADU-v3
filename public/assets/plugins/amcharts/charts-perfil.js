/**
 * Created by Julio Cesar on 4/5/2016.
 */
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
                "balloonText": "UAFIDA:[[value]]%",
                "fillAlphas": 0.8,
                "id": "AmGraph-2",
                "lineAlpha": 0.2,
                "title": "UAFIDA",
                "type": "column",
                "valueField": "UAFIDA"
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
                "year": 2009,
                "ROE": 28.7,
                "UAFIDA": 28.0
            },
            {
                "year": 2010,
                "ROE": 29.5,
                "UAFIDA": 29.4
            },
            {
                "year": 2011,
                "ROE": 27.3,
                "UAFIDA": 27.0
            },
            {
                "year": 2012,
                "ROE": 28.8,
                "UAFIDA": 26.3
            },
            {
                "year": 2013,
                "ROE": 28.1,
                "UAFIDA": 22.9
            },
            {
                "year": 2014,
                "ROE": 26.3,
                "UAFIDA": 19.5
            },
            {
                "year": "2015*",
                "ROE": 13.4,
                "UAFIDA": 21.1
            }
        ],
        "export": {
            "enabled": true
        }

    });