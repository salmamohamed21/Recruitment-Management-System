
import React from "react";
import AuthProvider from "./contexts/AuthContext";
import RootContainer from "./containers/RootContainer";

function App() {
  return (
    <AuthProvider>
      <RootContainer />
    </AuthProvider>
  );
}

export default App;






/*import React from "react";
import AuthContextProvider from "./contexts/AuthContext";
import RootContainer from "./containers/RootContainer";

function App() {
  return (
    <AuthContextProvider>
      <RootContainer />
    </AuthContextProvider>
  );
}

export default App;
*/