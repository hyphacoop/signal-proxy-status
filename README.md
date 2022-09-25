# Signal Proxy Status

Signal proxies allow for people to access Signal's services from regions where the company's servers are blocked. See [Help people in Iran reconnect to Signal – a request to our community](https://signal.org/blog/run-a-proxy/).

This respository contains instructions and scripts to check a list of proxies by domain name, to see whether the proxy is still functional. We have also included instructions to scrap recent Tweets where public proxies are announced with the `#IRanASignalProxy` hashtag. You can also include privately acquired proxies (e.g. via DM) to the list for checking.

## Steps

### Getting a list of public proxies from Twitter

[Get Twitter API access](https://developer.twitter.com/en/portal/dashboard) via Bearer Token so we can search recent Tweets, then set `BERER_TOKEN` in your local environment:

```
BEARER_TOKEN=<get-your-own-token>
```

To scrap for Signal proxies, this spell works reasonably well:

```
curl -s -H "Authorization: Bearer $BEARER_TOKEN" "https://api.twitter.com/2/tweets/search/recent?max_results=100&tweet.fields=entities&query=%23IRanASignalProxy+signal.tube+-is%3Aretweet" | jq -r '.data[].entities.urls[].expanded_url' | grep 'signal.tube' | sed 's|.*//signal.tube/#||' | sed 's|.*//signal.tube/||' | sort | uniq
```

Example results:

```
curl -s -H "Authorization: Bearer $BEARER_TOKEN" "https://api.twitter.com/2/tweets/search/recent?max_results=100&tweet.fields=entities&query=%23IRanASignalProxy+signal.tube+-is%3Aretweet" | jq -r '.data[].entities.urls[].expanded_url' | grep 'signal.tube' | sed 's|.*//signal.tube/#||' | sed 's|.*//signal.tube/||' | sort | uniq

1st-signal.pl
FreeIran2022.io
anti-blackout.xyz
azuze.fr
bazinga-coffee.xyz
blue01.java-cup.de
c-67-180-134-4.hsd1.ca.comcast.net
censor.lol
eagle.got-freedom.net
elhst.com
[...]
```

Pipe the results to a file with `> proxies.txt` at the end of the `curl`.

### Checking the list of proxies to see which ones are functional

Ideally, this step should be done from the region where the IP addresses of these proxies may be censored. However, running this from anywhere will flag proxies that are incorrectly configured or no longer in operation.

All you need to do is run `./check_proxy.sh` from this directory root, and the script will take the `proxies.txt` from the previous step, and test each proxy in the file. If you have private proxies you want to test, feel free to add to the `proxies.txt` file. The results are printed in the Terminal output and also recorded in `results.txt`.

```
❯❯❯ ./check_proxy.sh
2022/09/25 19:12:49 socat[70373] E OPENSSL: empty host name
 ❌
------------------
2022/09/25 19:12:51 socat[70387] E certificate is valid but its commonName does not match hostname "1st-signal.pl"
1st-signal.pl ❌
------------------
2022/09/25 19:12:53 socat[70397] E getaddrinfo("FreeIran2022.io", "NULL", {1,0,1,6}, {}): nodename nor servname provided, or not known
FreeIran2022.io ❌
------------------
anti-blackout.xyz ✅
------------------
azuze.fr ✅
------------------
bazinga-coffee.xyz ✅
------------------
blue01.java-cup.de ✅
------------------
2022/09/25 19:13:09 socat[70457] E connect(8, LEN=16 AF=2 67.180.134.4:443, 16): Connection refused
c-67-180-134-4.hsd1.ca.comcast.net ❌
------------------
censor.lol ✅
------------------
```

The `results.txt` file looks like this:

```
❯❯❯ cat results.txt
 ❌
1st-signal.pl ❌
FreeIran2022.io ❌
anti-blackout.xyz ✅
azuze.fr ✅
bazinga-coffee.xyz ✅
blue01.java-cup.de ✅
c-67-180-134-4.hsd1.ca.comcast.net ❌
censor.lol ✅
```

If somehow you need to run the script from another directory, make sure you copy over `signal_CA.crt`, because the script needs it to verify the traffic.

Please avoid posting private proxies onto the open Internet, as that would make them easily identifiable and blocked.

>When you publicly post a signal.tube link, or if a particular server becomes too popular, it increases the chance that Iranian censors will simply add those IPs to their block list.
>
>A more discreet approach would be to only send the link via a DM or a non-public message.
>
>-- https://signal.org/blog/run-a-proxy/


## Related links

- https://signal.org/blog/run-a-proxy/
- https://support.signal.org/hc/en-us/articles/360056052052-Proxy-Support
- https://support.signal.org/hc/fa/articles/360056052052-%D9%BE%D8%B4%D8%AA%DB%8C%D8%A8%D8%A7%D9%86%DB%8C-%D8%A7%D8%B2-%D9%BE%D8%B1%D9%88%DA%A9%D8%B3%DB%8C
