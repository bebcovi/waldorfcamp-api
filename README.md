# Waldorfcamp

## API setup

1. Run `bundle install`
2. Run `bundle exec rake db:setup`
2. Ask for the `.env` file with credentials
3. Run `bundle exec rake cache_photos`
  * this downloads all photo info and caches it to the database, so it will
    take a while
  * You can run `bundle exec rake cache_flickr_photos` or `bundle exec rake
    cache_facebook_photos` if you want to update just one storage.
4. Run `bundle exec rackup` to start the server (on port `9292`)

Now you're ready to make requests to the endpoint:

```http
GET /photos HTTP/1.1
```
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "data": [
    {
      "type": "photos",
      "id": "1529498",
      "attributes": {
        "description": "Here we are clibming on a tree",
        "small": {
          "width": 320,
          "height": 280,
          "url": "https://example.com/small.jpg"
        },
        "medium": {
          "width": 500,
          "height": 350,
          "url": "https://example.com/medium.jpg"
        },
        "large": {
          "width": 800,
          "height": 720,
          "url": "https://example.com/large.jpg"
        },
        "original": {
          "width": 1024,
          "height": 800,
          "url": "https://example.com/original.jpg"
        }
      }
    }
  ]
}
```

The sizes are organized by size (and not always each size will be available):

* Small images have width between 0 to 400
* Medium images have width between 400 to 800
* Large images have width between 800 to 1200

It's required that you always specify pagination parameters:

* `page` (integer)
* `perPage` (integer)

You can also search by tags:

```http
GET /photos?tags=circus,singing&page=1&perPage=25 HTTP/1.1
```

The above request will return all photos tagged either with "circus" or
"singing".
