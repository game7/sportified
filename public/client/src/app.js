export class App {
  configureRouter(config, router) {
    config.title = 'Aurelia';
    config.map([
      { route: ['', 'games'], name: 'games',      moduleId: 'games/feature',      nav: true, title: 'Games' }
    ]);

    this.router = router;
  }
}
