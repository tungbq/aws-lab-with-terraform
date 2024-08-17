#!/bin/bash
# app.sh

# Install Node.js
sudo apt-get update
sudo apt-get install -y nodejs npm

# Create a simple Node.js app
cat <<EOL > /home/ubuntu/app.js
const http = require('http');
const hostname = '0.0.0.0';
const port = 8080;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello from the App Tier\n');
});

server.listen(port, hostname, () => {
  console.log(\`Server running at http://\${hostname}:\${port}/\`);
});
EOL

# Run the Node.js app
node /home/ubuntu/app.js &
