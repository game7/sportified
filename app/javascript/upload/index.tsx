import * as React from 'react';
import * as ReactDOM from 'react-dom';
import Router from './router';
import './index.css';

// Hot Module Reload for typescript
// http://blog.tomduncalf.com/posts/setting-up-typescript-and-react/#adding-hot-module-reloading
// declare var module: { hot: any };
// declare var require: {
//     (path: string): any;
//     <T>(path: string): T;
//     (paths: string[], callback: (...modules: any[]) => void): void;
//     ensure: (paths: string[], callback: (require: <T>(path: string) => T) => void) => void;
// };

process.env.API_BASE = '/';


// const { AppContainer } = require('react-hot-loader');
const rootEl = document.getElementById('uploader');

// ReactDOM.render(
//   <AppContainer>
//     <Router/>
//   </AppContainer>,
//   rootEl
// );

ReactDOM.render(
  <Router/>,
  rootEl
);

// if (module.hot) {
//   module.hot.accept('./router', () => {
//     const NextRouter = require('./router').default;
//     console.log('next router')
//     ReactDOM.render(
//       <AppContainer>
//         <NextRouter/>
//       </AppContainer>,
//       rootEl
//     );
//   })
// }
