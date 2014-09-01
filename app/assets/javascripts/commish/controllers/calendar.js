App.Calendar = Ember.Namespace.create();

App.Calendar.CalendarController = Ember.ArrayController.extend({
    startOfWeek: 0
  , startOfDay: 8
  , headingDateFormat: 'ddd MMM D'
  , headingTimeFormat: 'h a'
  , headingTimeRangeStart: 0
  , headingTimeRangeEnd: 24
  , eventTimeFormat: 'h:mm a'
  , eventTimeSeparator: ' - '
  , states: ['week']
  , initialState: 'week'
  , presentState: 'week'
    
  , buttonViewClass: 'App.Calendar.ButtonView'
  , headingTimeViewClass: 'App.Calendar.HeadingTimeView'
  , eventViewClass: 'App.Calendar.EventView'
    
  , weekDayViewClass: 'App.Calendar.WeekDayView'
  , weekHeadingDateViewClass: 'App.Calendar.WeekHeadingDateView'
  
  , monthHeadingDayViewClass: 'App.Calendar.MonthHeadingDayView'  
  , monthDayViewClass: 'App.Calendar.MonthDayView' 
    
  , multipleStates: function () {
      return this.get('states').length > 1;
    }.property('states')
  , hasDayState: function () {
      return this.get('states').indexOf('day') !== -1;
    }.property('states')
  , hasWeekState: function () {
      return this.get('states').indexOf('week') !== -1;
    }.property('states')
  , stateIsDay: function () {
      return this.get('presentState') === 'day';
    }.property('presentState')
  , stateIsWeek: function () {
      return this.get('presentState') === 'week';
    }.property('presentState')
    
  , times: function () {
      var times = [];
      var i;
      
      for (i = this.get('headingTimeRangeStart'); i < this.get('headingTimeRangeEnd'); i++) {
        times.push(1000 * 60 * 60 * i);
      }
      
      return times;
    }.property('headingTimeRangeStart', 'headingTimeRangeStart')
    
  , date: null
  , day: function () {
      if (!this.get('date')) { return []; }
      
      var dayStart = this.get('date').clone();
      var dayEnd = this.get('date').clone().endOf('day');
      
      return this.get('content').filter(function (event) {
        return event.get('end') > dayStart && event.get('start') <= dayEnd;
      })

    }.property('content', 'date')
    
  , week: null
  , dateRange: function() {
    var state = this.get('presentState'),
        date = moment(this.get('date')),
        start, end;    
    switch (state) {
      case 'day':
        start = date.clone();
        end = date.clone()
        break;
      case '4day':
        start = date.clone();
        end = date.clone().add('days', 3);
        break;
      case 'week':
        start = date.clone().day(0);
        end = date.clone().day(6);
        break;
      case 'month':
        start = date.clone().date(1).day(0);
        end = date.clone().add('months', 1).date(1).subtract('days', 1).day(6);
        break;
    }
    return {
      start: start,
      end: end,
      days: end.clone().diff(start, 'days') + 1
    }
  }.property('date', 'presentState')
  , weekDates: function () {
      if (!this.get('week')) { return []; }
      
      var curr = this.get('week').clone().subtract('days', 1);
      var dates = [];
      var i;
      
      for (i = 0; i < 7; i++) {
        dates.push(curr.add('days', 1).clone());
      }
      
      return dates;
    }.property('week')
  , days: function() {
    var days = [],
        range = this.get('dateRange');
    for(var i = 0; i < range.days; i++) {
      days.push([]);
    }
    this.get('content').forEach(function(event) {
      var start = moment(event.get('start')).clone(),
          end = moment(event.get('end')).clone(),
          day = start.clone().diff(range.start, 'days')
          
      if (end <= range.start || start > range.end) { return; }
      
      days[day].push(event);
      
    })
    return days;
  }.property('content', 'dateRange', 'state')
  , weekDays: function () {
      if (!this.get('week')) { return []; }
      
      var days = [[], [], [], [], [], [], []];
      var dates = this.get('weekDates');
      var self = this;
      var weekStart = dates[0].clone();
      var weekEnd = dates[6].clone().endOf('day');
      
      this.get('content').forEach(function (event) {
        var start = moment(event.get('start')).clone();
        var end = moment(event.get('end')).clone();
        var object;
        var keys;
        var i;
        var day;
        
        if (end <= weekStart || start > weekEnd) { return; }
        
        while (end > start) {
          object = {};
          keys = Object.keys(event);
          
          for (i = 0; i < keys.length; i++) {
            if (keys[i] !== 'start' && keys[i] !== 'end') {
              object[keys[i]] = event[keys[i]];
            }
          }
          
          object.start = start.clone();
          object.end = start.clone().endOf('day');
          if (object.end > end) { object.end = end.clone(); }
          
          day = object.start.clone().startOf('day').diff(self.get('week'), 'days');
          if (day >= 0 && day <= 6) { days[day].push(event); }
          
          start.add('days', 1).startOf('day');
        }
      });
      
      return days;
    }.property('content', 'weekDates')
    
  , actions: {
        loadPrevious: function () {
          if (this.get('presentState') === 'day') {
            //this.set('date', moment(this.get('date').clone().subtract('days', 1)));
          } else if (this.get('presentState') === 'week') {
            this.set('week', moment(this.get('week').clone().subtract('days', 7)));
          }
          switch (this.get('presentState')) {
            case 'day':
              this.set('date', moment(this.get('date').clone().add('days', -1)));
              break;
            case 'week':
              this.set('date', moment(this.get('date').clone().add('days', -7)));
              break;
            case 'month':
              this.set('date', moment(this.get('date').clone().add('months', -1)));
              break;              
          }          
        }
      , loadNext: function () {
          if (this.get('presentState') === 'day') {
            //this.set('date', moment(this.get('date').clone().add('days', 1)));
          } else if (this.get('presentState') === 'week') {
            this.set('week', moment(this.get('week').clone().add('days', 7)));
          }
          switch (this.get('presentState')) {
            case 'day':
              this.set('date', moment(this.get('date').clone().add('days', 1)));
              break;
            case 'week':
              this.set('date', moment(this.get('date').clone().add('days', 7)));
              break;
            case 'month':
              this.set('date', moment(this.get('date').clone().add('months', 1)));
              break;              
          }
        }
      , changeState: function (state) {
          if (state === this.get('presentState')) {
            return;
          } 
          this.set('presentState', state);
        }
    }
    
  , init: function () {
      this._super();
      
      if (this.states.indexOf('day') !== -1) {
        this.set('date', moment(this.get('initialDate')).startOf('day'));
      }
      
      if (this.states.indexOf('week') !== -1) {
        this.set('week', moment(this.get('initialDate')).subtract((moment(this.get('initialDate')).day() + 7 - this.get('startOfWeek')) % 7, 'days').startOf('day'));
      }
      
      this.set('presentState', this.get('initialState'));
    }
});