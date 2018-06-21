# ClusterTest

A Basic phoenix app to test librancher with OTP21

```
$ docker-compose up -d --build
```

```
$ docker-compose logs -f node1
```

```
$ docker-compose logs -f node2
```

currently connected:
```
node2_1  | 09:55:08.971 [info] [libcluster:dns_poll_example] connected to :"service@172.18.0.2"
node2_1  | 09:55:09.029 [info] Running ClusterTestWeb.Endpoint with Cowboy using http://:::4000
```

also it's possible to check with a console:

```
docker-compose run --rm node1 console
```

```
09:56:16.032 [info] [libcluster:dns_poll_example] connected to :"service@172.18.0.3"
Interactive Elixir (1.6.6) - press Ctrl+C to exit (type h() ENTER for help)
iex(service@172.18.0.4)1> Node.self
:"service@172.18.0.4"
iex(service@172.18.0.4)2> Node.list
[:"service@172.18.0.3", :"service@172.18.0.2"]
```
