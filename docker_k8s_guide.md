# Docker+Kubernetes集群部署Rails项目

## 简介

- [Docker](https://baike.baidu.com/item/Docker/13344470?fr=aladdin)

- [Kubernetes](https://baike.baidu.com/item/kubernetes/22864162?fr=aladdin)

- [Ruby on Rails](https://baike.baidu.com/item/rails/10962333?fr=aladdin)

环境搭建时参考了文章[從零搭建，如何讓Rails跑在Kubernetes(k8s)](https://blog.niclin.tw/2018/11/30/%E5%BE%9E%E9%9B%B6%E6%90%AD%E5%BB%BA%E5%A6%82%E4%BD%95%E8%AE%93-rails-%E8%B7%91%E5%9C%A8-kubernetesk8s%E4%BA%8C/)和官方文档[Quickstart: Compose and Rails](https://docs.docker.com/compose/rails/)

## 前期准备

本篇环境搭建指南使用**macOS 10.14 Mojave**操作系统

关于Docker的安装，通过以下链接下载[Stable](https://download.docker.com/mac/stable/Docker.dmg)版本的Docker for Mac。

鉴于国内网络问题，后续拉取Docker镜像十分缓慢，我们可以配置加速器来解决，我使用的是镜像地址：`https://registry.docker-cn.com`。

在任务栏点击 Docker for mac 应用图标 -> Perferences... -> Daemon -> Registry mirrors。在列表中填写加速器地址即可。修改完成之后，点击 Apply & Restart 按钮，Docker 就会重启并应用配置的镜像地址了。

Rails项目使用之前课程设计完成的**学生竞赛管理系统(SCMS)**，该系统使用Ruby 2.6.3、Rails 5.2.3和PostgreSQL数据库开发。

## Rails App容器化

下面进行部署的第一步：通过Docker-compose将Rails App容器化。

总共需要在Rails项目主目录下创建四个部署文件，如图所示

![创建四个部署文件](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/1.png)

首先创建建立容器所需的文件`Dockfile`，在Rails项目主目录下执行命令`touch Dockerfile`，添加如下内容

```
FROM ruby:2.6.3

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y build-essential libpq-dev

RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y postgresql-client

RUN mkdir /CompetitionManagement

WORKDIR /CompetitionManagement

ADD Gemfile /CompetitionManagement/Gemfile
ADD Gemfile.lock /CompetitionManagement/Gemfile.lock

RUN bundle install

ADD . /CompetitionManagement

COPY docker-entrypoint.sh /usr/local/bin

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh /

ENTRYPOINT ["docker-entrypoint.sh"]
```

其中需要注意的是，不能够直接运行`apt-get install -y nodejs`，需要通过这两条命令`RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
  RUN apt-get install -y nodejs`安装version10的nodejs。Ruby镜像的操作系统为Debian，直接安装的nodejs版本最高为4.8.2，由于Rails项目版本较高，后期会出现如下错误

![nodejs版本过低](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/6.png)

接下来创建文件`docker-entrypoint.sh`，在Rails项目主目录下执行命令`touch docker-entrypoint.sh`，添加如下内容

```
#!/bin/sh
set -e
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi
exec "$@"
```

这个脚本会在重新启动Rails App时杀掉server.pid从而避免卡住的问题。

接着建立Docker-compose配置文件`docker-compose.yml`，在Rails项目主目录下执行命令`touch docker-compose.yml`，添加如下内容

```
version: "3"
services:
  db:
    image: postgres
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=mysecurepass
      - POSTGRES_DB=CompetitionManagement_development
      - PGDATA=/var/lib/postgresql/data

  app:
    build: .
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b '0.0.0.0'"
    volumes:
      - .:/CompetitionManagement
    ports:
      - "3000:3000"
    depends_on:
      - db
```

我们采用的方法是将PostgreSQL数据库与Rails App分离到两个容器中，所以在这个文件中设置好PostgreSQL之后要用到的环境变量，同时要将Rails项目中的数据库连接配置文件`config/database.yml`进行修改，修改后内容如下

```
default: &default
  adapter: postgresql
  encoding: unicode
  host: db
  username: postgres
  password: mysecurepass
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  port: 5432

development:
  <<: *default
  database: CompetitionManagement_development

test:
  <<: *default
  database: CompetitionManagement_test

production:
  <<: *default
  database: CompetitionManagement_production
  username: CompetitionManagement
  password: <%= ENV['COMPETITIONMANAGEMENT_DATABASE_PASSWORD'] %>
```

这里有个需要注意的地方，配置中这行代码`host: db`不能缺少，由于Rails项目默认连接的数据库为localhost的数据库，所以需要在这里设置host参数让Rails项目连接到之后的PostgreSQL镜像的数据库。

最后为了避免一些不必要的临时文件和缓存文件被加入到容器中，需要建立文件`.dockerignore`，在Rails项目主目录下执行命令`touch .dockerignore`，添加如下内容

```
tmp/*
log/*
```

以上便完成了所有的配置文件的创建与编写。下面便可以进行Rails App的容器化了。在Rails项目主目录下输入命令`docker-compose build`，使用Docker-compose进行容器化，这时候就能看到Docker在执行脚本，并且出现如下内容

![容器化](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/2.png)

![容器化](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/3.png)

执行容器化的过程可能会因为网络问题出现无法进行`apt-get update`的情况，可以多次尝试。

接下来获取PostgreSQL的Docker镜像，在终端中输入命令`docker pull postgres`，将获取latest版本的PostgreSQL。

下面便可以启动Docker容器了，在Rails主目录下执行命令`docker-compose up app`，便能在终端中看到以下内容

![执行Docker](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/4.png)

接着另开一个终端，在Rails主目录下执行命令`docker-compose run app rails db:create db:migrate`，用于Rails项目数据库的创建以及数据表的迁移，可以见到如下内容

![运行数据库迁移](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/5.png)

以上操作完成后，便能以Docker容器形式运行Rails项目了。在浏览器中输入`localhost:3000`，进入Rails Web应用的主目录。

## 容器化Rails App在Kubernetes中运行

### 前期准备

需要pull以下docker images

![docker images](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/docker_images.png)

进行Kubernetes部署前需要安装好以下两个工具：

- Kubectl
- Minikube

`Kubectl`可以通过输入命令`brew install kubernetes-cli`进行安装，这里是macOS的安装方式，Ubuntu系统会有所不同。

安装后输入`kubectl version`便能看到安装的kubectl版本

```
Client Version: version.Info{Major:"1", Minor:"15", GitVersion:"v1.15.0", GitCommit:"e8462b5b5dc2584fdcd18e6bcfe9f1e4d970a529", GitTreeState:"clean", BuildDate:"2019-06-20T04:49:16Z", GoVersion:"go1.12.6", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"14", GitVersion:"v1.14.1", GitCommit:"b7394102d6ef778017f2ca4046abbaa23b88c290", GitTreeState:"clean", BuildDate:"2019-04-08T17:02:58Z", GoVersion:"go1.12.1", Compiler:"gc", Platform:"linux/amd64"}
```

这里刚安装后输入命令查看版本时可能出现以下错误

```
Unable to connect to the server: dial tcp 192.168.99.100:8443: i/o timeout
```

和

```
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```

这两个错误可以暂时先忽略，因为这时候还没有启动Kubernetes集群，因此出现这种错误。

下面安装`Minikube`。什么是Minikube？官方介绍是

> Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a Virtual Machine (VM) on your laptop for users looking to try out Kubernetes or develop with it day-to-day.

可以理解为：Minikube是一个快速搭建单节点Kubenetes集群的工具，相当于一个运行在本地的Kubernetes单节点，我们可以在里面创建Pods来创建对应的服务。

安装Minikube前需要安装VirtualBox，不然会出现如下错误

![未安装VirtualBox错误](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/8.png)

Mac可以通过命令`brew cask install virtualbox`进行VirtualBox的安装，安装时可以见到如下内容

![安装VirtualBox](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/9.png)

安装完VirtualBox之后便可以开始安装Minikube，这里需要注意！

在终端输入以下命令：

```
curl -Lo minikube http://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/releases/v1.0.1/minikube-darwin-amd64 && sudo chmod +x minikube && sudo mv minikube /usr/local/bin/
```

**_minikube必须从阿里仓库上下载，如果从官方下载会安装引起后面的启动失败（除非可以翻墙VPN）_**

下载完成后，执行以下命令启动Minikube

```
minikube start --registry-mirror=https://registry.docker-cn.com
```

![Minikube安装](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/12.png)

启动过程中可能会遇到镜像无法pull的情况，如下图

![镜像无法pull](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/10.png)

这里可以通过使用docker命令提前pull镜像来解决

![docker pull](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/11.png)

成功启动后，可以通过执行以下命令查看pods状态

```
kubectl get nodes
```

执行以下命令进入控制台Dashboard

```
minikube dashboard
```

默认会打开浏览器界面

![minikube dashboard](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/13.png)

![minikube dashboard](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/14.png)

### 本地镜像上传

之后建立container容器时需要从云端pull镜像，这里先将本地镜像上传至云端。由于国内网络问题，无法使用Docker Hub镜像仓库，这里使用阿里云容器镜像仓库。

上传的本地镜像有两个，一个是Rails App镜像，一个是PostgreSQL镜像。

关于阿里云容器镜像仓库的创建与上传这里就不介绍了。目前镜像已经上传至阿里云公开容器镜像仓库，可以通过`docker pull registry.cn-hangzhou.aliyuncs.com/yangyi_deng/competitionmanagement:v1`来pull Rails App项目镜像，通过`docker pull registry.cn-hangzhou.aliyuncs.com/yangyi_deng/postgres:latest`来pull PostgreSQL数据库镜像。

### 建立Database service

首先要建立Kubernetes的secrets

执行以下三条命令

```
kubectl create secret generic db-user-pass --from-literal=password=mypass

kubectl create secret generic db-user --from-literal=username=postgres

kubectl create secret generic railsapp-secrets --from-literal=secret-key-base=
```

![secrets](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/15.png)

第三条指令的secret-key-base的值是用rails的`rails secret`生成的。

下面在Rails项目主目录下建立目录kube，在目录kube下建立目录deployments，在目录deployments下创建文件`db.yaml`，输入以下内容

```
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
  generation: 1
  labels:
    run: db
  name: db
  namespace: default
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      run: db
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: db
    spec:
      containers:
      - env:
        - name: DATABASE_USER
          value: "postgres"
        - name: DATABASE_PASSWORD
          value: "mypass"
        - name: POSTGRES_DB
          value: "rails-app-db"
        - name: PGDATA
          value: "/var/lib/postgresql/data"
        image: registry.cn-hangzhou.aliyuncs.com/yangyi_deng/postgres:latest
        imagePullPolicy: IfNotPresent
        name: db
        ports:
        - containerPort: 5432
          protocol: TCP
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
```

这里需要注意的是，`imagePullPolicy: IfNotPresent`这段配置的意思是，当镜像在本地获取不到时，才向云端pull镜像。

下面开始生成Database Service。

在创建pod生成service的过程中可能会遇到如下错误

![service error](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/16.png)

可以通过执行如下代码进行解决

![fix](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/17.png)

在Rails项目主目录下执行命令`kubectl create -f kube/deployments/db.yaml`，创建数据库的pod。

输入`kubectl get pods`查看pod的状态，当pod的status变成running时，便成功启动了pod。pod的状态可以直接在控制台Dashboard中查看。

pod成功启动后，便能将数据库pod expose出去成为service。执行命令`kubectl expose deployment db`,通过命令`kubectl get services`或者直接在Dashboard查看，能够看见新建立的database service。

### 建立Rails App Service

新建文件`kube/deployments/rails.yaml`，输入以下内容

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
  generation: 1
  labels:
    run: app
  name: app
  namespace: default
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      run: app
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        run: app
    spec:
      containers:
      - command:
        - rails
        - s
        - -p
        - "3000"
        - -b
        - 0.0.0.0
        image: registry.cn-hangzhou.aliyuncs.com/yangyi_deng/competitionmanagement:v1
        imagePullPolicy: IfNotPresent
        env:
        - name: DATABASE_URL
          value: "postgres"
        - name: DATABASE_NAME
          value: "rails-app-db"
        - name: DATABASE_PORT
          value: "5432"
        - name: DATABASE_USER
          valueFrom:
            secretKeyRef:
              name: "db-user"
              key: "username"
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: "db-user-pass"
              key: "password"
        - name: SECRET_KEY_BASE
          valueFrom:
            secretKeyRef:
              name: "railsapp-secrets"
              key: "secret-key-base"
        name: app
        ports:
        - containerPort: 3000
          protocol: TCP
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
```

接着和database service一样创建pod和service。输入命令`kubectl create -f kube/deployments/rails.yaml`，当pod成功启动后，执行数据库迁移命令`kubectl exec -it POD_NAME rails db:migrate`，这里的POD_NAME要替换成自己项目运行时pod的具体名称，比如`app-655469bcc8-x9chm`

成功运行后如图所示

![database migrate](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/18.png)

接着将Rails App expose出去，执行命令`kubectl expose deployment app --type=NodePort`

运行结果如图

![app expose](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/19.png)

这时可以打开Dashboard查看每个pod与service的状态，具体界面如下

![dashboard](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/20.png)

![dashboard](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/21.png)

最后一步，执行命令`minikube service app`启动service，命令执行情况如下

![service app](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/22.png)

命令结束将会直接打开浏览器的Web界面，如图

![Web](https://raw.githubusercontent.com/YanyiDeng/CompetitionManagement/DockerDeploy/img-folder/23.png)

**成功运行！**
