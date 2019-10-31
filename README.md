Coding challenge
---
install deps:
```
bundle install
```
run:
```
ruby app.rb
```
test:
```
ruby app_spec.rb
```
example query:
```
localhost:4567/?address=Prague
```
___
Made with:
 - Sinatra - was interesting to try it, and it seems to be better solution (than Rails) for small one-endpoint microservice.
 - Hands

Time consumed:
 - ~ 2 hours

App receives GET request with one param and  returns:
1. notice message if no address queried
2. error messages if something went wrong: connection or bad query responses
3. lat/lon object of queried address if all went right

There are no genius archictural decisions due to simplicity of task. However we can make it better:
1) use Geocoder gem and free our mind :)
2) Decouple code into separate methods: for errors, for success. Extract external API calls to more configurable class/module
3) store ACCESS_TOKEN and maybe LOCATIONIQ_URI in environment (.env), not directly in code (that's not safe)


