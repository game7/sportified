// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
console.log('Vite ⚡️ Rails')

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>

console.log('Visit the guide for more information: ', 'https://vite-ruby.netlify.app/guide/rails')

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

// Support component names relative to this directory:

// Load react components for react_rails
// vite support: https://github.com/reactjs/react-rails/issues/1134
const context = import.meta.globEager('../components/*/index.{js,jsx,ts,tsx}');
const pattern = new RegExp('components/(.+)/index')
Object.keys(context).forEach((path) => {
  let matches = path.match(pattern)
  let componentName = matches[1]
  let component = context[path]
  window[componentName] = component.default;
});

import "react_ujs"
