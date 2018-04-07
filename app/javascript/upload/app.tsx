import * as React from 'react';
import 'whatwg-fetch';

const App: React.SFC<{}> = (props) => (
  <div>
    {props.children}
  </div>
);

export default App;
