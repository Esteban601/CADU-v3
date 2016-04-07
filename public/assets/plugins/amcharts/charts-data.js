var colors = ["#B7CEE5","#F04C23","#98ACBF","#333940","#7F2813","#E54921","#CBE5FF","#66737F","#FF5125","#401409",];
AmCharts.makeChart(
    "vrp", {
        "type": "pie",
        "startDuration": 0,
        "theme": "light",
        "addClassNames": true,
        "colors":colors,
        "legend":{
            "position":"bottom"
            //"marginRight":100,
            //"autoMargins":false
        },
        "innerRadius": "0",
        "radius": "40%",
        "defs": {
            "filter": [{
                "id": "shadow",
                "width": "200%",
                "height": "200%",
                "feOffset": {
                    "result": "offOut",
                    "in": "SourceAlpha",
                    "dx": 0,
                    "dy": 0
                },
                "feGaussianBlur": {
                    "result": "blurOut",
                    "in": "offOut",
                    "stdDeviation": 5
                },
                "feBlend": {
                    "in": "SourceGraphic",
                    "in2": "blurOut",
                    "mode": "normal"
                }
            }]
        },
        "dataProvider": [{
            "country": "Cancún",
            "litres": 49
        },{
            "country": "Playa del Carmen",
            "litres": 30
        },{
            "country": "Guadalajara",
            "litres": 16
        },{
            "country": "Zumpango",
            "litres": 3
        },{
            "country": "León",
            "litres": 2
        }],
        "valueField": "litres",
        "titleField": "country",
        "labelText": "",
        "export": {
            "enabled": true
        }
    }
);
AmCharts.makeChart(
    "ixp", {
        "type": "pie",
        "startDuration": 0,
        "theme": "light",
        "addClassNames": true,
        "colors":colors,
        "legend":{
            "position":"bottom"
            //"marginRight":100,
            //"autoMargins":false
        },
        "innerRadius": "0",
        "radius": "40%",
        "defs": {
            "filter": [{
                "id": "shadow",
                "width": "200%",
                "height": "200%",
                "feOffset": {
                    "result": "offOut",
                    "in": "SourceAlpha",
                    "dx": 0,
                    "dy": 0
                },
                "feGaussianBlur": {
                    "result": "blurOut",
                    "in": "offOut",
                    "stdDeviation": 5
                },
                "feBlend": {
                    "in": "SourceGraphic",
                    "in2": "blurOut",
                    "mode": "normal"
                }
            }]
        },
        "dataProvider": [{
            "country": "Cancún",
            "litres": 47
        },{
            "country": "Playa del Carmen",
            "litres": 32
        },{
            "country": "Guadalajara",
            "litres": 14
        },{
            "country": "Zumpango",
            "litres": 3
        },{
            "country": "León",
            "litres": 4
        }],
        "valueField": "litres",
        "titleField": "country",
        "labelText": "",
        "export": {
            "enabled": true
        }
    }
);

