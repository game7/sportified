export class Feature {
  
  configureRouter(config, router) {
    config.map([
      { route: '', name: 'calendar/index', moduleId: 'calendar/index', nav: true, title: 'Calendar' },
    ]);

    this.router = router;
  }

}
