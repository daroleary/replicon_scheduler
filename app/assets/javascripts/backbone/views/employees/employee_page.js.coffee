class RepliconScheduler.Views.EmployeePage extends Backbone.View

  initialize: ->
    $('#calendar').fullCalendar({
      defaultDate: moment($('#calendar').data('start-date')),
      header: {
        center: false,
        right: false,
      },
      events: $('#calendar').data('events'),
      eventRender: (event, element) ->
        element.attr('id', event.id);
    });
