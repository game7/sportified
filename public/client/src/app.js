export class App {
  configureRouter(config, router) {
    config.title = 'Aurelia';
    config.map([
      { route: ['','games'] , name: 'games' , moduleId: 'games/feature'    , nav: true , title: 'Games' },
      { route: 'calendar'   , name: 'games' , moduleId: 'calendar/feature' , nav: true , title: 'Calendar' }
    ]);

    this.router = router;
  }
}
