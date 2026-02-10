# earnapp-docker

>**Note:** This image is unofficial, not affiliated with EarnApp, and comes with no warranty.


### Docker run
Run the container:
```sh
docker run -d \
  --name earnapp \
  -e EARNAPP_UUID=<your_earnapp_uuid> \
  ghcr.io/bhavishyadahiya/earnapp-docker:latest
```
alternatively , you can let the script create nodeid for you , and claim one node by using 
```docker logs <containerName>  ```
### Output
```sh
> docker logs earnapp
```
```
v1.570.397

✔ UUID:   sdk-node-xxxxxxxxxxxxxxxxxxxxxxxxx
✔ Status: enabled

⚠ You must register it for earnings to be added to your account.
⚠ Open the following URL in the browser:
  https://earnapp.com/r/sdk-node-xxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
