# How to run

```shell
docker build -t ryo-kubota-page-fetcher .
docker run -it ryo-kubota-page-fetcher ash

# Save the contents of a web page
./fetch.rb https://www.google.com

# Multiple web pages
./fetch.rb https://www.google.com https://autify.com

# Record metadata
./fetch.rb --metadata https://www.google.com
```
