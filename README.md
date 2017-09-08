# Memory leak demonstration

```sh
git clone https://github.com/sullerandras/grpc-memory-leak.git
cd grpc-memory-leak

go get -u google.golang.org/grpc/examples/helloworld/greeter_server
greeter_server &

bundle install
ruby test_no_docker.rb
```

You will see in `top` or any other tool that the memory usage goes up.
