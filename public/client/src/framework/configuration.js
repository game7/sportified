
export class Configuration {

  constructor() {
    this.configure_api();
  }

  configure_api() {
    this.api = {};

    let hostname = window.location.hostname;
    let local = "localhost";

    this.api.baseUrl = (hostname.search(local) !== -1) ? 'api/' : '/api/';

  }

}
