//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function () {
    var series = {};
    var recentResults = {};
    var previousResults = {};
    var colorMap = {};
    var colors = ["11FD2C", "FC09D4", "17D6FF", "ED9E20", "F9E732", "04CEA5", "FF254E", "B00C22"];

    var graph = new SmoothieChart({minValue: -1, maxValue: 10000, millisPerPixel: 100, grid: {verticalSections: 4, millisPerLine: 5000}});
    graph.streamTo($("#graph").get(0), 10000);

    updateData();
    setInterval(updateData, 10000);

    function updateData() {
        $.ajax({
            url: "/results",
            success: function (msg, status) {
                var when = new Date().getTime();
                var i = 0;

                for(var obj in msg) {
                    obj = msg[obj];
                    instance = null;

                    if(series[obj.name] == null) {
                        instance = new TimeSeries();
                        series[obj.name] = instance;
                        colorMap[obj.name] = colors[i++];
                        graph.addTimeSeries(instance, {lineWidth: 3, strokeStyle: colorMap[obj.name]});
                    } else {
                        instance = series[obj.name];
                    }

                    console.log("Plotting " + obj.name + " at " + obj.players_online)
                    instance.append(when, obj.players_online);
                }
            }
        });
    }

    function randomColor() {
        return '#' + Math.floor(Math.random()*16777215).toString(16);
    }
});