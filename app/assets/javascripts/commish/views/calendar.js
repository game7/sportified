///////////////////////////////////////////////////////////////////////////////
// Generic Views
///////////////////////////////////////////////////////////////////////////////
App.Calendar.CalendarView = Ember.View.extend({
  templateName: 'calendar'
});

App.Calendar.ButtonsView = Ember.ContainerView.extend({
  classNames: ['btn-group'],
  init: function () {
    this._super();
    this.pushObject(this.createChildView(Ember.get(this.get('parentView.controller.buttonViewClass')), { buttonState: 'day', controller: this.get('controller') }));
    this.pushObject(this.createChildView(Ember.get(this.get('parentView.controller.buttonViewClass')), { buttonState: 'week', controller: this.get('controller') }));
    this.pushObject(this.createChildView(Ember.get(this.get('parentView.controller.buttonViewClass')), { buttonState: 'month', controller: this.get('controller') }));
  }
});

App.Calendar.ButtonView = Ember.View.extend({
  tagName: 'button',
  classNames: ['btn btn-default'],
  classNameBindings: ['active:active'],
  templateName: function () {
      return 'calendar_button_' + this.get('buttonState');
    }.property('buttonState'),
  templateNameDidChange: function () {
      this.rerender();
    }.observes('templateName'),
  active: function () {
      return this.get('controller.presentState') === this.get('buttonState');
    }.property('buttonState', 'controller.presentState'),
  click: function () {
      if (this.get('active')) return;
      this.get('controller').send('changeState', this.get('buttonState'));
    }
});

App.Calendar.ContainerView = Ember.View.extend({
    classNames: ['ember-calendar']
  , templateName: function () {
      return 'calendar_' + this.get('controller.presentState');
    }.property('controller.presentState')
  , templateNameDidChange: function () {
      this.rerender();
    }.observes('templateName')
  , didInsertElement: function () {
      if (['day', 'week'].indexOf(this.get('controller.presentState')) !== -1) {
        var container = $('#' + this.get('elementId') + ' > .ember-calendar-container');
        var body = $('#' + this.get('elementId') + ' > .ember-calendar-container > .ember-calendar-body');
        var start = (this.get('controller.startOfDay') - this.get('controller.headingTimeRangeStart')) / (this.get('controller.headingTimeRangeEnd') - this.get('controller.headingTimeRangeStart'));
        
        container.scrollTop(start * body.height());
      }
    }
});

App.Calendar.HeadingDateView = Ember.View.extend({
    templateName: 'calendar_head_date'
  , classNames: ['ember-calendar-head-date']
  , dateString: function () {
      return this.get('date').format(this.get('controller.headingDateFormat'));
    }.property('date')
});

App.Calendar.HeadingTimesView = Ember.ContainerView.extend({
    classNames: ['ember-calendar-head-times']
  , updateChildViews: function () {
      var self = this;
      self.removeAllChildren();
      self.pushObjects(self.get('times').map(function (time) {
        return self.createChildView(Ember.get(self.get('controller.headingTimeViewClass')), { time: time });
      }));
    }.observes('times')
  , init: function () {
      this._super();
      this.updateChildViews();
    }
});

App.Calendar.HeadingTimeView = Ember.View.extend({
    templateName: 'calendar_head_time'
  , classNames: ['ember-calendar-head-time']
  , timeString: function () {
      return moment().startOf('day').add('milliseconds', this.get('time')).format(this.get('parentView.parentView.controller.headingTimeFormat'));
    }.property('time')
});

App.Calendar.DayView = Ember.ContainerView.extend({
    classNames: ['ember-calendar-day']
  , updateChildViews: function () {
      var self = this;
      self.removeAllChildren();
      self.pushObjects(self.get('events').map(function (event) {
        return self.createChildView(Ember.get(self.get('parentView.controller.eventViewClass')), { event: event, parentView: self.get('parentView') });
      }));
    }.observes('events')
  , init: function () {
      this._super();
      this.updateChildViews();
    }
});

App.Calendar.EventView = Ember.View.extend({
    templateName: 'ember-calendar-event'
  , classNames: ['ember-calendar-event']
  , attributeBindings: ['style']
  , style: function () {
      if (!this.get('event')) {
        return '';
      }
      
      var start = moment(this.get('event.start')).valueOf();
      var end = moment(this.get('event.end')).valueOf();
      var rangeStart = moment(start).startOf('day').valueOf() + 1000 * 60 * 60 * this.get('parentView.controller.headingTimeRangeStart');
      var rangeEnd = moment(start).startOf('day').valueOf() + 1000 * 60 * 60 * this.get('parentView.controller.headingTimeRangeEnd');
      
      return 'top: ' + 100 * (start - rangeStart) / (rangeEnd - rangeStart) + '%; height: ' + 100 * (end - start) / (rangeEnd - rangeStart) + '%;';
    }.property('event', 'event.start', 'event.end')
  , nameString: function () {
      if (!this.get('event')) {
        return '';
      }
      return this.get('event.name');
    }.property('event', 'event.name')
  , timeString: function () {
      if (!this.get('event')) {
        return '';
      }
      return moment(this.get('event.start')).format(this.get('parentView.controller.eventTimeFormat')) + this.get('parentView.controller.eventTimeSeparator') + moment(this.get('event.end')).format(this.get('parentView.controller.eventTimeFormat'));
    }.property('event', 'event.start', 'event.end')
  , locationString: function () {
      if (!this.get('event') || !this.get('event.location')) {
        return '';
      }
      return this.get('event.location.name') || this.get('event.location.address');
    }.property('event', 'event.location')
});


///////////////////////////////////////////////////////////////////////////////
// Week Views
///////////////////////////////////////////////////////////////////////////////
App.Calendar.WeekHeadingDatesView = Ember.ContainerView.extend({
    classNames: ['ember-calendar-head-dates']
  , updateChildViews: function () {
      var self = this;
      self.removeAllChildren();
      self.pushObjects(self.get('dates').map(function (date) {
        return self.createChildView(Ember.get(self.get('parentView.controller.weekHeadingDateViewClass')), { date: date });
      }));
    }.observes('dates')
  , init: function () {
      this._super();
      this.updateChildViews();
    }
});

App.Calendar.WeekHeadingDateView = App.Calendar.HeadingDateView.extend({
    templateName: 'ember-calendar-head-date'
  , classNames: ['ember-calendar-head-week-date']
  , dateString: function () {
      return this.get('date').format(this.get('parentView.parentView.controller.headingDateFormat'));
    }.property('date')
});

App.Calendar.WeekDaysView = Ember.ContainerView.extend({
    classNames: ['ember-calendar-days']
  , updateChildViews: function () {
      var self = this;
      self.removeAllChildren();
      self.pushObjects(self.get('days').map(function (events) {
        return self.createChildView(Ember.get(self.get('parentView.controller.weekDayViewClass')), { events: events, parentView: self.get('parentView') });
      }));
    }.observes('days')
  , init: function () {
      this._super();
      this.updateChildViews();
    }
});

App.Calendar.WeekDayView = App.Calendar.DayView.extend({
    classNames: ['ember-calendar-week-day']
  , updateChildViews: function () {
      var self = this;
      self.removeAllChildren();
      self.pushObjects(self.get('events').map(function (event) {
        return self.createChildView(Ember.get(self.get('parentView.controller.eventViewClass')), { event: event, parentView: self.get('parentView') });
      }));
    }.observes('events')
});

///////////////////////////////////////////////////////////////////////////////
// Month Views
///////////////////////////////////////////////////////////////////////////////
App.Calendar.MonthHeadingDaysView = Ember.ContainerView.extend({
    classNames: ['ember-calendar-head-dates']
  , updateChildViews: function () {
      var self = this;
      self.removeAllChildren();
      for(i = 0; i < 7; i++) {
        this.pushObject(self.createChildView(Ember.get(self.get('parentView.controller.monthHeadingDayViewClass')), { day: i }));
      }
    }.observes('dates')
  , init: function () {
      this._super();
      this.updateChildViews();
    }
});

App.Calendar.MonthHeadingDayView = App.Calendar.HeadingDateView.extend({
    templateName: 'ember-calendar-head-date'
  , classNames: ['ember-calendar-head-week-date']
  , dateString: function () {
      return moment().isoWeekday(this.get('day')).format('ddd');
    }.property('day')
});

App.Calendar.MonthWeeksView = Ember.ContainerView.extend({
  classNames: ['ember-calendar-weeks'],
  weeks: function() {
    var days = this.get('days').slice(),
        weeks = [];
    while(days.length > 0) {
      weeks.push(days.splice(0, 7));
    }
    return weeks;
  }.property('days'),
  updateChildViews: function () {
    var self = this;
    self.removeAllChildren();
    self.pushObjects(self.get('weeks').map(function (days, index) {
      return self.createChildView(Ember.get('App.Calendar.MonthDaysView'), { week: index, days: days, parentView: self.get('parentView') });
    }));
  }.observes('weeks'),
  init: function () {
    this._super();
    this.updateChildViews();
  }
});


App.Calendar.MonthDaysView = Ember.ContainerView.extend({
    classNames: ['ember-calendar-month-week']
  , updateChildViews: function () {
      var self = this,
          week = this.get('week'),
          date;
      self.removeAllChildren();
      self.pushObjects(self.get('days').map(function (events, index) {
        date = self.get('parentView.controller.dateRange').start.clone().add((week * 7) + index, 'days');
        return self.createChildView(Ember.get(self.get('parentView.controller.monthDayViewClass')), { date: date.clone() ,events: events, parentView: self.get('parentView') });
      }));
    }.observes('days')
  , init: function () {
      this._super();
      this.updateChildViews();
    }
});

App.Calendar.MonthDateView = Ember.View.extend({
  templateName: 'calendar_month_date'
});

App.Calendar.MonthDayView = App.Calendar.DayView.extend({
    classNames: ['ember-calendar-day ember-calendar-month-day']
  , updateChildViews: function () {
      var self = this,
          date = this.get('date'),
          day = date.date() == 1 ? date.format('MMM D') : date.format('D');
      self.removeAllChildren();
      self.pushObject(self.createChildView(Ember.get('App.Calendar.MonthDateView'), { day: day }));
      self.pushObjects(self.get('events').map(function (event) {
        return self.createChildView(Ember.get('App.Calendar.MonthEventView'), { event: event, parentView: self.get('parentView') });
      }));
    }.observes('events')
});

App.Calendar.MonthEventView = Ember.View.extend({
  templateName: 'calendar_month_event',
  classNames: ['ember-calendar-month-event'],
  nameString: function () {
    if (!this.get('event')) {
      return '';
    }
    return this.get('event.name');
  }.property('event', 'event.name'),
  timeString: function () {
    if (!this.get('event')) {
      return '';
    }
    return moment(this.get('event.start')).format(this.get('parentView.controller.eventTimeFormat')) + this.get('parentView.controller.eventTimeSeparator') + moment(this.get('event.end')).format(this.get('parentView.controller.eventTimeFormat'));
  }.property('event', 'event.start', 'event.end'),
  locationString: function () {
    if (!this.get('event') || !this.get('event.location')) {
      return '';
    }
    return this.get('event.location.name') || this.get('event.location.address');
  }.property('event', 'event.location')
});