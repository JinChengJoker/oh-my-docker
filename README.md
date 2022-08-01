## 构建 Docker 镜像

```bash
docker build . -t jinchengjoker/oh-my-docker:tagname
```


## 启动容器

```bash
docker run -it --name oh-my-docker jinchengjoker/oh-my-docker:tagname
```


## 推送至 Docker Hub

```bash
docker push jinchengjoker/oh-my-docker:tagname
```