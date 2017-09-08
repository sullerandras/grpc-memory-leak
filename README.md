# Memory leak demonstration

```sh
go get -u google.golang.org/grpc/examples/helloworld/greeter_server
greeter_server &
ruby test_no_docker.rb
```

You will see in top or any other tool that the memory usage goes up.
