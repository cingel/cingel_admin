Dashboard = {
  loadingStatusDiv: null,
  reportsWrapper: null,
  datepickerWrapper: null,
  datepickerStart: null,
  datepickerEnd: null,
  periodSelect: null,
  startDate: null,
  endDate: null,
  chart: null,
  chartWrapper: null
};

Dashboard.observePeriodSelect = function() {
  Dashboard.periodSelect = $("#period");
  Dashboard.periodSelect.change(function() {
    var period = Dashboard.periodSelect.val();
    if (period == "current") {
      return false;
    } else if (period == "custom") {
      Dashboard.datepickerWrapper.show();
    } else {
      Dashboard.getAnalyticsData(period);
    }
  });
};

Dashboard.getAnalyticsData = function(period) {
  var data = {}
  if (period == "datepicker") {
    data.start_date = $.datepicker.formatDate("yy-mm-dd", Dashboard.datepickerStart.datepicker('getDate'));
    data.end_date = $.datepicker.formatDate("yy-mm-dd", Dashboard.datepickerEnd.datepicker('getDate'));
  } else if (period) {
    var periodArray = period.split("_");
    data.start_date = periodArray[0];
    data.end_date = periodArray[1];
  }
  if (data.start_date == Dashboard.startDate && data.end_date == Dashboard.endDate) {
    Dashboard.periodSelect.val("current");
  } else {
    $.ajax({
      url: '/admin/dashboard/get_analytics_data',
      data: data,
      beforeSend: function() {
        Dashboard.periodSelect.attr("disabled", "disabled");
        Dashboard.loadingStatusDiv.html('<img src="/images/cingel_admin/loader.gif" alt="" />');
        Dashboard.reportsWrapper.fadeTo("fast", 0.3);
        Dashboard.chartWrapper.fadeTo("fast", 0.3);
      },
      success: function() {
        Dashboard.loadingStatusDiv.html("");
        Dashboard.periodSelect.removeAttr("disabled");
        Dashboard.periodSelect.val("current");
        Dashboard.reportsWrapper.fadeTo("fast", 1);
        Dashboard.chartWrapper.fadeTo("fast", 1);
      },
      error: function() {
        Dashboard.loadingStatusDiv.html("Error loading data!");
      }
    });
  }
};

Dashboard.initVariables = function() {
  Dashboard.loadingStatusDiv = $("#dashboard_loading_status");
  Dashboard.datepickerWrapper = $("#datepicker_wrapper");
  Dashboard.datepickerStart = $("#datepicker_start");
  Dashboard.datepickerEnd = $("#datepicker_end");
  Dashboard.reportsWrapper = $("#reports_wrapper");
  Dashboard.chartWrapper = $("#chart_wrapper");
};

Dashboard.initDatepicker = function() {
  $.datepicker.setDefaults({
    showButtonPanel: true,
    maxDate: '0'
  });
  Dashboard.datepickerStart.datepicker({ defaultDate: '-1m' });
  Dashboard.datepickerEnd.datepicker();
};

$(document).ready(function() {
  if ($("#chart_wrapper").size() > 0) {
    Dashboard.initVariables();
    Dashboard.initDatepicker();
    Dashboard.observePeriodSelect();
    Dashboard.getAnalyticsData();

    Dashboard.chart = new Highcharts.Chart({
      chart: { 
        renderTo: 'chart_wrapper',
        defaultSeriesType: 'line'
      },
      title: { text: null },
      xAxis: {
        type: 'datetime',
        dateTimeLabelFormats: {
         day: '%b %e',
         week: '%b %e'
        }
      },
      yAxis: [
        { min: 0, title:  { text: "Visits / Visitors" } },
        { min: 0, title:  { text: "Pageviews" }, opposite: true }
      ],
      tooltip: {
        formatter: function() {
          return Highcharts.dateFormat('%b %e', this.x) + ': <b>' + this.y + '</b>' + this.series.name;
        }
      },
      series: [
        { name: "Visitors", data: [], pointInterval: 24*3600*1000, yAxis: 0, visible: false },
        { name: "Visits", data: [], pointInterval: 24*3600*1000, yAxis: 0 },
        { name: "Pageviews", data: [], pointInterval: 24*3600*1000, yAxis: 1, visible: false }
      ]
    }); 
  }
});