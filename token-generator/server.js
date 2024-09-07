const http = require('http');
const url = require('url');
const querystring = require('querystring');
const stream = require('getstream');

// Your GetStream API key and secret key
const apiKey = '2xfq4z5mrh6f';
const secretKey = 'nbh3qg8f3qzhbh9jyc96tqgww63qusp3zv2b7euprjz6wfdpx4s3da6sma4p9a8x';

// Initialize the Stream client
const client = stream.connect(apiKey, secretKey);

// Create the server
const server = http.createServer((req, res) => {
  const parsedUrl = url.parse(req.url);
  const query = querystring.parse(parsedUrl.query);

  // Check if the required parameters are present
  if (parsedUrl.pathname === '/api/auth/create-token' && query.user_id && query.environment) {
    // Generate a token for the user ID
    const userToken = client.createUserToken(query.user_id);

    // Send the response with the user_id, api_key, and token, without the environment name
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      user_id: query.user_id,
      api_key: apiKey,
      token: userToken,
    }));
  } else {
    res.writeHead(400, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Missing required parameters: user_id and environment' }));
  }
});

// Start the server
const PORT = 3000;
server.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
});
