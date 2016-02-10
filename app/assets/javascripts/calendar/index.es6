
class IndexCtrl  {

  constructor($scope, $compile, $timeout, uiCalendarConfig) {
    
    $scope.events = events.map((evt) => {
      return {
        id: evt.id,
        title: evt.summary,
        start: evt.starts_on,
        end: evt.ends_on,
        allDay: false
      };
    });
    
    $scope.eventSources = [ $scope.events ];

    $scope.changeView = (view, calendar) => {
      uiCalendarConfig.calendars[calendar].fullCalendar('changeView',view)
    }
 
    $scope.renderCalender = (calendar) => {
      if (uiCalendarConfig.calendars[calendar]) {
        uiCalendarConfig.calendars[calendar].fullCalendar('render');     
      }
    }

    $scope.eventRender = (event, element, view) => {
      element.attr({
        'tooltip': event.title,
        'tooltip-append-to-body': true        
      })
      $compile(element)($scope)      
    }

    $scope.uiConfig = {
      calendar: {
        height: 450,
        editable: true,
        header:{
          left: 'month basicWeek basicDay agendaWeek agendaDay',
          center: 'title',
          right: 'today prev,next' 
        },
        // eventClick: $scope.alertOnEventClick,
        // eventDrop: $scope.alertOnDrop,
        // eventResize: $scope.alertOnResize,
        eventRender: $scope.eventRender
      }

    }

  }

}

IndexCtrl.$inject = ['$scope', '$compile', '$timeout', 'uiCalendarConfig'];
CalendarApp.controller('IndexCtrl', IndexCtrl);
