trap 'sigterm' 15

sigterm()
{
  echo "Caught SIGKTERM 15 ..."
  echo "Okay, I'll stop gracefully instead..."
  exit 1
}
 
for i in {1..1000}; do sleep 1; echo $i; done