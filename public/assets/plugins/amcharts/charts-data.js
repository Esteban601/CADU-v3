AmCharts.makeChart(
    "vrp", {
        "type": "pie",
        "startDuration": 0,
        "theme": "light",
        "addClassNames": true,
        "legend":{
            "position":"bottom"
            //"marginRight":100,
            //"autoMargins":false
        },
        "innerRadius": "0",
        "radius": "50%",
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
        "legend":{
            "position":"bottom"
            //"marginRight":100,
            //"autoMargins":false
        },
        "innerRadius": "0",
        "radius": "50%",
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
window.onload = function() {
    // all of your code goes in here
    // it runs after the DOM is built
    var chart = AmCharts.makeChart(
        "acc", {
            "type": "pie",
            "startDuration": 0,
            "theme": "light",
            "addClassNames": true,
            "legend":{
                "position":"bottom"
                //"marginRight":100,
                //"autoMargins":false
            },
            "innerRadius": "0",
            "radius": "50%",
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
                "title": "Familia Vaca Elguero",
                "data": 59
            },{
                "title": "Público inversionista",
                "data": 34
            },{
                "title": "Otros",
                "data": 7
            }],
            "valueField": "data",
            "titleField": "title",
            "labelText": "",
            "export": {
                "enabled": true
            }
        }
    );
}