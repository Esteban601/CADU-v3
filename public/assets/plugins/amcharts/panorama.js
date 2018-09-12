var chart = AmCharts.makeChart("panorama", {
    "titles": [
        {
            "text": "Monto promedio de crédito infonavit",
            "size": 15
        }
    ],
    "theme": "light",
    "type": "serial",
    "numberFormatter": {
        "precision": 2
    },
    "colors": ["#ED7D31", "#FFC000"],
    "dataProvider": [
        {
            "year": "2017/01",
            "monto": 340.444253417108,
            "variacion": 14.44,
            "variacion_v": 12.445602598931
        }, {
            "year": "2017/02",
            "monto": 298.496962070504,
            "variacion": 5.15,
            "variacion_v": 3.1571840215499
        }, {
            "year": "2017/03",
            "monto": 298.644267231226,
            "variacion": 3.64,
            "variacion_v": 2.64886070550552
        }, {
            "year": "2017/04",
            "monto": 315.843482671279,
            "variacion": 6.85,
            "variacion_v": 4.85783204365009
        }, {
            "year": "2017/05",
            "monto": 334.56529714404,
            "variacion": 12.53,
            "variacion_v": 10.5301122239789
        }, {
            "year": "2017/06",
            "monto": 340.445551810947,
            "variacion": 18.87,
            "variacion_v": 16.8788729130552
        }, {
            "year": "2017/07",
            "monto": 352.019380992828,
            "variacion": 19.44,
            "variacion_v": 17.4420383923616
        }, {
            "year": "2017/08",
            "monto": 359.267004552634,
            "variacion": 20.33,
            "variacion_v": 18.3393995707663
        }, {
            "year": "2017/09",
            "monto": 362.717797613209,
            "variacion": 20.38,
            "variacion_v": 18.3891492345851
        }, {
            "year": "2017/10",
            "monto": 362.972996560793,
            "variacion": 19.11,
            "variacion_v": 17.1167501428103
        }, {
            "year": "2017/11",
            "monto": 352.654623128672,
            "variacion": 13.32,
            "variacion_v": 11.3224983678685
        }, {
            "year": "2017/12",
            "monto": 367.541904163071,
            "variacion": 14.83,
            "variacion_v": 12.8351157891494
        }, {
            "year": "2018/01",
            "monto": 395.018380811582,
            "variacion": 16.03,
            "variacion_v": 14.030268346933
        }, {
            "year": "2018/02",
            "monto": 371.090930477389,
            "variacion": 24.31,
            "variacion_v": 22.319834916691
        }, {
            "year": "2018/03",
            "monto": 379.078201002327,
            "variacion": 26.93,
            "variacion_v": 22.9330245367891
        }, {
            "year": "2018/04",
            "monto": 379.634348582715,
            "variacion": 20.19,
            "variacion_v": 18.1969866124568
        }, {
            "year": "2018/05",
            "monto": 377.991486871755,
            "variacion": 12.97,
            "variacion_v": 10.9798846737588
        }
    ],
    "valueAxes": [{
        "id": "v1",
        "axisAlpha": 0,
        "gridAlpha": 0.1,
        "position": "left",
        "maximum": 450,
        "minimum": 0,
        "autoGridCount": false,
        "gridCount": 9
        // "title": "Calificación",
    },
        {
            "id": "v2",
            "axisAlpha": 0,
            "gridAlpha": 0,
            "position": "right",
            "maximum": 40.00,
            "minimum": -20.00,
            // "title": "Posición",
            "labelFunction": function (value) {
                return formatFileSize(value);
            }
        }],
    "startDuration": 1,
    "graphs": [{
        "fillAlphas": 0.9,
        "lineAlpha": 0.2,
        "type": "column",
        "valueField": "monto",
        "valueAxis": "v1",
        "autoGrid": false,
        "labelText": "[[value]]",
        "title": "Monto promedio INFONAVIT"
    }, {
        "lineAlpha": 0.9,
        "lineThickness": 3,
        "bullet": "round",
        "bulletBorderColor": "#fff",
        "bulletBorderThickness": 2,
        "bulletBorderAlpha": 1,
        "valueField": "variacion_v",
        "valueAxis": "v2",
        "balloonText": "[[variacion]]",
        "labelText": "[[variacion]]",
        "title": "Variación anual",
    }],
    "categoryField": "year",
    "categoryAxis": {
        "gridPosition": "start",
        "gridAlpha": 0,
        "labelRotation": 45
    },
    "legend": {
        "align": "center",
        "position": "bottom",
        "markerSize": 15,
        "markerType": "circle",
        "textClickEnabled": true
    }
});

function formatFileSize(value) {
    return value + ".00%";
}