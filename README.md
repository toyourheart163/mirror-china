# mirror-china
mirrors of china 中国镜像自动化设置脚本，包含 pip pub npm yarn

### 配置

```bash
git clone //github.com/toyourheart163/mirror-china && cd mirror-china && chmod +x mirror.sh && mv mirror.sh
/usr/local/bin/mirror
```

### 使用

```bash
# set mirror
mirror pip
       npm
       yarn
       pub
# unset mirror
mirror pip unset

# list mirror
mirror list
```

### 有些不配置

- mac `brew` 不配置，因为自带了 cdn 
- git 使用代理或者码云加速一下
  * `git clone --depth 1 $url`

### 有需要时再更新
