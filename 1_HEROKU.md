### Heroku

## Why?
* To deploy a simple Rails application and host it for free
* To understand the importance of DNS
* How did your code get there?

## How?
Follow the instructions here:
https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction

You only need to do the first 4 steps in the introduction to get a feel of the
Heroku basics.

## Pricing?
https://www.heroku.com/pricing

The "Hobby" tier of Heroku is comparable in metrics to the t2.nano AWS instance (computer) type. While Heroku charges you 7$/month AWS would charge only
$4.307/month or $3.650/month if you make a year long commitment. From metrics
like this we build a notion that Heroku is 35-40% more expensive than AWS. But that picture is not as clear when you take setup time into account. Show a picture of a car and car parts.

## Notes
[Removing
active_record](http://stackoverflow.com/questions/19078044/disable-activerecord-for-rails-4) stuff if you don't need it.

If there are issues with sqllite gem
```
heroku config:set NODEMODULESCACHE=false
git commit -am 'rebuild' --allow-empty
git push heroku master
heroku config:unset NODEMODULESCACHE
```
