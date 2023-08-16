const http = require('http');
const url = require('url');
const querystring = require('querystring');

// Controller for handling different routes
const NilaiController = {
  getNilaiAkhir: (req, res) => {
    res.sendText('This is the Nilai Akhir endpoint');
  },
};

const routes = {
  'GET': {
    '/nilai-akhir': NilaiController.getNilaiAkhir,
  },
};

function parseBody(req, callback) {
  let body = '';
  req.on('data', (chunk) => {
    body += chunk.toString();
  });

  req.on('end', () => {
    if (req.headers['content-type'] === 'application/json') {
      callback(JSON.parse(body));
    } else if (req.headers['content-type'] === 'application/x-www-form-urlencoded') {
      callback(querystring.parse(body));
    } else {
      callback(body);
    }
  });
}

function sendResponse(res, statusCode, data) {
  res.statusCode = statusCode;

  if (typeof data === 'object') {
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify(data));
  } else {
    res.setHeader('Content-Type', 'text/plain');
    res.end(data);
  }
}

const server = http.createServer((req, res) => {
  const method = req.method;
  const parsedUrl = url.parse(req.url, true);
  const path = parsedUrl.pathname;

  // Set response methods
  res.sendText = (data) => sendResponse(res, 200, data);
  res.sendJson = (data) => sendResponse(res, 200, data);

  // Routing based on method and URL
  if (method in routes && path in routes[method]) {
    if (['POST', 'PUT'].includes(method)) {
      parseBody(req, (body) => {
        req.body = body;
        routes[method][path](req, res);
      });
    } else {
      routes[method][path](req, res);
    }
  } else {
    res.sendText('Not Found', 404);
  }
});

const PORT = 8080;
server.listen(PORT, () => {
  console.log(`Server is listening on port ${PORT}`);
});
