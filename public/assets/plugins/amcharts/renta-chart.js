/**
 * Created by Julio Cesar on 4/7/2016.
 */
var colors = ["#B7CEE5","#F04C23","#98ACBF","#333940","#7F2813","#E54921","#CBE5FF","#66737F","#FF5125","#401409",];
var renta_chart = AmCharts.makeChart(
    "vdc", {
    "type": "serial",
    "theme": "light",
    "colors":colors,
    "legend": {
        "horizontalGap": 10,
        //"maxColumns": 1,
        "position": "bottom",
        "useGraphSettings": true,
        "markerSize": 10,
        "align":"center"

    },
    "dataProvider": [{
        "year": "Hasta 1 año",
        "financieras": 170.47,
        "cebures": 148.50
    }, {
        "year": "Hasta 2 año",
        "financieras": 448.60,
        "cebures": 223.40
    }, {
        "year": "Hasta 3 año",
        "financieras": 301.60,
        "cebures": 158.00
    }, {
            "year": "Hasta 4 año",
            "financieras": 0,
            "cebures": 158.00

        }],
    "valueAxes": [{
        "stackType": "regular",
        "axisAlpha": 0.3,
        "gridAlpha": 0
    }],
    "graphs": [{
        "balloonText": "<b>[[title]]</b><br><span style='font-size:14px'>[[category]]: <b>[[value]]</b></span>",
        "fillAlphas": 0.8,
        "labelText": "[[percents]]%",
        "lineAlpha": 0.3,
        "title": "Instituciones Financieras",
        "type": "column",
        "color": "#000000",
        "valueField": "financieras"
    }, {
        "balloonText": "<b>[[title]]</b><br><span style='font-size:14px'>[[category]]: <b>[[value]]</b></span>",
        "fillAlphas": 0.8,
        "labelText": "[[percents]]%",
        "lineAlpha": 0.3,
        "title": "CEBURES",
        "type": "column",
        "color": "#000000",
        "valueField": "cebures"
    }],
    "categoryField": "year",
    "categoryAxis": {
        "gridPosition": "start",
        "axisAlpha": 0,
        "gridAlpha": 0,
        "position": "left"
    },
    "export": {
        "enabled": true
    }

});
