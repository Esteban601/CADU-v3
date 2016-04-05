/**
 * Created by Julio Cesar on 4/5/2016.
 */
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

