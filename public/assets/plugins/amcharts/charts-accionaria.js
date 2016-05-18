/**
 * Created by Julio Cesar on 4/5/2016.
 */
window.onload = function() {
    // all of your code goes in here
    // it runs after the DOM is built
    var colors = ["#B7CEE5","#F04C23","#98ACBF","#333940","#7F2813","#E54921","#CBE5FF","#66737F","#FF5125","#401409",];
    var chart = AmCharts.makeChart(
        "acc", {
            "type": "pie",
            "startDuration": 0,
            "theme": "light",
            "addClassNames": true,
            "colors":colors,
            "legend":{
                "position":"bottom",
                "align":"center",
                "valueText": " [[percents]]%"
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
                "title": "Grupo de Control",
                "data": 66.39
            },{
                "title": "Público inversionista",
                "data": 33.61
            }],
            "valueField": "data",
            "titleField": "title",
             "balloonText": "<span style='font-size:10px'>[[title]]: <b>[[data]]%</b></span>", //eliminando valor de ballon
            "labelText": "",
            "export": {
                "enabled": true
            }
        }
    );


}
