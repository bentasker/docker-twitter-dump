# Docker Twitter Dump

A dockerisation of [https://github.com/pauldotknopf/twitter-dump](https://github.com/pauldotknopf/twitter-dump).

Originally created to play around with [ingesting my Twitter history into InfluxDB](https://projects.bentasker.co.uk/gils_projects/issue/jira-projects/MISC/5.html), and then dusted off to archive Tweets following Musk's apparent determination to MySpace the birdsite.

---

### Usage

Usage of the utility is best described in the [Original Tool's README](https://github.com/pauldotknopf/twitter-dump) but:

Run the container, exporting the current directory into the container, and providing a username

    docker run --rm  -it -v $PWD:/output/ bentasker12/docker-twitter-dump bentasker

Once ready, the container will print some instructions (they work with Firefox as well as Chrome):

    Steps to authenticate:
    Step 1: With Chrome, authenticate with Twitter and then navigate to: https://twitter.com/search
    Step 2: Open Chrome developer tools
    Step 3: Open the Network tab on the developer tools
    Step 4: Filter requests for "adaptive.json"
    Step 5: Search for anything (doesn't matter)
    Step 6: Scroll down until a network request for "adapative.json" is made
    Step 7: Right click the request and click "Copy -> Copy as cURL"
    Step 8: Paste the contents of your clipboard below


This provides the utility with an auth token to use when listing your tweets.

It'll go off and fetch your tweets.

Eventually, in your current working directory, there will be a JSON file.


### JSON

The JSON structure is relatively straight forward to work with:
```
{
  "query": "(from:bentasker)",
  "tweets": [
    {
      "url": "https://twitter.com/bentasker/status/1588205974657048581",
      "id": 1588205974657048581,
      "created_at": "2022-11-03T16:26:26+00:00",
      "full_text": "@JimSycurity @IanColdwater The \"liquid\" part of this is *very* important.\n\nYes, you might see more growth in stocks/shares, but you're most likely to need that emergency fund while the market is down. It's a safety net, not an investment pot, and shouldn't be in capital-at-risk vehicles.",
      "user_id": 124810735
    },
    .. etc ..
    ],
 "users": [
    {
      "id": 166282004,
      "name": "Scott Helme",
      "screen_name": "Scott_Helme"
    },
    {
      "id": 124810735,
      "name": "Ben Tasker",
      "screen_name": "bentasker"
    },
    .. etc ..
    ]
}
```

When parsing in Python to ingest into InfluxDB, I did the following
```python
fh = open(sys.argv[1], 'r')
j = json.load(fh)
fh.close()

# Build a list of users by id
user_list = {}
for user in j['users']:
    user_list["user_" + str(user['id']) ] = {
                    "handle" : user['screen_name'],
                    "name" : user['name']
                }


print("Handling tweets from query {j['query']}")
for tweet in j['tweets']:
    # Do stuff
    
```


### License

MIT - see [LICENSE](LICENSE)
