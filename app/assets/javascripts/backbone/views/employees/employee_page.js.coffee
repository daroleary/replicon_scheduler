class RepliconScheduler.Views.EmployeePage extends Backbone.View

  initialize: ->
    # TODO: Recommend fetching data using Ajax and Adding a spinner while waiting for it to load
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
