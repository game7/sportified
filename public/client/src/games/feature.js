export class Feature {
  
  configureRouter(config, router) {
    config.title = 'Aurelia';
    config.map([
      { route: '', name: 'index', moduleId: 'games/index', nav: true, title: 'Games' },
    ]);

    this.router = router;
  }

}
