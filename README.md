# IAOHTTPStubsHandler

IAOHTTPStubsHandler is an extension to [AliSoftware/OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs) project that returns stubbed responses saved locally and enables easy mappings between file stubs and remote request URLS.  The handler automatically imports all stubs files, and serves them as best it can falling back on smart defaults.  The system will provide a HTTP status code, response time, and content type.

### Simple Example

The code below will return a 200 OK, image/jpeg, WiFi speed result

``` json

	"http://photos-e.ak.fbcdn.net/hphotos-ak-ash4/5041_98423808305_6704612_s.jpg" : {
		"file" : "file2.jpg",
	}

```

### Verbose Example

The code below will return a 200 OK, text/json, WiFi speed result

``` json

	"https://graph.facebook.com/19292868552" : {
		"file" : "file1.json",
		"response_code" : 200,
		"response_speed" : "OHHTTPStubsDownloadSpeedWifi",
		"content_type" : "text/json"
	}

```

## Notes
Built and tested on iOS 5.1 only.  Should be backwards compatible to iOS 5.0.

## Requirements
 - ARC
 - MobileCoreServices Framework
 - NSJSONSerialization Methods

## Install
1. Add the MobileCoreServices Framework to your project
2. Copy and paste the folders and files inside the 'Classes' folder inside the project, add them to your project and #import "IAOHTTPStubsHandler.h" in your App Delegate
3. Copy and paste the 'Stubs' folder and 'mappings.json' file inside the 'Stubs' folder into the root of your project.
4. Add the 'Stubs' folder to your project - making sure to select 'Create folder references for any added folders'.  This will save time as you add more stubs to your project.
5. In application:didFinishLaunchingWithOptions: enable stubbed responses by adding the line:

``` objective-c
	
	[IAOHTTPStubsHandler activateStubsResponses];

```

## Configuration
Alter the mappings.json file by adding your own stubs.  The format is as follows:

``` json

	"REMOTE_URL" : {
		"file" : "LOCAL_FILENAME_AND_EXTENSION",
		"response_code" : HTTP_RESPONSE_CODE,
		"response_speed" : "OHHTTPSTUBS_DOWNLOAD_SPEED",
		"content_type" : "MIME_TYPE"
	}

```

## Example
A small iPhone example is inside the project to demo functionality.

## Creator
 - [Ian Outterside](http://www.twitter.com/ianoshorty)

## Credits
In addition to the creator, the following are credited:

 - [Olivier Halligon - AliSoftware/OHHTTPStubs](https://github.com/AliSoftware/OHHTTPStubs)
 - [AFNetworking](https://github.com/AFNetworking/AFNetworking)

## License
A Licence file is included.  Code is completely Open Source, just give me a credit if you use ;).

## Legal
I hereby accept NO liability or responsibility if using this code causes any problems for you.  Always check and test before you import other frameworks / libraries and files into your projects! See LICENCE file.