## Testing the backend web services

The various backend web services can be tested by a variety of tools/commands that are capable of generating GET, POST,
PUT, and DELETE HTTP requests.

Two fairly simple means of doing so are described below:

### Using test script: test_rest.pl
Requirements:
* [curl](https://curl.haxx.se/download.html) - version 6.1 or later
* [Perl](https://www.perl.org/get.html) - version 5.x

Included in this repository is a Perl script named `test_rest.pl` that makes calls to a backend web service using `curl`
commands, and prints the resulting responses.  It knows how to format a variety of requests to both the `bookmarks` and
`bookmark` endpoints, including a few requests that will demonstrate error responses.

```
# To see full documentation for this test script, including
# the list of all supported test requests, run:
./test_rest.pl --help

# Example of sending a GET request to the /rest/bookmarks endpoint
./test_rest.pl --verbose bookmarks
```

#### Note about the base URL
By default, this script assumes that the backend is reachable via port 8080 on localhost, under a path of `/rest`
(giving a base url of `http://localhost:8080/rest`), which should be true for most of the installation methods
documented for each of the backend web services associated with this project.  However, some of the alternate manual
installation methods could result in the backend being available via a different URL.  For more information, please see
the installation instructions in their respective README.md files.

For example, if the backend was instead reachable via `http://hostname:1234/backend`, you can pass that to the test
script like so:
```
BASE_URL=http://hostname:1234/backend ./test_rest.pl --verbose bookmarks
```

### Using curl directly
Requirements:
* [curl](https://curl.haxx.se/download.html) - version 6.1 or later

```
# Example of sending a GET request to the /rest/bookmarks endpoint
curl http://localhost:8080/rest/bookmarks

# Example of sending a POST request to the /rest/bookmark endpoint
curl -X POST -d "name=form_name&url=form_url" http://localhost:8080/rest/bookmark
```

NOTE: The examples above assume that the API is reachable via the default base URL described above.
port 8080 on localhost, which should be true if either installation Method 1 or Method 2 above was successfully used.

If the backend is available via a different base URL, then replace the `http://localhost:8080/rest` portions of the URLs
above with the customer base URL instead, like so:

```
curl http://hostname:1234/backend
curl -X POST -d "name=form_name&url=form_url" http://hostname:1234/backend/bookmark
```

## Expected output
Regardless of the test method used above, all of the responses from the API are expected to be JSON formatted, even when
an error has occurred.

### Successful response from /rest/bookmarks
A successful response from the /rest/bookmarks endpoint should be a JSON object with one key, `bookmarks`, whose value
is an array of JSON objects, one for each of the bookmarks in the blog (i.e. one for each of the rows in the `bookmarks`
table).  Initially, it should look like this:
```
{"bookmarks":[{"id":1,"name":"Google","url":"https://www.google.com"}]}
```

### Successful response from /rest/bookmark
A successful response from the /rest/bookmarks endpoint should be a JSON object with one key, `rows_affected` and the
value is the number of rows affected during the `INSERT` operation (should always be 1 for successful requests):
```
{"rows_affected":1}
```

### Error response from any endpoint
A successful response from the /rest/bookmarks endpoint should be a JSON object with six keys:

key     | value
--------| -------------
code    | The HTTP response code, e.g. 404, 405, etc.
message | The HTTP error message. Usually takes the form of "HTTP {code} {reason}"
method  | The HTTP request method, e.g. GET, POST, etc.
reason  | Brief description of the HTTP error, e.g. "Not Found" for 404 errors
status  | Should always be `ERROR`
uri     | The path portion of the request URL, e.g. /rest/bookmark, /rest/bookmarks, etc.

For example, here is the response from running `./test_rest.pl bad_path`:
```
{"code":404,"message":"HTTP 404 Not Found","method":"GET","reason":"Not Found","status":"ERROR","uri":"/bogus"}
```

## Author

* **Ben Marcotte** - [bmarcotte](https://github.com/bmarcotte)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
