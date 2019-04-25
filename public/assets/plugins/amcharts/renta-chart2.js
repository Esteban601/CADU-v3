/**
 * Created by Julio Cesar on 4/7/2016.
 */
var colors = ["#B7CEE5","#F04C23","#98ACBF","#333940","#7F2813","#E54921","#CBE5FF","#66737F","#FF5125","#401409",];
var chart;
var legend;
var selected;

if (locale == "es") {
    var deuda = "Deuda Bancaria";
    var puente = "Créditos Puente";
    var reserva = "Reserva Territorial";
    var capital = "Capital de trabajo";
    var arren="Arrendamiento Financiero";
}
else {
    var deuda = "Bank Loans";
    var puente = "Bridge Loans";
    var reserva = "Land Bank";
    var capital = "Working Capital";
    var arren="Financial Leases";
}

var types = [{
    type: deuda,
    percent: 3036,
    color: "#B7CEE5",
    subs: [
        { type: capital, percent: 963 },
        { type: puente, percent: 2059 },
        { type: reserva, percent: 14 },
        { type: arren, percent: 1 },


    ]},
    {
        type: "CADU15",
        percent: 120,
        color: "#F04C23"
        //subs: [
        //    { type: "Hydro", percent: 15 },
        //    { type: "Wind", percent: 10 },
        //    { type: "Other", percent: 5 }
        //]
    },
    {
        type: "CADU18",
        percent: 500,
        color: "#333940"
        //subs: [
        //    { type: "Hydro", percent: 15 },
        //    { type: "Wind", percent: 10 },
        //    { type: "Other", percent: 5 }
        //]
    }
];

function generateChartData () {
    var chartData = [];
    for (var i = 0; i < types.length; i++) {
        if (i == selected) {
            for (var x = 0; x < types[i].subs.length; x++) {
                chartData.push({
                    type: types[i].subs[x].type,
                    percent: types[i].subs[x].percent,
                    color: types[i].color,
                    pulled: true
                });
            }
        }
        else {
            chartData.push({
                type: types[i].type,
                percent: types[i].percent,
                color: types[i].color,
                id: i
            });
        }
    }
    return chartData;
}

AmCharts.ready(function() {
    // PIE CHART
    chart = new AmCharts.AmPieChart();
    //chart.startAngle = 270;
    chart.dataProvider = generateChartData();
    chart.titleField = "type";
    chart.valueField = "percent";
    chart.balloonText= "[[type]]: $[[percent]]";
    //chart.outlineColor = "#FFFFFF";
    //chart.outlineAlpha = 0.8;
    //chart.outlineThickness = 2;
    chart.colorField = "color";
    chart.pulledField = "pulled";

    //chart.path = "http://www.amcharts.com/lib/3/";

    // ADD TITLE
    //chart.addTitle("Click a slice to see the details");

    // AN EVENT TO HANDLE SLICE CLICKS
    chart.addListener("clickSlice", function (event) {
        if (event.dataItem.dataContext.id != undefined) {
            selected = event.dataItem.dataContext.id;
        }
        else {
            selected = undefined;
        }
        chart.dataProvider = generateChartData();
        chart.validateData();
    });

    // WRITE
    chart.write("chartdiv");
});
