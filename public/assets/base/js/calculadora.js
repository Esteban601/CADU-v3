/**
 * Created by yoidel on 9/7/2017.
 */

/**UTILES**/
$.fn.datepicker.defaults.language = 'es';
Date.prototype.yyyymmdd = function() {
    var mm = this.getMonth() + 1; // getMonth() is zero-based
    var dd = this.getDate();

    return [this.getFullYear(),
        (mm>9 ? '' : '0') + mm,
        (dd>9 ? '' : '0') + dd
    ].join('-');
};

var date = new Date();
// console.log(date.yyyymmdd());

//
// console.log(numberWithCommas(123456))
// console.log(numberWithCommas(123456.12))



var cbis= 0;
var start_date = "0";
var end_date ="0";
var date_edate = Date.now();
var date_sdate = Date.now();
var fecha_inicio = new Date(Date.parse(distribuciones[0]["fecha"]))
// console.log(fecha_inicio.yyyymmdd(),"FECHA DE INICIO");
// var startDatePicker = {};
$('#end_date').datepicker({endDate:date,startDate:fecha_inicio}).on("changeDate", function (e) {
    date_edate= e.date;
    end_date = e.date.yyyymmdd();
    validarValores();
  //  $('#start_date').data('datepicker').setEndDate(e.date);
  //   calcularInversion(cbis,start_date,end_date);
});
$('#start_date').datepicker({endDate:date,startDate:fecha_inicio}).on("changeDate", function (e) {
     date_sdate = e.date;
    start_date = e.date.yyyymmdd();
    validarValores();
    //$('#end_date').data('datepicker').setStartDate(e.date);
    //calcularInversion(cbis,start_date,end_date);
});


$("#cbfis").on("change",function(a){
    cbis = $(a.currentTarget).val();
    console.log($(a.currentTarget).val());
    validarValores();
});

$("#calculate").on("click",function (a) {
    console.log("CLACULANDO");
    if(validarValores()){
        calcularInversion(cbis,start_date,end_date);
    }
});
function validarValores(){
    console.log("validando",cbis,start_date,end_date);
    var error = false;
    if(cbis<=0||isNaN(cbis)){
        $("#group_cbfi").addClass("has-error");
        error = true;
    }else{
        $("#group_cbfi").removeClass("has-error");
    }
    if(start_date==0||start_date<=end_date||end_date==0){
        $(".group-fechas").removeClass("has-error");
    }else{
        error = true;
        $(".group-fechas").addClass("has-error");
    }
    if(start_date==0||end_date==0){
        error = true;
    }
    if(!error) {
        $("#calculate").removeClass("disabled");
    }else{
        if(!$("#calculate").hasClass("disabled")) {
            $("#calculate").addClass("disabled");
        }
    }
    return !error;
}
function calcularInversion(cbis,sd,ed){

    if(cbis!=0&&sd!="0"&&ed!="0") {
        //http://marktdaten.irstrat.com
        var api_url = "https://marktdaten.irstrat.com/intradate/147.json?date=";
        // var api_url = "http://h-kont.herokuapp.com/api/laste/FMTY?date=";
        var start_url = api_url+start_date;
        var end_url = api_url+end_date;
        console.log("comienza");
        var div_recibido = calcularDistribuciones(cbis,sd,ed);
        var difFecha= Math.floor((date_edate - date_sdate)/86400000);
        console.log(difFecha);
        console.log((date_edate - date_sdate));
        $.ajax({
            dataType: "jsonp",
            url: start_url,
            data: {},
            success: function (data) {
                console.log("buscando con AJAX");
                var cierre_i = data.precios[0].close;
                var monto = (cierre_i * cbis).toFixed(2);
                $("#precio_i").html("$"+WithCommas(cierre_i));
                $("#cantidad_i").html(WithCommas(cbis));
                $("#monto_i").html("$"+WithCommas(monto));
                console.log("TERMINO INICIAL");
                $.ajax({
                    dataType: "jsonp",
                    url: end_url,
                    data: {},
                    success: function (data) {
                        console.log("buscando con AJAX2");
                        var cierre_f = data.precios[0].close*1;
                        var monto_f = cierre_f * cbis;
                        var rendimiento= (monto_f-monto).toFixed(2);

                        var rendimientop = ((monto_f/monto-1)*100).toFixed(2);

                        var total = div_recibido + (monto_f-monto);
                        var totalp = total/monto*100;

                        var totalAnualizado = (totalp/(difFecha))*360;


                        $("#precio_f").html("$"+WithCommas(cierre_f.toFixed(2)));
                        $("#monto_f").html("$"+WithCommas(monto_f.toFixed(2)));
                        $("#rendimiento").html("$"+WithCommas(rendimiento));
                        $("#rendimiento_p").html(WithCommas(rendimientop)+"%");

                        $("#rendimiento_t").html("$"+WithCommas(total.toFixed(2)));
                        $("#rendimiento_tp").html(WithCommas(totalp.toFixed(2))+"%");
                        $("#rendimiento_a").html(WithCommas(totalAnualizado.toFixed((2)))+"%");
                        console.log("TERMINO FINAL");
                    }
                });
            }
        });
    }
    // 2017-09-05
}

function calcularDistribuciones(cbis,sd,ed){

    var start = Date.parse(sd);
    var end = Date.parse(ed);
    var distribperiodo = 0;
    distribuciones.forEach(function(item,index){
        var fecha_d=Date.parse(item["fecha"]);
        var fecha_f=Date.parse(item["fechaf"]);
        if( start<=fecha_f && end>=fecha_f ){
            console.log(fecha_d,fecha_f,start,end,item["value"]);
            distribperiodo+=item["value"];
        }
    });
    var result2 = cbis*distribperiodo;
    $("#cantidad_d").html(WithCommas(cbis));
    $("#dividendos_p").html("$"+WithCommas(Math.round(distribperiodo * 10000) / 10000));
    $("#monto_d").html("$"+WithCommas(Math.round(result2 * 10000) / 10000));
    return result2;

}
function WithCommas(x) {

    var numbersString = x.toString();
    if (numbersString.indexOf(".") >=0)
    {
        var arreglo = numbersString.split(".");
        var numberComa= arreglo[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");

        return numberComa +"."+arreglo[1];
    }
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

}
