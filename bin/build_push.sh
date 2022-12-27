docker build -t hello-world .
docker run -p 9000:8080 hello-world
docker push ########.dkr.ecr.us-east-1.amazonaws.com/hello-world:latest