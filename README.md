# Introduction
[![Build Status](https://travis-ci.org/g0v/laweasyread.png)](https://travis-ci.org/g0v/laweasyread)
[![Dependencies Status](https://gemnasium.com/g0v/laweasyread.png)](https://gemnasium.com/g0v/laweasyread)

# API
All APIs support [JSONP](http://en.wikipedia.org/wiki/JSONP) so it can be
called with callback parameter.

The date related fields in JSON are all ISO-8601 format (ex: 2013-03-31).

## /api/law/:query
This API returns law information. Thq query shall be a full law name like
`中華民國憲法`. The return is a JSON with the following information:

    {
        'isSuccess': boolean // This API call is success or not
        'reason': string // API fail reason. Not exist if isSuccess is true
        'law': { // Will not exist if isSuccess is false
            'name': [ // Name of law might be changed, so it is an array to record all its names.
                {
                    'name': string // Name of law
                    'date': string // Start date of name
                }
            ]
            'history': // Object within which keys are dates and values are what's done on that day
            'lyID': string // lyID is used in http://lis.ly.gov.tw/lgcgi/lglaw
            'PCode': string // PCode is used in http://law.moj.gov.tw/
        }
    }

## /api/article (Ver 1)
This API returns article in law.

### Require parameters:
*   __name__: Name of law
*   __article__: Article of law in `/^\d+(-\d+)?$/` format
e.g. http://laweasyread.herokuapp.com/api/article?name=中華民國憲法&article=1

### Optional parameters:
*   __date__: Date of article is [ISO-8601](http://en.wikipedia.org/wiki/ISO_8601) (YYYY-MM-DD) format. Default is today.

### Return JSON
    {
        'isSuccess': boolean // This API call is success or not
        'ver': 1 // API version
        'reason': string // API fail reason. Not exist if isSuccess is true
        'article': { // Will not exist if isSuccess is false
            'name': string // Name of law requested
            'article': // Article of law requested
            'passed_date': string // Pass date in ISO-8601 format.
            'content': string // Article content. The leading two whitespaces are removed.
        }
    }

## /api/suggestion/:query
This API returns possible law names from query.

The following is return JSON:

    {
        'isSuccess': boolean // This API call is success or not
        'reason': string // API fail reason. Not exist if isSuccess is true
        'suggestion': [ // Will not exist if IsSuccess is false
            {
                'law': string // law name
            }
            ...
        ]
    }
# Development

## Unit Test
Use the following command to run unit test for this package:

    npm test

You can see console output for unit test result.

The coverage reports are also generated. For client side, the report is in
`coverage/<browser>/index.html`. For server side, the report is in
`coverage/report.html`.

## Automation
The project uses [Grunt](http://gruntjs.com/) to do the following tasks when
source file changed:

* Compile package.ls and run `npm install`
* Compile LiveScript source and run `npm test`

In order to use this feature, you need to install
[grunt-cli](https://npmjs.org/package/grunt-cli) with the following command:

    npm install -g grunt-cli

After that, you can use the following command to monitor file changed:

    grunt

## Environment Variable

### LAWEASYREAD\_COV
The `LAWEASYREAD_COV` is used to indicate that we are generating server side
coverage report now. In this case, we need to require different source to do so.
The coverage source is generated by
[jscoverage](https://npmjs.org/package/jscoverage) in
[test.js](https://github.com/g0v/laweasyread/blob/master/test.js). The path of
coverage code is `lib-cov`. To require correct `lib` or `lib-cov`, you need to
require root directory, and then index.js in root directory will require the
correct one for you.

# Reference
* [https://github.com/g0v/laweasyread-data](https://github.com/g0v/laweasyread-data)
* [https://github.com/g0v/twlaw](https://github.com/g0v/twlaw)
* [立法院法律系統](http://lis.ly.gov.tw/lgcgi/lglaw)
