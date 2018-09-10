/**
 * Para modificar este archivo seguir las siguientes instrucciones
 * Created by saul on 9/13/2017.
 */
if (locale == "es") {
    var periodos = ["1T15", "2T15", "3T15", "4T15", "1T16", "2T16", "3T16", "4T16", "1T17", "2T17", "3T17", "4T17", "1T18", "2T18"];

}
else {
    var periodos = ["1Q15", "2Q15", "3Q15", "4Q15", "1Q16", "2Q16", "3Q16", "4Q16", "1Q17", "2Q17", "3Q17", "4Q17", "1Q18", "2Q18"];

}

var distribuciones = [
    {
        "fecha": "2016-01-01",
        "fechaf": "2016-05-25",
        "perido": periodos[0],
        "value": 0.38
    },
    {
        "fecha": "2016-05-26",
        "fechaf": "2016-06-22",
        "perido": periodos[1],
        "value": 0.28
    },
    {
        "fecha": "2016-06-23",
        "fechaf": "2017-07-24",
        "perido": periodos[2],
        "value": 0.33
    },
    {
        "fecha": "2017-07-25",
        "fechaf": "2017-09-19",
        "perido": periodos[3],
        "value": 0.33
    },
    {
        "fecha": "2017-09-19",
        "fechaf": "2018-05-15",
        "perido": periodos[4],
        "value": 0.375
    },
    {
        "fecha": "2018-05-16",
        "fechaf": "2018-08-23",
        "perido": periodos[5],
        "value": 0.375
    },
    //     "fecha": "2016-07-19",
    //     "fechaf": "2016-09-30",
    //     "perido": periodos[6],
    //     "value": 0.2373
    // }, {
    //     "fecha": "2016-10-01",
    //     "fecha": "2016-12-31",
    //     "perido": periodos[7],
    //     "value": 0.2580
    // }, {
    //     "fecha": "2017-01-01",
    //     "fechaf": "2017-03-31",
    //     "perido": periodos[8],
    //     "value": 0.2739
    // }, {
    //     "fecha": "2017-04-01",
    //     "fechaf": "2017-06-30",
    //     "perido": periodos[9],
    //     "value": 0.2559
    // }
    // , {
    //     "fecha": "2017-07-01",
    //     "fechaf": "2017-09-30",
    //     "perido": periodos[10],
    //     "value": 0.2437
    // }, {
    //     "fecha": "2017-10-01",
    //     "fechaf": "2017-12-31",
    //     "perido": periodos[11],
    //     "value": 0.26
    // }, {
    //     "fecha": "2018-01-01",
    //     "fechaf": "2018-03-31",
    //     "perido": periodos[12],
    //     "value": 0.258
    // }, {
    //     "fecha": "2018-04-01",
    //     "fechaf": "2018-06-30",
    //     "perido": periodos[13],
    //     "value": 0.274
    // }
];
