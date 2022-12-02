import ReactRailsUJS from "react_ujs";

// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
console.log("Vite ⚡️ Rails");

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>

console.log(
  "Visit the guide for more information: ",
  "https://vite-ruby.netlify.app/guide/rails"
);

// Example: Load Rails libraries in Vite.
//
// import * as Turbo from '@hotwired/turbo'
// Turbo.start()
//
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'

(function setupReactComponents() {
  var context = import.meta.globEager("../widgets/*/index.{js,jsx,ts,tsx}");

  var components = {};

  Object.keys(context).forEach((path) => {
    let component = context[path].default;

    `import * as ${component.name} from '${path}'`;

    let name = path.replace("../widgets/", "").split("/")[0];

    components[name] = component;
  });

  console.log(components);
  ReactRailsUJS.getConstructor = (className) => {
    let component = components[className];
    console.log(`Mounting ${component.name} component to ${className}`);
    return component;
  };
})();
